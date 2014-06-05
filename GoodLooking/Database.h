//
//  Database.h
//  GoodLooking
//
//  Created by Fredrik Ghofran on 2014-06-01.
//  Copyright (c) 2014 GoodLooking. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Database : NSObject
+ (NSMutableDictionary *) likes;
+ (void) setLikes:(NSMutableDictionary *)likes;

+ (NSMutableArray *) matches;
+ (void) setMatches:(NSMutableArray *)matches;

@end
