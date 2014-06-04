//
//  Database.h
//  GoodLooking
//
//  Created by Fredrik Ghofran on 2014-06-01.
//  Copyright (c) 2014 GoodLooking. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Database : NSObject
+ (NSMutableDictionary *) database;
+ (void) setDatabase:(NSMutableDictionary *)database;

@end
