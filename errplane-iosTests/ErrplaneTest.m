//
//  ErrplaneTest.m
//  errplane-ios
//
//  Created by Geoff Dix jr. on 2/17/13.
//  Copyright (c) 2013 Errplane. All rights reserved.
//

#import "ErrplaneTest.h"
#import "Errplane.h"
#import "TestExceptionHashImpl.h"

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
    if([Errplane setupWithUrl:url apiKey:apiKey appKey:appKey environment:envKey] == NO) {
        STFail(@"Errplane setup failed!");
    }
    
    [Errplane setSessionUser:@"errplane-ios-test@errplane.com"];
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
}

-(void) testReportWithInt {
    [self initErrplane];
    
    STAssertTrue([Errplane report:@"unittest_errplane-ios/testReportWithInt"
                           withInt: 37], @"Failed to report data to Errplane");
    
    // wait a few for the calls to return
    [NSThread sleepForTimeInterval:2];
}

-(void) testReportWithDouble {
    [self initErrplane];
    
    STAssertTrue([Errplane report:@"unittest_errplane-ios/testReportWithDouble"
                           withDouble: 356.75], @"Failed to report data to Errplane");
    
    // wait a few for the calls to return
    [NSThread sleepForTimeInterval:2];
}

-(void) testReportWithContext {
    [self initErrplane];
    
    STAssertTrue([Errplane report:@"unittest_errplane-ios/testReportWithContext"
                      withContext:@"Delayed Server Request"], @"Failed to report data to Errplane");
    
    // wait a few for the calls to return
    [NSThread sleepForTimeInterval:2];
}

-(void) testReportWithIntAndContext {
    [self initErrplane];
    
    STAssertTrue([Errplane report:@"unittest_errplane-ios/testReportWithIntAndContext"
                           withInt: 2500
                           andContext:@"Slow Processing"], @"Failed to report data to Errplane");
    
    // wait a few for the calls to return
    [NSThread sleepForTimeInterval:2];
}

-(void) testReportWithDoubleAndContext {
    [self initErrplane];
    
    STAssertTrue([Errplane report:@"unittest_errplane-ios/testReportWithDoubleAndContext"
                           withDouble: 192.75
                           andContext:@"Average Response Time"], @"Failed to report data to Errplane");
    
    // wait a few for the calls to return
    [NSThread sleepForTimeInterval:2];
}

-(void) testException {
    [self initErrplane];
    
    @try {
        [NSException raise:@"testException" format:@"Testing default exception"];
    }
    @catch (NSException *exception) {
        STAssertTrue([Errplane reportException:exception], @"testException failed");
    }
    
    // wait a few for the calls to return
    [NSThread sleepForTimeInterval:2];
    
    STAssertFalse([Errplane reportException:nil], @"testException failed - exception was nil");
}

-(void) testExceptionWithCustomData {
    [self initErrplane];
    
    @try {
        [NSException raise:@"testExceptionWithCustomData" format:@"Testing exception with custom data"];
    }
    @catch (NSException *exception) {
        STAssertTrue([Errplane reportException:exception withCustomData:@"custom data is working"], @"testExceptionWithCustomData failed");
        
        STAssertFalse([Errplane reportException:exception withCustomData:nil],
                      @"testExceptionWithCustomData failed - custom data was nil");
    }
    
    // wait a few for the calls to return
    [NSThread sleepForTimeInterval:2];
}

-(void) testExceptionWithHash {
    [self initErrplane];
    
    @try {
        [NSException raise:@"testExceptionWithHash" format:@"Testing exception with passed in hash"];
    }
    @catch (NSException *exception) {
        STAssertTrue([Errplane reportException:exception withHash:@"hash this"],
                     @"testExceptionWithHash failed");
        
        STAssertFalse([Errplane reportException:exception withHash:nil],
                      @"testExceptionWithHash failed - hash was nil");
    }
    
    // wait a few for the calls to return
    [NSThread sleepForTimeInterval:2];
}

