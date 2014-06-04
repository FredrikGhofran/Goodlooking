//
//  SearchFriendsTableViewCell.h
//  GoodLooking
//
//  Created by Fredrik Ghofran on 2014-05-29.
//  Copyright (c) 2014 GoodLooking. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NRGramKit.h"
@interface SearchFriendsTableViewCell : UITableViewCell<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageLabel;
@property(nonatomic)IGUser *otherUser;
@property (weak, nonatomic) IBOutlet UIImageView *imageButton;
@property(nonatomic)NSString *addName;

@end
