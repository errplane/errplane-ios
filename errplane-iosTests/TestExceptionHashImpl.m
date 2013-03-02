//
//  TestExceptionHashImpl.m
//  errplane-ios
//
//  Created by Geoff Dix jr. on 3/2/13.
//  Copyright (c) 2013 Errplane. All rights reserved.
//

#import "TestExceptionHashImpl.h"

@implementation TestExceptionHashImpl

-(NSString*) hash:(NSException*) ex {
    
    // hash messages to a specific category
    if ([[ex reason] rangeOfString:@"testing exceptionHashImp"
                           options:NSCaseInsensitiveSearch].location != NSNotFound) {
        NSLog(@"found 'testing exceptionHashImp' in: %@", [ex reason]);
        return @"testExceptionHash";
    }
    
    NSLog(@"didn't find 'testing exceptionHashImp' in: %@", [ex reason]);
    
    return [super hash:ex];
}

@end
