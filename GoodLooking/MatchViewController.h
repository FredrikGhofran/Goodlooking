//
//  MatchViewController.h
//  GoodLooking
//
//  Created by Fredrik Ghofran on 2014-06-05.
//  Copyright (c) 2014 GoodLooking. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
