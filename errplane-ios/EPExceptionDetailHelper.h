//
//  EPExceptionDetailHelper.h
//  errplane-ios
//
//  Created by Geoff Dix jr. on 2/24/13.
//  Copyright (c) 2013 Errplane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPExceptionDetailHelper : NSObject

/**
 Creates an exception detail JSON string.
 
 @param ex the NSException to build the JSON detail from.
 @return the exception detail JSON to be used in the report to Errplane
 */
+ (NSString*) createExceptionDetail: (NSException*)ex;

/**
 Creates an exception detail JSON string.
 
 @param ex the NSException to build the JSON detail from.
 @param customData the custom data to be used to build the exception detail
 @return the exception detail JSON to be used in the report to Errplane
 */
+ (NSString*) createExceptionDetail:(NSException *)ex withCustomData: (NSString*) customData;

@end
