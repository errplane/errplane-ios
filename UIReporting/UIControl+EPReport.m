//
//  UIControl+EPReport.m
//  errplane-ios
//
//  Created by Geoff Dix jr. on 3/8/13.
//  Copyright (c) 2013 Errplane. All rights reserved.
//

#import "UIControl+EPReport.h"
#import <objc/runtime.h>
#import "Errplane.h"

@implementation UIControl (EPReport)
+ (void)load {
    if (self == [UIControl class]) {
        
        Method originalMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
        Method replacedMethod = class_getInstanceMethod(self, @selector(reportSendAction:to:forEvent:));
        method_exchangeImplementations(originalMethod, replacedMethod);
    }
}


- (void) reportSendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    NSString *targetClassStr = NSStringFromClass([target class]);
    
    [Errplane report:[NSString stringWithFormat:@"controllers/%@_%s",targetClassStr,action]];
    
    void (^timedBlock) (void);
    timedBlock = ^(void) {
        [self reportSendAction:action to:target forEvent:event];
    };
    
    [Errplane time:[NSString stringWithFormat:@"%@_%s",targetClassStr,action] withBlock:timedBlock];
}
@end
