//
//  Errplane.m
//  errplane-ios
//
//  Created by Geoff Dix jr. on 2/15/13.
//  Copyright (c) 2013 Errplane. All rights reserved.
//

#import "Errplane.h"
#include <CommonCrypto/CommonDigest.h>

#import "EPReportHelper.h"
#import "EPHTTPPostHelper.h"
#import "EPDefaultExceptionHash.h"
#import "EPExceptionDetailHelper.h"

@implementation Errplane

static NSURL* errplaneUrl = nil;
static Errplane* sharedSingleton = nil;
static NSMutableArray* reportQueue = nil;
static dispatch_queue_t dispatchQueue = nil;
static int queueCapacity = 100;
static EPDefaultExceptionHash* hashFunc = nil;


+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedSingleton = [[Errplane alloc] init];
        hashFunc = [[EPDefaultExceptionHash alloc] init];
    }
}

+ (BOOL) setupWithUrlApikeyAppEnv:(NSString *)url :(NSString *)api :(NSString *)app :(NSString *)env {
    
    BOOL success = YES;
    if ((url == nil) || (api == nil) || (app == nil) || (app == nil) || (env == nil)) {
        success = NO;
    }
    else {
        NSMutableString* errplaneUrlStr = [[NSMutableString alloc] initWithString:url];
        [errplaneUrlStr appendString:app];
        [errplaneUrlStr appendString:env];
        [errplaneUrlStr appendString:@"/points?api_key="];
        [errplaneUrlStr appendString:api];
        errplaneUrl = [[NSURL alloc] initWithString:errplaneUrlStr];
        if (errplaneUrl == nil) {
            success = NO;
        }
        reportQueue = [[NSMutableArray alloc] initWithCapacity:queueCapacity];
        dispatchQueue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
    }
    return success;
}

+ (void) exceptionHashOverride:(EPDefaultExceptionHash *)hashFuncOverride {
    if (hashFunc != nil) {
        [hashFunc release];
        hashFunc = hashFuncOverride;
    }
}

- (void) dealloc {
    [errplaneUrl release];
    [sharedSingleton release];
    [reportQueue release];
    [hashFunc release];
}

+ (NSString*) sha1: (NSString*)toHash {
    
    
    NSMutableString* hashed = [[NSMutableString alloc] init];
    
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
    [NSURLConnection sendSynchronousRequest:
        [EPHTTPPostHelper generateRequestForReport:eprh] returningResponse:&response error:&error];
    if (response.statusCode == 201) {
        success = YES;
    }
    return success;
}

/**
 Dispatches an asynchronous thread to execute the post.
 @param eprh the EPReportHelper containing the data used in the post.
 */
+(void) dispatchRequest:(EPReportHelper*) eprh {
    
    dispatch_async(dispatchQueue, ^{
        int iter = 0;
        BOOL sendSuccess = [self sendReport:eprh];
        while((sendSuccess == NO) && (iter < 3)) {
            sendSuccess = [self sendReport:eprh];
            iter++;
        }
        
        [reportQueue removeObject:eprh];
    });
}

+ (EPReportHelper*) getHelper: (NSString*) name {
    EPReportHelper* retHelper = nil;
    
    
    if ([reportQueue count] < queueCapacity) {
        if ((name != nil) && ([name length] < 250)) {
            retHelper = [EPReportHelper alloc];
            if ([retHelper initWithUrlName:errplaneUrl:name] != YES) {
                [retHelper release];
                retHelper = nil;
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
        [helper generateBodyWithInt:1];
        [reportQueue addObject:helper];
        [self dispatchRequest:helper];
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
        [helper generateBodyWithInt:value];
        [reportQueue addObject:helper];
        [self dispatchRequest:helper];
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
        [helper generateBodyWithDouble:value];
        [reportQueue addObject:helper];
        [self dispatchRequest:helper];
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
        [helper generateBodyWithInt:1
            andContext:context];
        [reportQueue addObject:helper];
        [self dispatchRequest:helper];
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
        [helper generateBodyWithInt:value
            andContext:context];
        [reportQueue addObject:helper];
        [self dispatchRequest:helper];
    }
    
    return success;
    
}

+ (BOOL) report:(NSString*) name withDouble:(double)value andContext:(NSString *)context {
    EPReportHelper* helper = [self getHelper:name];
    
    BOOL success = YES;
    if (helper == nil) {
        success = NO;
    }
    else {
        [helper generateBodyWithDouble:value
            andContext:context];
        [reportQueue addObject:helper];
        [self dispatchRequest:helper];
    }
    
    return success;
    
}

+ (BOOL) reportException:(NSException *)ex {
    
    if (ex == nil) {
        return NO;
    }
    
    NSString* hash = [hashFunc hash:ex];
    NSString* shaHash = [self sha1:hash];
    NSString* exDetail = [EPExceptionDetailHelper createExceptionDetail:ex
                                                               withHash:shaHash];
    
    NSString* exceptionName = [NSString stringWithFormat:@"exceptions/%@", shaHash];
    
    return [self report:exceptionName withContext:exDetail];
}

+ (BOOL) reportException:(NSException *)ex withCustomData:(NSString *)customData {
    BOOL success = NO;
    
    return success;
}

+ (BOOL) reportException:(NSException *)ex withHash:(NSString *)hash {
    BOOL success = NO;
    
    return success;
}

+ (BOOL) reportException:(NSException *)ex withHash:(NSString *)hash
           andCustomData:(NSString *)customData {
    BOOL success = NO;
    
    return success;
}

+ (BOOL) time:(NSString*) name withBlock:(void (^)(void))timedBlock {
    
    NSDate* start = [NSDate date];
    timedBlock();
    int totalTime = (int) ([start timeIntervalSinceNow] * -1000.0);
    
    return [self report:[NSString stringWithFormat:@"timed_blocks/#{%@}", name]
                 withInt:totalTime];
}

@end
