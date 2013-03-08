//
//  EPHTTPPostHelper.m
//  errplane-ios
//
//  Created by Geoff Dix jr. on 2/16/13.
//  Copyright (c) 2013 Errplane. All rights reserved.
//

#import "EPHTTPPostHelper.h"
#include "EPReportHelper.h"

@implementation EPHTTPPostHelper

+(NSMutableURLRequest*) generateRequestForReport:(EPReportHelper*) report {
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[report errplaneUrl]];
    [request setTimeoutInterval:10];
    [request setValue:@"text/plain" forHTTPHeaderField:@"Content-type"];
    [request setHTTPMethod:@"POST"];
    
    // if the report was created within the last 30 seconds, send 'now' as the time
    NSArray* bodyParts = [[report postBody] componentsSeparatedByString:@"||||"];
    long rptMillis = [((NSString*)[bodyParts objectAtIndex:1]) longLongValue];
    NSDate* now = [NSDate date];
    long nowMillis = (long)[now timeIntervalSince1970];
    
    NSString* bodyStr = nil;
    NSString* millisStr = nil;
    
    // use 'now' if <= 30 secs since report time
    if ((nowMillis-rptMillis) <= 30000) {
        millisStr = @"now";
    }
    else {
        millisStr = (NSString*)[bodyParts objectAtIndex:1];
    }
        
    if ([bodyParts count] > 2) {// with context
        bodyStr = [NSString stringWithFormat:@"%@%@%@",
                [bodyParts objectAtIndex:0], millisStr, [bodyParts objectAtIndex:2]];
    }
    else {
        bodyStr = [NSString stringWithFormat:@"%@%@", [bodyParts objectAtIndex:0], millisStr];
    }
    NSLog(@"bodyStr = %@", bodyStr);
    
    [report setPostBody:[NSMutableString stringWithString:bodyStr]];
    
    [request setValue:[NSString stringWithFormat:@"%d",
                       [[report postBody] length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[[report postBody] dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

@end
