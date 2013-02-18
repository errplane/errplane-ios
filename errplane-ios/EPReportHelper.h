//
//  EPReportHelper.h
//  errplane-ios
//
//  Created by Geoff Dix jr. on 2/16/13.
//

#import <Foundation/Foundation.h>

@interface EPReportHelper : NSObject

{
    NSURL* errplaneUrl;
    NSString* reportName;
    NSMutableString* postBody;
}

@property (retain) NSURL* errplaneUrl;
@property (retain) NSString* reportName;
@property (retain) NSMutableString* postBody;

-(BOOL)initWithUrlName: (NSURL*) url: (NSString*) name;
-(BOOL)generateBodyWithInt:(int) value;
-(BOOL)generateBodyWithDouble:(double) value;
-(BOOL)generateBodyWithIntComment:(int) value:(NSString*) comment;
-(BOOL)generateBodyWithDoubleComment:(double) value:(NSString*) comment;

@end
