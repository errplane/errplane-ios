//
//  Errplane.h
//  errplane-ios
//
//  Created by Geoff Dix jr. on 2/15/13.
//

#import <Foundation/Foundation.h>


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
 @param env the deployment environment key (usually on of production, staging, or development).
 @return false if any of the data was null or if the url was not valid.
 */
+ (BOOL) setupWithUrlApikeyAppEnv:(NSString*) url:(NSString*) api:(NSString*) app:(NSString*) env;

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
 Posts a datapoint in a time series as a result of executing the block passed in.
 @param timedBlock the block to time while executing.
 @return false if Errplane was not previously initialized.
 */
+ (BOOL) time: (NSString*) name withBlock: (void(^)(void))timedBlock;

@end
