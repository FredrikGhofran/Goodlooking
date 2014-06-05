//
//  Database.m
//  GoodLooking
//
//  Created by Fredrik Ghofran on 2014-06-01.
//  Copyright (c) 2014 GoodLooking. All rights reserved.
//

#import "Database.h"

@implementation Database
static NSMutableDictionary * _likes;
static NSMutableArray *_matches;
+ (NSMutableDictionary *)likes
{
    if(! _likes){
         _likes = [[NSMutableDictionary alloc] init];
    }
    return  _likes;
}

+ (void) setLikes:(NSMutableDictionary *) likes{
     _likes =  likes;
}

+ (NSMutableArray *)matches
{
    if(!_matches){
    
        _matches = [[NSMutableArray alloc] init];
    }
    
    return _matches;
}
+ (void) setMatches:(NSMutableArray *) matches{
    _matches =  matches;
}

@end
