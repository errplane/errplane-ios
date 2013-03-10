//
//  EPReportHelper.m
//  errplane-ios
//
//  Created by Geoff Dix jr. on 2/16/13.
//  Copyright (c) 2013 Errplane. All rights reserved.
//

#import "EPReportHelper.h"
#import "EPBase64.h"

@implementation EPReportHelper

@synthesize errplaneUrl;
@synthesize reportName;
@synthesize postBody;
@synthesize reportInt;
@synthesize reportDouble;
@synthesize reportContext;

// used when we send the report to see if millis should be changed to 'now' instead
static const NSString* seperator = @"||||";

- (BOOL) initWithName:(NSString *)name {
    BOOL success = YES;
    
    if ((name == nil) || ([name length] <= 0) || ([name length] >= 250)) {
        success = NO;
    }
    else {
        reportName = [name retain];
        NSDate* now = [NSDate date];
        secsSinceEpoch = [[NSNumber numberWithDouble:[now timeIntervalSince1970]] intValue];
    }
    
    return success;
}

- (void) dealloc {
    [errplaneUrl release];
    [reportName release];
    [postBody release];
}

- (BOOL)sendNow {
    NSDate* now = [NSDate date];
    int nowSecs = [[NSNumber numberWithDouble:[now timeIntervalSince1970]] intValue];
    
    // use secs if > 30 secs since report time
    if ((nowSecs-secsSinceEpoch) > 30) {
        return false;
    }
    
    return true;
}

- (BOOL)generateBodyWithInt {
    
    // use 'now' if <= 30 secs since report time
    if ([self sendNow]) {
        postBody = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:
            @"%@ %d now", reportName, [reportInt intValue]]];
    }
    else {
        postBody = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:
            @"%@ %d %d", reportName, [reportInt intValue], secsSinceEpoch]];
    }
    return YES;
}

- (BOOL)generateBodyWithDouble {
    
    // use 'now' if <= 30 secs since report time
    if ([self sendNow]) {
        postBody = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:
            @"%@ %f now", reportName, [reportDouble doubleValue]]];
    }
    else {
        postBody = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:
            @"%@ %f %d", reportName, [reportDouble doubleValue], secsSinceEpoch]];
    }
    return YES;
}

- (BOOL)generateBodyWithIntAndContext {
    
    // use 'now' if <= 30 secs since report time
    if ([self sendNow]) {
        postBody = [[NSMutableString alloc] initWithString:
                    [NSString stringWithFormat:@"%@ %d now %@", reportName,
                     [reportInt intValue], [EPBase64 encode:reportContext]]];
    }
    else {
        postBody = [[NSMutableString alloc] initWithString:
            [NSString stringWithFormat:@"%@ %d %d %@", reportName,
            [reportInt intValue], secsSinceEpoch, [EPBase64 encode:reportContext]]];
    }
    return YES;
}

- (BOOL)generateBodyWithDoubleAndContext {
    
    // use 'now' if <= 30 secs since report time
    if ([self sendNow]) {
        postBody = [[NSMutableString alloc] initWithString:
                    [NSString stringWithFormat:@"%@ %f now %@", reportName,
                     [reportDouble doubleValue], [EPBase64 encode:reportContext]]];
    }
    else {
        postBody = [[NSMutableString alloc] initWithString:
            [NSString stringWithFormat:@"%@ %f %d %@", reportName,
            [reportDouble doubleValue], secsSinceEpoch, [EPBase64 encode:reportContext]]];
    }
    return YES;
}

- (BOOL)generateBody {
    if ((reportInt != nil) && (reportContext != nil)) {
        return [self generateBodyWithIntAndContext];
    }
    else if ((reportDouble != nil) && (reportContext != nil)) {
        return [self generateBodyWithDoubleAndContext];
    }
    else if (reportInt != nil) {
        return [self generateBodyWithInt];
    }
    else if (reportDouble != nil) {
        return [self generateBodyWithDouble];
    }
    return false;
}
@end
