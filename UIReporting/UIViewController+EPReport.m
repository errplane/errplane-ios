//
//  UIViewController+EPReport.m
//  errplane-ios
//
//  Created by Geoff Dix jr. on 3/8/13.
//  Copyright (c) 2013 Errplane. All rights reserved.
//

#import "UIViewController+EPReport.h"
#import <objc/runtime.h>
#import "Errplane.h"

@implementation UIViewController (EPReport)

+ (void)load {
    if (self == [UIViewController class]) {
        Method originalMethod = class_getInstanceMethod(self, @selector(viewWillAppear:));
        Method replacedMethod = class_getInstanceMethod(self, @selector(reportViewWillAppear:));
        method_exchangeImplementations(originalMethod, replacedMethod);
        
        originalMethod = class_getInstanceMethod(self, @selector(loadView));
        replacedMethod = class_getInstanceMethod(self, @selector(reportLoadView));
        method_exchangeImplementations(originalMethod, replacedMethod);
    }
}

- (void) reportViewWillAppear:(BOOL)animated {
    //NSLog(@"controllers/willAppear-%@", NSStringFromClass([self class]));
    [Errplane report:[NSString stringWithFormat:@"controllers/%@", NSStringFromClass([self class])]];
    [self reportViewWillAppear:animated];
}

- (void) reportLoadView {
    NSString *controller = NSStringFromClass([self class]);
    
    void (^timedBlock) (void);
    
    timedBlock = ^(void) {
        [self reportLoadView];
    };
    
    [Errplane time:[NSString stringWithFormat:@"controllers/%@",controller]
         withBlock:timedBlock];
    
}

@end
