//
//  Database.m
//  GoodLooking
//
//  Created by Fredrik Ghofran on 2014-06-01.
//  Copyright (c) 2014 GoodLooking. All rights reserved.
//

#import "Database.h"

@implementation Database
static NSUserDefaults * _imageList;

+ (NSUserDefaults *)imageList
{
    if(!_imageList){
        _imageList = [NSUserDefaults standardUserDefaults];
    }
    return _imageList;
}

+ (void) setImageList:(NSUserDefaults *)imageList{
    _imageList = imageList;
}
@end
