//
//  ErrplaneTest.m
//  errplane-ios
//
//  Created by Geoff Dix jr. on 2/17/13.
//  Copyright (c) 2013 Errplane. All rights reserved.
//

#import "ErrplaneTest.h"
#import "Errplane.h"

@implementation ErrplaneTest

@synthesize url;
@synthesize apiKey;
@synthesize appKey;
@synthesize envKey;

- (void) dealloc {
    [url release];
    [apiKey release];
    [appKey release];
    [envKey release];
}

- (void)setUp
{
    [super setUp];
    
    url = [[[NSProcessInfo processInfo] environment] objectForKey:@"EP_URL"];
    apiKey = [[[NSProcessInfo processInfo] environment] objectForKey:@"EP_API"];
    appKey = [[[NSProcessInfo processInfo] environment] objectForKey:@"EP_APP"];
    envKey = [[[NSProcessInfo processInfo] environment] objectForKey:@"EP_ENV"];
    
    if (!url || !apiKey || !appKey || !envKey) {
    
        NSLog(@"ENV vals were null, setting to defaults!");
        
        [url release];
        [apiKey release];
        [appKey release];
        [envKey release];
        
        url = @"127.0.0.1"; 
        apiKey = @"api_key";
        appKey = @"testApp";
        envKey = @"staging";
    }
    else {
        NSLog(@"found ENV vals, using them");
    }
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)initErrplane {
    if([Errplane setupWithUrlApikeyAppEnv:url:apiKey:appKey:envKey] == NO) {
        STFail(@"Errplane setup failed!");
    }
}

- (void)testSetupErrplane {
    
    // nothing null - should succeed
    STAssertTrue([Errplane setupWithUrlApikeyAppEnv:url:apiKey:appKey:envKey],
                 @"Setup failed on good data");
    
    // null url
    STAssertFalse([Errplane setupWithUrlApikeyAppEnv:nil:apiKey:appKey:envKey],
                  @"Setup succeeded on null url");
    
    // null apiKey
    STAssertFalse([Errplane setupWithUrlApikeyAppEnv:url:nil:appKey:envKey],
                  @"Setup succeeded on null api key");
    
    // null appKey
    STAssertFalse([Errplane setupWithUrlApikeyAppEnv:url:apiKey:nil:envKey],
                  @"Setup succeeded on null app");
    
    // null envKey
    STAssertFalse([Errplane setupWithUrlApikeyAppEnv:url:apiKey:appKey:nil],
                  @"Setup succeeded on null env");
    
    
    // malformed url
    NSString* badUrl = @"https:// ";
    
    STAssertFalse([Errplane setupWithUrlApikeyAppEnv:badUrl:apiKey:appKey:envKey],
                  @"Setup succeeded on malformed url");
}

-(void) testReport {
    [self initErrplane];
    
    STAssertTrue([Errplane report:@"unittest_errplane-ios/testReport"], @"Failed to report data to Errplane");
    
    // wait a few for the calls to return
    [NSThread sleepForTimeInterval:2];
    STFail(@"add negative tests and edge cases");
}

-(void) testReportWithInt {
    [self initErrplane];
    
    STAssertTrue([Errplane report:@"unittest_errplane-ios/testReportWithInt"
                           withInt: 37], @"Failed to report data to Errplane");
    
    // wait a few for the calls to return
    [NSThread sleepForTimeInterval:2];
    STFail(@"add negative tests and edge cases");
}

-(void) testReportWithDouble {
    [self initErrplane];
    
    STAssertTrue([Errplane report:@"unittest_errplane-ios/testReportWithDouble"
                           withDouble: 356.75], @"Failed to report data to Errplane");
    
    // wait a few for the calls to return
    [NSThread sleepForTimeInterval:2];
    STFail(@"add negative tests and edge cases");
}

-(void) testReportWithContext {
    [self initErrplane];
    
    STAssertTrue([Errplane report:@"unittest_errplane-ios/testReportWithContext"
                      withContext:@"Delayed Server Request"], @"Failed to report data to Errplane");
    
    // wait a few for the calls to return
    [NSThread sleepForTimeInterval:2];
    STFail(@"add negative tests and edge cases");
}

-(void) testReportWithIntAndContext {
    [self initErrplane];
    
    STAssertTrue([Errplane report:@"unittest_errplane-ios/testReportWithIntAndContext"
                           withInt: 2500
                           andContext:@"Slow Processing"], @"Failed to report data to Errplane");
    
    // wait a few for the calls to return
    [NSThread sleepForTimeInterval:2];
    STFail(@"add negative tests and edge cases");
}

-(void) testReportWithDoubleAndContext {
    [self initErrplane];
    
    STAssertTrue([Errplane report:@"unittest_errplane-ios/testReportWithDoubleAndContext"
                           withDouble: 192.75
                           andContext:@"Average Response Time"], @"Failed to report data to Errplane");
    
    // wait a few for the calls to return
    [NSThread sleepForTimeInterval:2];
    STFail(@"add negative tests and edge cases");
}

-(void) testException {
    [self initErrplane];
    
    @try {
        [NSException raise:@"testException" format:@"Testing the exception reporting"];
    }
    @catch (NSException *exception) {
        STAssertTrue([Errplane reportException:exception], @"testException failed");
    }
    
    // wait a few for the calls to return
    [NSThread sleepForTimeInterval:2];
    
    STFail(@"add tests for Exceptions");
}

-(void) testExceptionWithCustomData {
    [self initErrplane];
    
    STFail(@"add tests for Exceptions with Custom Data");
}

-(void) testExceptionWithHash {
    [self initErrplane];
    
    STFail(@"add tests for Exceptions with Hash");
}

-(void) testExceptionWithHashAndCustomData {
    [self initErrplane];
    
    STFail(@"add tests for Exceptions with Hash and Custom Data");
}

-(void) testTime {
    [self initErrplane];
    
    void (^testTimeBlock) (void);
    
    testTimeBlock = ^(void) {
        // sleep 5 secs
        [NSThread sleepForTimeInterval:3];
    };
    
    STAssertTrue([Errplane time:@"unittest_errplane-ios/testTime" withBlock: testTimeBlock], @"Failed to time execution of block.");
    
    STFail(@"add negative tests and edge cases");
}

@end
