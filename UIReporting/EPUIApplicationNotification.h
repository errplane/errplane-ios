//
//  EPUIApplicationNotification.h
//  errplane-ios
//
//  Created by Geoff Dix jr. on 3/15/13.
//  Copyright (c) 2013 Errplane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPUIApplicationNotification : NSObject

+ (void)handleAppToBackground:(id) arg;
+ (void)handleAppBecameActive:(id) arg;

@end
