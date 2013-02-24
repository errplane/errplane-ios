//
//  EPBase64.m
//  errplane-ios
//
//  Created by Geoff Dix jr. on 2/23/13.
//  Copyright (c) 2013 Errplane. All rights reserved.
//

#import "EPBase64.h"

@implementation EPBase64

static const NSString* base64chars = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

+ (NSString*) encode: (NSString *)data {
    NSMutableString* encStr = [NSMutableString stringWithString:@""];
    NSMutableString* addPadStr = [NSMutableString stringWithString:@""];
    
    NSMutableString* paddedInput = [NSMutableString stringWithString:data];
    
    // determine if we need to pad due to input not being multiple of 3
    int padAmt = (3 - ([data length] % 3)) %3;
    
    for (int i = 0; i < padAmt; i++) {
        [addPadStr appendString:@"="];
        [paddedInput appendString:@"\0"];
    }
    
    // iterate in increments of 3 to produce the encoding
    for (int i = 0; i < [paddedInput length]; i += 3) {
        // turn each 3 into 1 24 bit #
        int n = ([paddedInput characterAtIndex:i] << 16) +
                ([paddedInput characterAtIndex:i+1] << 8) +
                ([paddedInput characterAtIndex:i+2]);
                
        // turn the 1 24 into 4 6 bit #s
        int n1 = (n >> 18) & 63, n2 = (n >> 12) & 63, n3 = (n >> 6) & 63, n4 = n & 63;
        
        // use the four 6 bit'ers as indices into the base64chars string
        [encStr appendFormat:@"%c",[base64chars characterAtIndex:n1]];
        [encStr appendFormat:@"%c",[base64chars characterAtIndex:n2]];
        [encStr appendFormat:@"%c",[base64chars characterAtIndex:n3]];
        [encStr appendFormat:@"%c",[base64chars characterAtIndex:n4]];
    }
    
    [encStr replaceCharactersInRange:NSMakeRange([encStr length]-[addPadStr length], [addPadStr length])
        withString: addPadStr];
        
    return encStr;
}

@end
