//
//  Database.m
//  GoodLooking
//
//  Created by Fredrik Ghofran on 2014-06-01.
//  Copyright (c) 2014 GoodLooking. All rights reserved.
//

#import "Database.h"

@implementation Database
static NSMutableDictionary * _database;

+ (NSMutableDictionary *)database
{
    if(! _database){
         _database = [[NSMutableDictionary alloc] init];
    }
    return  _database;
}

+ (void) setDatabase:(NSMutableDictionary *) database{
     _database =  database;
}
@end
