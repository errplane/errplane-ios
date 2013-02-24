//
//  EPIOSDeviceInfo.m
//  errplane-ios
//
//  Created by Geoff Dix jr. on 2/24/13.
//  Copyright (c) 2013 Errplane. All rights reserved.
//

#import "EPIOSDeviceInfo.h"
#import <UIKit/UIKit.h>

@implementation EPIOSDeviceInfo

+ (NSInteger*) getMajorVersion {
    return [[[self getVersion] componentsSeparatedByString:@"."] objectAtIndex:0];
}

+ (NSString*) getVersion {
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString*) getPlatform {
    return [[UIDevice currentDevice] name];
}

@end
