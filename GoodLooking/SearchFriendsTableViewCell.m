//
//  SearchFriendsTableViewCell.m
//  GoodLooking
//
//  Created by Fredrik Ghofran on 2014-05-29.
//  Copyright (c) 2014 GoodLooking. All rights reserved.
//

#import "SearchFriendsTableViewCell.h"
#import "LoggedInUser.h"
#import "Database.h"
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
        self.imageButton.image = [UIImage imageNamed:@"heartSmiley"];

        NSLog(@"You liked %@",self.nameLabel.text);
        [[Database likes]setObject:self.otherUser.username forKey:self.otherUser.username];
        [self add];
        [self check];
        
        
    }else{
        [[Database likes]removeObjectForKey:self.otherUser.username];
        self.imageButton.image = [UIImage imageNamed:@"smilie"];

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
        
        NSLog(@"added %@",self.otherUser.username);
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
        
        
            NSLog(@"removeing my like");
             NSLog(@"setting smilie image");
            NSLog(@"now did %@ get removed",self.otherUser.username);
        dispatch_async(dispatch_get_main_queue(),^{

        self.imageButton.image = [UIImage imageNamed:@"smilie"];

        });
    
        
        
    }];
    [task resume];
}
-(void)check{
    NSString *urlString = [NSString stringWithFormat:@"http://fredrikghofran.com/goodlooking/checkMatch.php?userID=%@&otherUser=%@",self.otherUser.username,self.myUser.username];

    
    NSURL *URL = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *parseError;
        NSLog(@"data =%@ ",data);
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
        NSLog(@"JSONARRAY %@",jsonArray);
        if(jsonArray.count >=1){
            NSLog(@"match");
            [self checkIfMatchExsist];
            
        }else{
         NSLog(@"no match");
        }
        
    }];
    
    
    [task resume];

}
-(void)checkIfMatchExsist
{
    NSString *urlString = [NSString stringWithFormat:@"http://fredrikghofran.com/goodlooking/checkIfMatchesExsist.php?userID=%@&otherUser=%@",self.myUser.username,self.otherUser.username];
    
    
    NSURL *URL = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *parseError;
        NSLog(@"data =%@ ",data);
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
        NSLog(@"JSONARRAY %@",jsonArray);
        if(jsonArray.count >=1){
            dispatch_async(dispatch_get_main_queue(),^{
                [self alertMe];
                NSLog(@"DATABASE MATCHING COUNT IS FIRST %d",[Database matches].count);
            //TA BORT SEN!!!
            [[Database matches] addObject:self.otherUser.username];
            NSLog(@"adding name %@",self.otherUser.username);
            NSString *added =[Database matches][0];
            NSLog(@"Database matches added %@",added);
            //TA BORT SEN!!!
            [self remove];
            [self removeOtherUser];
            });
                
            NSLog(@"already exsisting match");
        }else{
            NSLog(@"match not exsisting");
            [self addMatch];
        }
        
    }];
    
     [task resume];
    
}
-(void)addMatch
{
    NSString *urlString = [NSString stringWithFormat:@"http://fredrikghofran.com/goodlooking/addMatch.php?userID=%@&otherUser=%@",self.myUser.username,self.otherUser.username];
    
    
    NSURL *URL = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(),^{
            [self alertMe];
            [[Database matches] addObject:self.otherUser.username];
            [self remove];
            [self removeOtherUser];
           
        });
        NSLog(@"added match");
    }];
    
    [task resume];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex ==0){
        NSLog(@"Do nothing");
    }else if(buttonIndex == 1){
        NSLog(@"Send request");
    }
}
-(void)removeOtherUser{
    
    NSString *urlString = [NSString stringWithFormat:@"http://fredrikghofran.com/goodlooking/remove.php?userID=%@&otherUser=%@",self.otherUser.username,self.myUser.username];
    NSLog(@"URL %@",urlString);
    NSURL *URL = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
            NSLog(@"removeing other users like");
        [[Database likes]removeObjectForKey:self.otherUser.username];

  
        
        
    }];
    [task resume];
}
-(void)alertMe
{
      UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Match!" message:[NSString stringWithFormat:@"Match with %@",self.otherUser.username] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alertView show];
    [self reloadInputViews];

}

@end
