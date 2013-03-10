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
    int secsSinceEpoch;
    NSNumber* reportInt;
    NSNumber* reportDouble;
    NSString* reportContext;
}

@property (retain) NSURL* errplaneUrl;
@property (retain) NSString* reportName;
@property (retain) NSMutableString* postBody;
@property (retain) NSNumber* reportInt;
@property (retain) NSNumber* reportDouble;
@property (retain) NSString* reportContext;


-(BOOL)initWithName:(NSString*) name;
-(BOOL)generateBody;

@end
