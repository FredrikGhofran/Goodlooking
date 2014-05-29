//
//  SearchFriendsTableViewCell.h
//  GoodLooking
//
//  Created by Fredrik Ghofran on 2014-05-29.
//  Copyright (c) 2014 GoodLooking. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchFriendsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageButton;
@end
