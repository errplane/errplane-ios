//
//  EPDefaultExceptionHash.m
//  errplane-ios
//
//  Created by Geoff Dix jr. on 2/24/13.
//  Copyright (c) 2013 Errplane. All rights reserved.
//

#import "EPDefaultExceptionHash.h"

@implementation EPDefaultExceptionHash

-(NSString*) hash:(NSException *)ex {
    NSString* firstCallStack = [[ex callStackSymbols] objectAtIndex:0];
    
    NSString* exClass = NSStringFromClass([ex class]);
    
    NSString* toHash = [NSString stringWithFormat:@"%@%@", firstCallStack, exClass];
    
    return toHash;
}

@end
