//
//  ErrplaneTest.h
//  errplane-ios
//
//  Created by Geoff Dix jr. on 2/17/13.
//  Copyright (c) 2013 Errplane. All rights reserved.
//

//  Logic unit tests contain unit test code that is designed to be linked into an independent test executable.
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

#import <SenTestingKit/SenTestingKit.h>

@interface ErrplaneTest : SenTestCase

{
    NSString* apiKey;
    NSString* appKey;
    NSString* envKey;
}

@property (retain) NSString* apiKey;
@property (retain) NSString* appKey;
@property (retain) NSString* envKey;

@end
