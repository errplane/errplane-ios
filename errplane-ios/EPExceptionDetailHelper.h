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
 @param hash the hash used to group the exception.
 @return the exception detail JSON to be used in the report to Errplane
 */
+ (NSString*) createExceptionDetail: (NSException*)ex withHash: (NSString*) hash;

/**
 Creates an exception detail JSON string.
 
 @param ex the NSException to build the JSON detail from.
 @param hash the hash used to group the exception.
 @param customData the custom data to be used to build the exception detail
 @return the exception detail JSON to be used in the report to Errplane
 */
+ (NSString*) createExceptionDetail:(NSException *)ex withHash:(NSString*) hash
                      andCustomData: (NSString*) customData;

@end
