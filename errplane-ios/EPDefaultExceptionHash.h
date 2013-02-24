//
//  EPDefaultExceptionHash.h
//  errplane-ios
//
//  Created by Geoff Dix jr. on 2/24/13.
//  Copyright (c) 2013 Errplane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPExceptionHashProtocol.h"

@interface EPDefaultExceptionHash : NSObject <EPExceptionHashProtocol>
-(NSString*) hash:(NSException *)ex;
@end
