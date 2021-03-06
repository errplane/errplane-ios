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
    [request setTimeoutInterval:5];
    [request setValue:@"text/plain" forHTTPHeaderField:@"Content-type"];
    [request setHTTPMethod:@"POST"];
    
    //NSLog(@"report body = %@", [report postBody]);
    
    [request setValue:[NSString stringWithFormat:@"%d",
                       [[report postBody] length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[[report postBody] dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

@end
