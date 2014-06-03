//
//  Database.h
//  GoodLooking
//
//  Created by Fredrik Ghofran on 2014-06-01.
//  Copyright (c) 2014 GoodLooking. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Database : NSObject
+ (NSUserDefaults *) database;
+ (void) setDatabase:(NSUserDefaults *)database;

@end
