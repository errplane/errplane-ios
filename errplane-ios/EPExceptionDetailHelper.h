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
 The user associated with the current Errplane session.
 
 @param sessUser the session user to be sent with exception details.
 */
+ (void) setSessionUser: (NSString*) sessUser;

/**
 Leave a trail indicating what might have lead to an Exception.  The last 10 are sent
 with exception details.  If pushing a breadcrumb on the queue when it already has
 10 breadcrumbs, the oldest will be popped off the back of the queue.
 
 @param bc the meaningful breadcrumb to push on the queue.
 */
+ (void) breadcrumb: (NSString*) bc;

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
