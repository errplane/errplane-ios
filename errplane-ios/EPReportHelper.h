//
//  EPReportHelper.h
//  errplane-ios
//
//  Created by Geoff Dix jr. on 2/16/13.
//  Copyright (c) 2013 Errplane. All rights reserved.
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
-(BOOL)generateBodyWithInt:(int) value andContext:(NSString*) context;
-(BOOL)generateBodyWithDouble:(double) value andContext:(NSString*) context;

@end
