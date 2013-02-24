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

+ (NSString*) finishIt:(NSString*)toFinish {
    return [NSString stringWithFormat:@"%@}",toFinish];
}

+ (NSDictionary*) createJSONDictionary:(NSException*) ex:(NSString*) hash:(NSString*) customData {
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    NSStringFromClass([ex class]),@"exception_class",
                                    [ex reason],@"message",
                                    hash,@"hash",
                                    [EPIOSDeviceInfo getPlatform],@"platform",
                                    [EPIOSDeviceInfo getVersion],@"version",
                                    customData,@"custom_data",
                                    [ex callStackSymbols],@"backtrace",
                                    nil];
    return jsonDictionary;
}

/**
 Creates the base exception detail used for all exception reporting. Ugly hand generated
    JSON allows avoidance of external JSON libraries.  Please forgive me.
 */
+ (NSString*) createBaseException:(NSException*)ex withHash:(NSString*)hash {
    
    NSMutableString* exDetail = [[NSMutableString alloc] init];
    [exDetail appendFormat:@"{\"exception_class\":\"%@\",\"message\":\"%@\",\"hash\":\"%@\",\"session_data\":{\"platform\":\"%@\",\"version\":\"%@\"},\"backtrace\":[",NSStringFromClass([ex class]),[ex reason],hash,[EPIOSDeviceInfo getPlatform],[EPIOSDeviceInfo getVersion]];
    int i = 0;
    for (i = 0; i < ([[ex callStackSymbols] count] - 1); i++) {
        [exDetail appendFormat:@"\"%@\",",[[ex callStackSymbols] objectAtIndex:i]];
    }
    
    if (i > 0) {
        [exDetail appendFormat:@"\"%@\"]",[[ex callStackSymbols] objectAtIndex:i]];
    }
    
    return exDetail;
    
}

+ (NSString*) createExceptionDetailFromDictionary:(NSDictionary*)dictionary {
    NSMutableString* jsonStr = [[NSMutableString alloc] init];
    [jsonStr appendFormat:@"{"];
    NSArray* keys = [dictionary allKeys];
    int keyCount = [keys count];
    int i = 0;
    for (i = 0; i < (keyCount-1); i++) {
        NSObject* obj = [dictionary objectForKey:[keys objectAtIndex:i]];
        if ([obj isKindOfClass:[NSString class]]) {
            [jsonStr appendFormat:@"\"%@\":\"%@\",",[keys objectAtIndex:i],obj];
        }
        else if ([obj isKindOfClass:[NSArray class]]) {// must be the backtrace
            [jsonStr appendFormat:@"\"%@\":[",[keys objectAtIndex:i]];
            int j = 0;
            int backtraceCount = [obj count];
            for (j = 0; j < (backtraceCount-1); j++) {
                [jsonStr appendFormat:@"\"%@\",",[obj objectAtIndex:j]];
            }
            if (j > 0) {
                [jsonStr appendFormat:@"\"%@\"],",[obj objectAtIndex:j]];
            }
        }
    }
    if (i > 0) {
        NSObject* obj = [dictionary objectForKey:[keys objectAtIndex:i]];
        if ([obj isKindOfClass:[NSString class]]) {
            [jsonStr appendFormat:@"\"%@\":\"%@\"",[keys objectAtIndex:i],obj];
        }
        else if ([obj isKindOfClass:[NSArray class]]) {// must be the backtrace
            [jsonStr appendFormat:@"\"%@\":[",[keys objectAtIndex:i]];
            int j = 0;
            int backtraceCount = [obj count];
            for (j = 0; j < (backtraceCount-1); j++) {
                [jsonStr appendFormat:@"\"%@\",",[obj objectAtIndex:j]];
            }
            if (j > 0) {
                [jsonStr appendFormat:@"\"%@\"]",[obj objectAtIndex:j]];
            }
        }
    }
    [jsonStr appendFormat:@"}"];
    return jsonStr;
}

+ (NSString*) createExceptionDetail:(NSException *)ex withHash:(NSString *)hash {
    
    NSDictionary* jsonDictionary = [self createJSONDictionary:ex :hash :@"{}"];
    if ([EPIOSDeviceInfo getMajorVersion] >= 5) {
        // use NSJSONSerialization
        NSError* error;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:nil error:&error];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return [self createExceptionDetailFromDictionary:jsonDictionary];
    
}

+ (NSString*) createExceptionDetail:(NSException *)ex withHash:(NSString *) hash
                     andCustomData :(NSString *)customData {
    
    
    NSDictionary* jsonDictionary = [self createJSONDictionary:ex :hash :customData];
    if ([EPIOSDeviceInfo getMajorVersion] >= 5) {
        // use NSJSONSerialization
        NSError* error;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:nil error:&error];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return [self createExceptionDetailFromDictionary:jsonDictionary]; 
}

@end
