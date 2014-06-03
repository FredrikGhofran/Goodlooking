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
        
        [self add];
        
    }else{
        NSLog(@"You unliked %@",self.nameLabel.text);
        [self remove];
        
        
    }


    
}
-(void)add
{
    NSString *urlString = [NSString stringWithFormat:@"http://fredrikghofran.com/goodlooking/add.php?userID=%@&otherUser=%@",self.myUser.username,self.otherUser.username];
    NSLog(@"URL %@",urlString);
    NSURL *URL = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(),^{
            
        self.imageButton.image = [UIImage imageNamed:@"heartSmiley"];
            
         });
        
        
        NSLog(@"add");
    }];
    [task resume];
}
-(void)remove{

    NSString *urlString = [NSString stringWithFormat:@"http://fredrikghofran.com/goodlooking/remove.php?userID=%@&otherUser=%@",self.myUser.username,self.otherUser.username];
    NSLog(@"URL %@",urlString);
    NSURL *URL = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            self.imageButton.image = [UIImage imageNamed:@"smilie"];
            
        });
        
        
        NSLog(@"remove");
    }];
    [task resume];
}
-(void)check{
    NSString *urlString = [NSString stringWithFormat:@"http://fredrikghofran.com/goodlooking/json.php?userID=%@",self.myUser.username];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSLog(@"click");
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *parseError;
        NSLog(@"data =%@ ",data);
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];

        if(jsonArray.count >=1){
            //UPDATE
            NSString *urlString = [NSString stringWithFormat:@"http://fredrikghofran.com/goodlooking/update.php?userID=%@&otherUser=%@",self.myUser.username,self.otherUser.Id];
            
            NSURL *URL = [NSURL URLWithString:urlString];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            
            NSURLSession *session = [NSURLSession sharedSession];
            
            NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSLog(@"update");
             }];
            [task resume];
        }else{
        //ADD
            NSLog(@"MY username %@",self.myUser.username);

        
        }
        
    }];
    
    
    [task resume];

}

@end
