//
//  LoggedInUser.m
//  GoodLooking
//
//  Created by Fredrik Ghofran on 2014-05-29.
//  Copyright (c) 2014 GoodLooking. All rights reserved.
//

#import "LoggedInUser.h"

@implementation LoggedInUser

static IGUser * _myUser;

+(IGUser *)myUser{
    return _myUser;

}
+(void)setMyUser:(IGUser *)myUser{

    _myUser = myUser;
}
@end
