//
//  Errplane.m
//  errplane-ios
//
//  Created by Geoff Dix jr. on 2/15/13.
//  Copyright (c) 2013 Errplane. All rights reserved.
//

#import "Errplane.h"
#include <UIKit/UIKit.h>
#include <CommonCrypto/CommonDigest.h>
#include <objc/objc-sync.h>

#import "EPReportHelper.h"
#import "EPHTTPPostHelper.h"
#import "EPDefaultExceptionHash.h"
#import "EPExceptionDetailHelper.h"

@implementation Errplane

static NSURL* errplaneUrl = nil;

// default Errplane url
static NSString* urlStr = nil;

static NSMutableArray* reportQueue = nil;
static dispatch_queue_t dispatchQueue = nil;
static int RPT_CAPACITY = 100;
static EPDefaultExceptionHash* hashFunc = nil;

/**
 Creates the asynchronous run loop that handles all reports.
 */
+ (void) load {
    reportQueue = [[NSMutableArray alloc] initWithCapacity:RPT_CAPACITY];
    dispatchQueue = dispatch_queue_create("com.errplane.reportingQueue", DISPATCH_QUEUE_SERIAL);
    // create and start the queue
    dispatch_async(dispatchQueue, ^{
        while (true) {
            if ((errplaneUrl != nil) && ([reportQueue count] > 0)) {
                NSArray* reports = nil;
                @synchronized(reportQueue) {
                    NSRange rptCount = {0, [reportQueue count]};
                    reports = [reportQueue objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:rptCount]];
                }
                
                for (int i = 0; i < [reports count]; i++) {
                    EPReportHelper* eprh = [reports objectAtIndex:i];
                    int iter = 0;
                    BOOL sendSuccess = [self sendReport:eprh];
                    while((sendSuccess == NO) && (iter < 3)) {
                        sendSuccess = [self sendReport:eprh];
                        iter++;
                    }
                    @synchronized(reportQueue) {
                        [reportQueue removeObject:eprh];
                    }
                }
            }
        }
    });
}

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        hashFunc = [[EPDefaultExceptionHash alloc] init];
        urlStr = @"https://apiv2.errplane.com/databases/";
    }
}

- (void) dealloc {
    [errplaneUrl release];
    [reportQueue release];
    [hashFunc release];
}

+ (BOOL) initWithApiKey:(NSString *)api appKey:(NSString *)app environment:(NSString *)env {
    
    BOOL success = YES;
    if ((api == nil) || (app == nil) || (app == nil) || (env == nil)) {
        success = NO;
    }
    else {
        // this could be a re-init
        if (errplaneUrl) {
            [errplaneUrl release];
        }
        
        NSMutableString* errplaneUrlStr = [[NSMutableString alloc] initWithString:urlStr];
        [errplaneUrlStr appendString:app];
        [errplaneUrlStr appendString:env];
        [errplaneUrlStr appendString:@"/points?api_key="];
        [errplaneUrlStr appendString:api];
        errplaneUrl = [[NSURL alloc] initWithString:errplaneUrlStr];
        [errplaneUrlStr release];
        if (errplaneUrl == nil) {
            success = NO;
        }
    }
    return success;
}

+ (void) setUrl:(NSString *)url {
    [url retain];
    [urlStr release];
    urlStr = url;
}

+ (void) exceptionHashOverride:(EPDefaultExceptionHash *)hashFuncOverride {
    [hashFuncOverride retain];
    [hashFunc release];
    hashFunc = hashFuncOverride;
}

+ (void) setSessionUser:(NSString *)sessUser {
    [EPExceptionDetailHelper setSessionUser:sessUser];
}

+ (void) flush {
    if ([reportQueue count] > 0) {
        // run the background task to complete sending reports
        UIBackgroundTaskIdentifier bti = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
        
        // keep checking if the queue is empty, but don't wait longer than 1 minute
        int waitCount = 0;
        while (([reportQueue count] > 0) && (waitCount <= 60)) {
            [NSThread sleepForTimeInterval:1];
            waitCount++;
        }
        
        if (bti != UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:bti];
        }
    }
}

+ (void) breadcrumb:(NSString *)bc {
    [EPExceptionDetailHelper breadcrumb:bc];
}

+ (NSString*) sha1: (NSString*)toHash {
    
    
    NSMutableString* hashed = [[[NSMutableString alloc] init] autorelease];
    
    // hash it
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    NSData *stringBytes = [toHash dataUsingEncoding:NSUTF8StringEncoding];
    if (CC_SHA1([stringBytes bytes], [stringBytes length], digest)) {
        for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
            [hashed appendFormat:@"%02x", digest[i]];
        }
    }
    
    return hashed;
}

/**
 Sends the report to the Errplane server via HTTP POST.
 @param eprh the EPReportHelper containing the report data.
 */
+(BOOL) sendReport:(EPReportHelper*) eprh {
    
    BOOL success = NO;
    NSHTTPURLResponse *response;
    NSError *error;
    
    [eprh setErrplaneUrl:errplaneUrl];
    
    [eprh generateBody];
    
    [NSURLConnection sendSynchronousRequest:
        [EPHTTPPostHelper generateRequestForReport:eprh] returningResponse:&response error:&error];
    if (response.statusCode == 201) {
        success = YES;
    }
    return success;
}

