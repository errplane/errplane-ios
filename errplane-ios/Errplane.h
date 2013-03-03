//
//  Errplane.h
//  errplane-ios
//
//  Created by Geoff Dix jr. on 2/15/13.
//  Copyright (c) 2013 Errplane. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EPDefaultExceptionHash;

/**
 This is the full client API for Errplane.  Before being used it must be initialized
    with the Errplane url, your api key, your application key, and the environment key
    (usually one of: production, staging, or development).
 
 All of the report methods require a name of the form: <name>[/<sub-name>][|<name>].
    Any number of sub-name[s] can be added using a slash (/) and additional names can
    be added using a pipe (|).  The name strings cannot exceed 250 characters.  For a
    more detailed explanation check out the Errplane github page:
    https://github.com/errplane
 */
@interface Errplane : NSObject

/**
 Initializes Errplane for future requests.
 
 @param url the base url of the errplane server.
 @param api your errplane api key.
 @param app your errplane app key.
 @param env the deployment environment key (usually one of production, staging, or development).
 @return false if any of the data was null or if the url was not valid.
 */
+ (BOOL) setupWithUrl:(NSString*) url apiKey:(NSString*) api
                           appKey:(NSString*) app environment:(NSString*) env;

/**
 Overrides the default exception hashing behavior.
 
 @param hashFuncOverride a sub-class of EPDefaultExceptionHash that provides an overridden
        hash function.
 */
+ (void) exceptionHashOverride: (EPDefaultExceptionHash*) hashFuncOverride;

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
 Posts a datapoint with a default int value of 1 to the timeline[s] specified.
 @param name the name[s] of the timeline[s] to post the data point to.
 @return false if Errplane was not previously initialized or the name exceeds 249 characters.
 */
+ (BOOL) report:(NSString*) name;

/**
 Posts a datapoint with the value specified to the timeline[s] specified.
 @param name the name[s] of the timeline[s] to post the data point to.
 @param value the int value to post to the timeline.
 @return false if Errplane was not previously initialized or the name exceeds 249 characters.
 */
+ (BOOL) report:(NSString*) name withInt: (int) value;

/**
 Posts a datapoint with the value specified to the timeline[s] specified.
 @param name the name[s] of the timeline[s] to post the data point to.
 @param value the double value to post to the timeline.
 @return false if Errplane was not previously initialized or the name exceeds 249 characters.
 */
+ (BOOL) report:(NSString*) name withDouble:(double) value;

/**
 Posts a datapoint with a default int value of 1 and a context to the timeline[s] specified.
 @param name the name[s] of the timeline[s] to post the data point to.
 @param context the context to post along with the datapoint to the timeline.
 @return false if Errplane was not previously initialized or the name exceeds 249 characters.
 */
+ (BOOL) report:(NSString*) name withContext:(NSString*) context;

/**
 Posts a datapoint with the int value and a context to the timeline[s] specified.
 @param name the name[s] of the timeline[s] to post the data point to.
 @param value the int value to post to the timeline[s].
 @param context the context to post along with the datapoint to the timeline.
 @return false if Errplane was not previously initialized or the name exceeds 249 characters.
 */
+ (BOOL) report:(NSString*) name withInt:(int) value andContext:(NSString*) context;

/**
 Posts a datapoint with a default int value of 1 and a context to the name[s] specified.
 @param name the name[s] of the timeline[s] to post the data point to.
 @param value the double value to post to the timeline[s].
 @param context the context to post along with the datapoint to the timeline.
 @return false if Errplane was not previously initialized or the name exceeds 249 characters.
 */
+ (BOOL) report:(NSString*) name withDouble:(double) value andContext:(NSString*) context;

/**
 Posts an exception using either the default hash method or the overridden one (if provided).
 @param ex the exception to report.
 @return false if Errplane was not previously initialized.
 */
+ (BOOL) reportException:(NSException*) ex;

/**
 Posts an exception using either the default hash method or the overridden one (if provided)
        and the custom data supplied.
 @param ex the exception to report.
 @param customData the NSString to place in the custom_data section of the exception detail
        reporting to Errplane.
 @return false if Errplane was not previously initialized.
 */
+ (BOOL) reportException:(NSException*) ex withCustomData: (NSString*) customData;

/**
 Posts an exception using either the hash passed in to group the exception.
 @param ex the exception to report.
 @param hash the overridden hash to use rather than the default.
 @return false if Errplane was not previously initialized or the name exceeds 249 characters.
 */
+ (BOOL) reportException:(NSException*) ex withHash:(NSString*) hash;

/**
 Posts an exception using either the default hash method or the overridden one (if provided).
 @param ex the exception to report.
 @param hash the overridden hash to use rather than the default.
 @param customData the NSString to place in the custom_data section of the exception detail
 reporting to Errplane.
 @return false if Errplane was not previously initialized.
 */
+ (BOOL) reportException:(NSException*) ex withHash:(NSString*) hash andCustomData:
        (NSString*) customData;

/**
 Posts a datapoint in a time series as a result of executing the block passed in.
 @param timedBlock the block to time while executing.
 @return false if Errplane was not previously initialized.
 */
+ (BOOL) time: (NSString*) name withBlock: (void(^)(void))timedBlock;

/**
 Posts a datapoint in a time series as a result of executing the block passed in.
 @param timedBlock the block to time while executing.
 @param blockParam the parameter to pass to the timed block
 @return false if Errplane was not previously initialized.
 */
+ (BOOL) time: (NSString*) name withBlock: (void(^)(id))timedBlock andParam:(id) blockParam;

@end
