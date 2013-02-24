//
//  EPHTTPPostHelper.h
//  errplane-ios
//
//  Created by Geoff Dix jr. on 2/16/13.
//  Copyright (c) 2013 Errplane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPReportHelper.h"

@interface EPHTTPPostHelper : NSObject

+(NSMutableURLRequest*) generateRequestForReport:(EPReportHelper*) report;

@end
