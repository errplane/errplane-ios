//
//  EPReportHelper.m
//  errplane-ios
//
//  Created by Geoff Dix jr. on 2/16/13.
//

#import "EPReportHelper.h"

@implementation EPReportHelper

@synthesize errplaneUrl;
@synthesize reportName;
@synthesize postBody;

- (BOOL) initWithUrlName:(NSURL *)url :(NSString *)name {
    BOOL success = YES;
    
    if ((url == nil) || (name == nil) || ([name length] <= 0)) {
        success = NO;
    }
    else {
        errplaneUrl = [url retain];
        reportName = [name retain];
    }
    
    return success;
}

- (void) dealloc {
    [errplaneUrl release];
    [reportName release];
    [postBody release];
}

-(BOOL)generateBodyWithInt: (int) value {
    NSDate* now = [NSDate date];
    postBody = [[NSMutableString alloc] initWithString:
                [NSString stringWithFormat:@"%@ %d %ld", reportName, value, ((long)[now timeIntervalSince1970])]];
    return YES;
}

-(BOOL)generateBodyWithDouble:(double) value {
    NSDate* now = [NSDate date];
    postBody = [[NSMutableString alloc] initWithString:
        [NSString stringWithFormat:@"%@ %f %ld", reportName, value, ((long)[now timeIntervalSince1970])]];
    return YES;
}

-(BOOL)generateBodyWithIntComment:(int) value:(NSString*) comment {
    NSDate* now = [NSDate date];
    postBody = [[NSMutableString alloc] initWithString:
        [NSString stringWithFormat:@"%@ %d %ld %@", reportName,
         value, ((long)[now timeIntervalSince1970]), comment]];
    return YES;
}

-(BOOL)generateBodyWithDoubleComment:(double) value:(NSString*) comment {
    NSDate* now = [NSDate date];
    postBody = [[NSMutableString alloc] initWithString:
        [NSString stringWithFormat:@"%@ %f %ld %@", reportName,
         value, ((long)[now timeIntervalSince1970]), comment]];
    return YES;
}
@end
