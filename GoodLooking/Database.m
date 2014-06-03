//
//  Database.m
//  GoodLooking
//
//  Created by Fredrik Ghofran on 2014-06-01.
//  Copyright (c) 2014 GoodLooking. All rights reserved.
//

#import "Database.h"

@implementation Database
static NSUserDefaults * _database;

+ (NSUserDefaults *)database
{
    if(! _database){
         _database = [NSUserDefaults standardUserDefaults];
    }
    return  _database;
}

+ (void) setDatabase:(NSUserDefaults *) database{
     _database =  database;
}
@end