-(void) testExceptionWithHashAndCustomData {
    [self initErrplane];
    
    @try {
        [NSException raise:@"testExceptionWithHashAndCustomData" format:@"Testing exception with passed in hash and custom data"];
    }
    @catch (NSException *exception) {
        STAssertTrue([Errplane reportException:exception withHash:@"hash this" andCustomData:
                      @"custom data and overridden hash"],
                     @"testExceptionWithHashAndCustomData failed");
        
        STAssertFalse([Errplane reportException:exception withHash:nil andCustomData:@"custom data"],
                      @"testExceptionWithHashAndCustomData failed - hash was nil");
        
        STAssertFalse([Errplane reportException:exception withHash:@"hash not nil" andCustomData:nil],
                      @"testExceptionWithHashAndCustomData failed - custom data was nil");
        
        STAssertFalse([Errplane reportException:exception withHash:nil andCustomData:nil],
                      @"testExceptionWithHashAndCustomData failed - hash and custom data were nil");
    }
    
    // wait a few for the calls to return
    [NSThread sleepForTimeInterval:2];
}

-(void) testExceptionWithCustomHashProtocol {
    [self initErrplane];
    
    TestExceptionHashImpl* exHash = [[TestExceptionHashImpl alloc] init];
    [Errplane exceptionHashOverride:exHash];
    [Errplane breadcrumb:@"exception hash impl test"];
    
    @try {
        [NSException raise:@"testExceptionWithCustomHashProtocol"
                    format:@"this should test testIng excepTionhashimp, right?"];
    }
    @catch (NSException *exception) {
        STAssertTrue([Errplane reportException:exception], @"testExceptionWithCustomHashProtocol failed");
    }
    
    @try {
        [NSException raise:@"testExceptionWithCustomHashProtocol"
                    format:@"this should use the super class hash method estIng excepTionhashimp, right?"];
    }
    @catch (NSException *exception) {
        STAssertTrue([Errplane reportException:exception], @"testExceptionWithCustomHashProtocol failed");
    }
    
    // wait a few for the calls to return
    [NSThread sleepForTimeInterval:2];
    
    
}

-(void) testExceptionWithBreadcrumbs {
    [self initErrplane];
    
    for (int i = 1; i < 11; i++) {
        [Errplane breadcrumb:[NSString stringWithFormat:@"breadcrumb %d", i]];
    }
    
    @try {
        [NSException raise:@"testExceptionWithBreadcrumbs" format:@"Testing exception with breadcrumbs."];
    }
    @catch (NSException *exception) {
        STAssertTrue([Errplane reportException:exception], @"testExceptionWithBreadcrumbs failed");
        
        // add two more breadcrumbs to push the first two out of the queue
        [Errplane breadcrumb:[NSString stringWithFormat:@"breadcrumb %d", 11]];
        [Errplane breadcrumb:[NSString stringWithFormat:@"breadcrumb %d", 12]];
        STAssertTrue([Errplane reportException:exception],
                     @"testExceptionWithBreadcrumbs additional breadcrumbs failed");
    }
    
    // wait a few for the calls to return
    [NSThread sleepForTimeInterval:2];
    
}

-(void) testTime {
    [self initErrplane];
    
    void (^testTimeBlock) (void);
    
    testTimeBlock = ^(void) {
        // sleep
        [NSThread sleepForTimeInterval:3];
    };
    
    STAssertTrue([Errplane time:@"unittest_errplane-ios/testTime" withBlock: testTimeBlock], @"Failed to time execution of block.");
    
    // wait a few for the calls to return
    [NSThread sleepForTimeInterval:2];
}

-(void) testTimeWithParam {
    [self initErrplane];
    
    void (^testTimeBlock) (id);
    
    // define the block
    testTimeBlock = ^(NSArray* blockParam) {
        NSLog(@"we're in the block with an array of size %d",[blockParam count]);
        for (int i = 0; i < [blockParam count]; i++) {
            NSArray* currArr = [((NSString*)[blockParam objectAtIndex:i]) componentsSeparatedByString:@" "];
            
            [NSThread sleepForTimeInterval:[((NSString*)[currArr objectAtIndex:1]) intValue]];
        }
    };
    
    NSArray* blockParam = [NSArray arrayWithObjects:@"string 2",@"string 1",@"string 2", nil];
    
    STAssertTrue([Errplane time:@"unittest_errplane-ios/testTimeWithParam" withBlock: testTimeBlock
                       andParam: blockParam], @"Failed to time execution of block.");
    
    // wait a few for the calls to return
    [NSThread sleepForTimeInterval:2];
}

@end
