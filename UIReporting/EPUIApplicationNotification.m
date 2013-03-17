//
//  EPUIApplicationNotification.m
//  errplane-ios
//
//  Created by Geoff Dix jr. on 3/15/13.
//  Copyright (c) 2013 Errplane. All rights reserved.
//

#import "EPUIApplicationNotification.h"
#import <UIKit/UIKit.h>
#import "Errplane.h"

@implementation EPUIApplicationNotification

+ (void)load {
    // register for notification events
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppToBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppBecameActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

+ (void)handleAppBecameActive:(id)arg {
    [Errplane report:@"becameActive"];
}

+ (void)handleAppToBackground:(id)arg {
    [Errplane report:@"sentToBackground"];
}

@end
