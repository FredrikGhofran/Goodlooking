//
//  WebbViewController.m
//  GoodLooking
//
//  Created by Fredrik Ghofran on 2014-05-29.
//  Copyright (c) 2014 GoodLooking. All rights reserved.
//

#import "WebbViewController.h"
#import "LoggedInUser.h"
@interface WebbViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webbView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation WebbViewController

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
    
    [NRGramKit loginInWebView:self.webbView loginLoadingCallback:^(BOOL loading){
        if(loading){
            
            [self.spinner startAnimating];
            
        }else{
            
            [self.spinner stopAnimating];
            self.spinner.hidesWhenStopped = YES;
            
        }
        
        
    }
             finishedCallback:^(IGUser* user,NSString* error)     {
                 [self.spinner startAnimating];
                 NSLog(@"ASD");
                 UITabBarController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Followers"];
                 
                 [LoggedInUser setMyUser:user];
                 [self presentViewController:vc animated:YES completion:nil];
                 
                 
             }];
}



@end
