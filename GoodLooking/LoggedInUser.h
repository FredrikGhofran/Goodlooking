//
//  LoggedInUser.h
//  GoodLooking
//
//  Created by Fredrik Ghofran on 2014-05-29.
//  Copyright (c) 2014 GoodLooking. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "NRGramKit.h"
@interface LoggedInUser : NSObject
+ (IGUser *) myUser;
+ (void) setMyUser:(IGUser *)myUser;
@end
