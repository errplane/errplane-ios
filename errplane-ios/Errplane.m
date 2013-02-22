//
//  Errplane.m
//  errplane-ios
//
//  Created by Geoff Dix jr. on 2/15/13.
//

#import "Errplane.h"
#import "EPReportHelper.h"
#import "EPHTTPPostHelper.h"

@implementation Errplane

static NSURL* errplaneUrl = nil;
static Errplane* sharedSingleton = nil;
static BOOL initializedData = NO;
static NSMutableArray* reportQueue = nil;
static dispatch_queue_t dispatchQueue = nil;
static int queueCapacity = 100;

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedSingleton = [[Errplane alloc] init];
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

- (void) dealloc {
    [errplaneUrl release];
    [sharedSingleton release];
    [reportQueue release];
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
    if (error == nil && response.statusCode == 201) {
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
    BOOL success = NO;
    
    return success;
    
}

+ (BOOL) report:(NSString*) name withInt:(int)value andContext:(NSString *)context {
    BOOL success = NO;
    
    return success;
    
}

+ (BOOL) report:(NSString*) name withDouble:(double)value andContext:(NSString *)context {
    BOOL success = NO;
    
    return success;
    
}

+ (BOOL) time:(NSString*) name withBlock:(void (^)(void))timedBlock {
    
    NSDate* start = [NSDate date];
    timedBlock();
    int totalTime = (int) ([start timeIntervalSinceNow] * -1000.0);
    
    NSLog(@"totalTime: %d", totalTime);
    
    return [self report:[NSString stringWithFormat:@"timed_blocks/#{%@}", name]
                 withInt:totalTime];
}

@end
