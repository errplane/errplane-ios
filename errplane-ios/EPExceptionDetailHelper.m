//
//  EPExceptionDetailHelper.m
//  errplane-ios
//
//  Created by Geoff Dix jr. on 2/24/13.
//  Copyright (c) 2013 Errplane. All rights reserved.
//

#import "EPExceptionDetailHelper.h"
#import "EPIOSDeviceInfo.h"

@implementation EPExceptionDetailHelper


static NSString* sessionUser = nil;
static NSMutableArray* breadcrumbQueue = nil;
static const int BC_CAPACITY = 10;


+ (void) setSessionUser:(NSString *)sessUser {
    [sessUser retain];
    [sessionUser release];
    sessionUser = sessUser;
}

+ (void) breadcrumb:(NSString *)bc {
    @synchronized(self) {
        if (!breadcrumbQueue) {
            breadcrumbQueue = [[NSMutableArray alloc] initWithCapacity:BC_CAPACITY];
        }
        else if ([breadcrumbQueue count] >= BC_CAPACITY) {
            [breadcrumbQueue removeObjectAtIndex:0];
        }
        [breadcrumbQueue addObject:bc];
    }
}

+ (NSDictionary*) createJSONDictionary:(NSException*) ex:(NSString*) customData {
    
    NSString* usrAgent = [NSString stringWithFormat:@"%@ %@",[EPIOSDeviceInfo getPlatform],
                          [EPIOSDeviceInfo getVersion]];
    
    NSDictionary* reqData = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [EPIOSDeviceInfo getPlatform],@"platform",
                                    [EPIOSDeviceInfo getVersion],@"version",
                                    usrAgent,@"user_agent",
                             nil];
    
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    sessionUser,@"session_user",
                                    breadcrumbQueue,@"breadcrumbs",
                                    NSStringFromClass([ex class]),@"exception_class",
                                    [ex reason],@"message",
                                    reqData,@"request_data",
                                    customData,@"custom_data",
                                    [ex callStackSymbols],@"backtrace",
                                    nil];
    return jsonDictionary;
}

+ (NSString*) createExceptionDetailFromDictionary:(NSDictionary*)dictionary {
    NSMutableString* jsonStr = [[[NSMutableString alloc] init] autorelease];
    [jsonStr appendFormat:@"{"];
    NSArray* keys = [dictionary allKeys];
    int keyCount = [keys count];
    for (int i = 0; i < keyCount; i++) {
        NSObject* obj = [dictionary objectForKey:[keys objectAtIndex:i]];
        if ([obj isKindOfClass:[NSString class]]) {
            [jsonStr appendFormat:@"\"%@\":\"%@\"",[keys objectAtIndex:i],obj];
        }
        else if ([obj isKindOfClass:[NSArray class]]) {// backtrace or breadcrumbs
            [jsonStr appendFormat:@"\"%@\":[",[keys objectAtIndex:i]];
            int arrayCount = [((NSArray*) obj) count];
            for (int j = 0; j < arrayCount; j++) {
                [jsonStr appendFormat:@"\"%@\"",[((NSArray*) obj) objectAtIndex:j]];
                if (j < (arrayCount-1)) {
                    [jsonStr appendFormat:@","];
                }
                else {
                    [jsonStr appendFormat:@"]"];
                }
            }
        }
        else if ([obj isKindOfClass:[NSDictionary class]]) {
            [jsonStr appendFormat:@"\"%@\":{",[keys objectAtIndex:i]];
            NSArray* subKeys = [((NSDictionary*) obj) allKeys];
            int subKeyCount = [subKeys count];
            for (int j=0; j < subKeyCount; j++) {
                NSObject* subObj = [((NSDictionary*)obj) objectForKey:[subKeys objectAtIndex:j]];
                if ([subObj isKindOfClass:[NSString class]]) {
                    [jsonStr appendFormat:@"\"%@\":\"%@\"",[subKeys objectAtIndex:j],subObj];
                }
                if (j < (subKeyCount-1)) {
                    [jsonStr appendFormat:@","];
                }
                else {
                    [jsonStr appendFormat:@"}"];
                }
            }
        }
        
        if (i < (keyCount-1)) {
            [jsonStr appendFormat:@","];
        }
        else {
            [jsonStr appendFormat:@"}"];
        }
    }
    return jsonStr;
}

+ (NSString*) createExceptionDetail:(NSException *)ex {
    
    NSDictionary* jsonDictionary = [self createJSONDictionary:ex :@"{}"];
    Class jsonSerializationClass = NSClassFromString(@"NSJSONSerialization");
    if (jsonSerializationClass) {
        // use NSJSONSerialization
        NSError* error;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:nil error:&error];
        return [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
    }
    
    return [self createExceptionDetailFromDictionary:jsonDictionary];
    
}

+ (NSString*) createExceptionDetail:(NSException *)ex withCustomData :(NSString *)customData {
    
    
    NSDictionary* jsonDictionary = [self createJSONDictionary:ex :customData];
    Class jsonSerializationClass = NSClassFromString(@"NSJSONSerialization");
    if (jsonSerializationClass) {
        // use NSJSONSerialization
        NSError* error;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:nil error:&error];
        return [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
    }
    
    return [self createExceptionDetailFromDictionary:jsonDictionary]; 
}

@end
