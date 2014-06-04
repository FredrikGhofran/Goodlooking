//
//  SearchFriendsTableViewCell.m
//  GoodLooking
//
//  Created by Fredrik Ghofran on 2014-05-29.
//  Copyright (c) 2014 GoodLooking. All rights reserved.
//

#import "SearchFriendsTableViewCell.h"
#import "LoggedInUser.h"
@interface SearchFriendsTableViewCell ()
@property(nonatomic)IGUser *myUser;
@property(nonatomic)BOOL liked;
@end
@implementation SearchFriendsTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

-(IGUser *)myUser{
    if (!_myUser) {
        _myUser = [LoggedInUser myUser];
    }
    
    return _myUser;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)imageClicked:(id)sender {
    
    if(self.imageButton.image == [UIImage imageNamed:@"smilie"]){
        NSLog(@"You liked %@",self.nameLabel.text);
        
        if([self.myUser add:self.otherUser]){
        
            dispatch_async(dispatch_get_main_queue(),^{
                
                self.imageButton.image = [UIImage imageNamed:@"heartSmiley"];
                
            });
        }
        
        [self.myUser check];
        
    }else{
        NSLog(@"You unliked %@",self.nameLabel.text);
        
        if([self.myUser remove:self.otherUser]){
            
            dispatch_async(dispatch_get_main_queue(),^{
                
                self.imageButton.image = [UIImage imageNamed:@"smilie"];
                
            });
        }
        
    }

}




@end
