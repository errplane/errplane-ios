//
//  ErrplaneTest.m
//  errplane-ios
//
//  Created by Geoff Dix jr. on 2/17/13.
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
    
    url = @"update this"; 
    apiKey = @"update this";
    appKey = @"update this";
    envKey = @"update this";
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
    [NSThread sleepForTimeInterval:5];
}

-(void) testReportInt {
    [self initErrplane];
    
    STAssertTrue([Errplane reportInt:@"unittest_errplane-ios/testReportInt": 37], @"Failed to report data to Errplane");
    
    // wait a few for the calls to return
    [NSThread sleepForTimeInterval:5];
}

-(void) testReportDouble {
    [self initErrplane];
    
    STAssertTrue([Errplane reportDouble:@"unittest_errplane-ios/testReportDouble": 356.75], @"Failed to report data to Errplane");
    
    // wait a few for the calls to return
    [NSThread sleepForTimeInterval:5];
}

@end