+ (EPReportHelper*) getHelper: (NSString*) name {
    EPReportHelper* retHelper = nil;
    
    @synchronized(reportQueue) {
        if ([reportQueue count] < RPT_CAPACITY) {
            if ((name != nil) && ([name length] < 250)) {
                retHelper = [EPReportHelper alloc];
                if (![retHelper initWithName:name]) {
                    [retHelper release];
                    retHelper = nil;
                }
                else {
                    [reportQueue addObject:retHelper];
                }
            }
        }
    }
    
    return retHelper;
}

+ (BOOL) report:(NSString*) name {
    EPReportHelper* helper = [self getHelper:name];
    
    BOOL success = YES;
    if (helper == nil) {
        success = NO;
    }
    else {
        [helper setReportInt:[NSNumber numberWithInt:1]];
    }
    
    return success;
}

+ (BOOL) report:(NSString*) name withInt:(int) value {
    EPReportHelper* helper = [self getHelper:name];
    BOOL success = YES;
    if (helper == nil) {
        success = NO;
    }
    else {
        [helper setReportInt:[NSNumber numberWithDouble:value]];
    }
    
    return success;
}

+ (BOOL) report:(NSString*) name withDouble:(double) value {
    EPReportHelper* helper = [self getHelper:name];
    BOOL success = YES;
    if (helper == nil) {
        success = NO;
    }
    else {
        [helper setReportDouble:[NSNumber numberWithDouble:value]];
    }
    
    return success;
}

+ (BOOL) report:(NSString*) name withContext:(NSString*) context {
    EPReportHelper* helper = [self getHelper:name];
    
    BOOL success = YES;
    if (helper == nil) {
        success = NO;
    }
    else {
        [helper setReportInt:[NSNumber numberWithInt:1]];
        [helper setReportContext:context];
    }
    
    return success;
    
}

+ (BOOL) report:(NSString*) name withInt:(int)value andContext:(NSString *)context {
    
    EPReportHelper* helper = [self getHelper:name];
    
    BOOL success = YES;
    if (helper == nil) {
        success = NO;
    }
    else {
        [helper setReportInt:[NSNumber numberWithInt:value]];
        [helper setReportContext:context];
    }
    
    return success;
    
}

+ (BOOL) report:(NSString*) name withDouble:(double)value andContext:(NSString *)context {
    EPReportHelper* helper = [self getHelper:name];
    
    BOOL success = true;
    if (helper == nil) {
        success = false;
    }
    else {
        [helper setReportDouble:[NSNumber numberWithDouble:value]];
        [helper setReportContext:context];
    }
    
    return success;
    
}

+ (BOOL) exception:(NSException *)ex withHash:(NSString *)hash
     andCustomData:(NSString *)customData {
    
    if (ex == nil) {
        return NO;
    }
    
    NSString* shaHash = nil;
    
    if (hash) {
        shaHash = [self sha1:hash];
    }
    else {
        shaHash = [self sha1:[hashFunc hash:ex]];
    }
    
    NSString* exceptionName = [NSString stringWithFormat:@"exceptions/%@", shaHash];
    
    NSString* exDetail = nil;
    
    if (customData) {
        exDetail = [EPExceptionDetailHelper createExceptionDetail:ex withCustomData:customData];
    }
    else {
        exDetail = [EPExceptionDetailHelper createExceptionDetail:ex];
    }
    
    return [self report:exceptionName withContext:exDetail];
}

+ (BOOL) reportException:(NSException *)ex {
    return [self exception:ex withHash:nil andCustomData:nil];
}

+ (BOOL) reportException:(NSException *)ex withCustomData:(NSString *)customData {
    if  (!customData) {
        return false;
    }
    
    return [self exception:ex withHash:nil andCustomData:customData];
}

+ (BOOL) reportException:(NSException *)ex withHash:(NSString *)hash {
    if (!hash) {
        return false;
    }
    
    return [self exception:ex withHash:hash andCustomData:nil];
}

+ (BOOL) reportException:(NSException *)ex withHash:(NSString *)hash
           andCustomData:(NSString *)customData {
    
    if (!hash) {
        return false;
    }
    if (!customData) {
        return false;
    }
    
    return [self exception:ex withHash:hash andCustomData:customData];
}

+ (BOOL) time:(NSString*) name withBlock:(void (^)(void))timedBlock {
    
    NSDate* start = [NSDate date];
    timedBlock();
    int totalTime = (int) ([start timeIntervalSinceNow] * -1000.0);
    
    return [self report:[NSString stringWithFormat:@"timed_blocks/#{%@}", name]
                 withInt:totalTime];
}

+ (BOOL) time:(NSString *)name withBlock:(void (^)(id))timedBlock andParam:(id)blockParam {
    
    NSDate* start = [NSDate date];
    timedBlock(blockParam);
    int totalTime = (int) ([start timeIntervalSinceNow] * -1000.0);
    
    return [self report:[NSString stringWithFormat:@"timed_blocks/#{%@}", name]
                withInt:totalTime];
}

@end
