//
//  UIControl+EPReport.h
//  errplane-ios
//
//  Created by Geoff Dix jr. on 3/8/13.
//  Copyright (c) 2013 Errplane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (EPReport)

- (void) reportSendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event;

@end
