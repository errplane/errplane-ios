//
//  EPBase64Test.m
//  errplane-ios
//
//  Created by Geoff Dix jr. on 2/23/13.
//  Copyright (c) 2013 Errplane. All rights reserved.
//

#import "EPBase64Test.h"
#include "EPBase64.h"

@implementation EPBase64Test


- (void)testEncode
{
    
    NSString* strToEncode = @"http://whatshouldweencode.com,why?&*()wh";
    
    STAssertTrue([[EPBase64 encode: strToEncode]
        isEqualToString:@"aHR0cDovL3doYXRzaG91bGR3ZWVuY29kZS5jb20sd2h5PyYqKCl3aA=="],
                 @"Base 64 encoding failed");    
    
    STAssertTrue([[EPBase64 encode: @"user={first_name:\"bob\",last_name:\"marley\",email:\"bob@bobmarley.com\"}"]
                  isEqualToString:@"dXNlcj17Zmlyc3RfbmFtZToiYm9iIixsYXN0X25hbWU6Im1hcmxleSIsZW1haWw6ImJvYkBib2JtYXJsZXkuY29tIn0="],
                 @"Base 64 encoding failed");
}

@end
