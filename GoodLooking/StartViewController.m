//
//  StartViewController.m
//  GoodLooking
//
//  Created by Fredrik Ghofran on 2014-06-01.
//  Copyright (c) 2014 GoodLooking. All rights reserved.
//

#import "StartViewController.h"
#import "NRGramKit.h"
#import "LoggedInUser.h"
@interface StartViewController ()

@end

@implementation StartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%d",[NRGramKit isLoggedIn]);
    if([NRGramKit isLoggedIn]){
        
        UITabBarController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Followers"];
        
        [LoggedInUser setMyUser:[NRGramKit loggedInUser]];
        [self presentViewController:vc animated:YES completion:nil];

    
    }
}


@end
