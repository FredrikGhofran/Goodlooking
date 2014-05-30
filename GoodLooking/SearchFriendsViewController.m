//
//  SearchFriendsViewController.m
//  GoodLooking
//
//  Created by Fredrik Ghofran on 2014-05-29.
//  Copyright (c) 2014 GoodLooking. All rights reserved.
//

#import "SearchFriendsViewController.h"
#import "LoggedInUser.h"
#import "SearchFriendsTableViewCell.h"
@interface SearchFriendsViewController ()
@property(nonatomic)IGUser *myUser;
@property(nonatomic)NSMutableArray *currentNames;
@property(nonatomic)NSMutableDictionary *friendsDictionary;
@property(nonatomic)NSArray *searchResult;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentController;
@end

@implementation SearchFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.currentNames =[[NSMutableArray alloc]init];
    self.myUser = [LoggedInUser myUser];
    int followingCount = self.myUser.follows_count.intValue*2;
    if(!self.friendsDictionary){
        
    
    [NRGramKit getUsersFollowingUserWithId:self.myUser.Id count:followingCount withCallback:^(NSArray * following) {
         self.friendsDictionary =[[NSMutableDictionary alloc]init];
        int i =0;
        for (IGUser *user in following) {
            i++;
            NSLog(@"HÄMTAR ANVÄNDARE : %@",user.username);
            NSLog(@"%d",i);
            [NRGramKit getRelationshipWithUser:user.Id withCallback:^(IGIncomingRelationshipStatus incoming, IGOutgoingRelationshipStatus outcoming) {
                if (outcoming == IGOutgoingRelationshipFollows && incoming ==IGIncomingRelationshipFollowedBy ) {
                    NSLog(@"LÄGGER TILL ANVÄNDARE= %@",user.username);
                    [self.currentNames addObject:user.username];
                    [self.friendsDictionary setObject:[@[user,@"no pic"]mutableCopy] forKey:user.username];
                    dispatch_async(dispatch_get_main_queue(),^{
                        [self.tableView reloadData];
                    });
                }
                
            }];

        }

    }];
        
    }
    
}
- (IBAction)segmentedClick:(UISegmentedControl *)sender {
    
    if(sender.selectedSegmentIndex==1){
        int followersCount = self.myUser.followed_by_count.integerValue*2;
        NSLog(@"FOLLOWERSCOUNT %d",followersCount);
        [NRGramKit getUsersWhoFollowUserWithId:self.myUser.Id count:followersCount withCallback:^(NSArray *followers) {
            self.currentNames=[@[]mutableCopy];

            for (IGUser *user in followers) {
                [self.currentNames addObject:user.username];
                if(![self.friendsDictionary objectForKey:user.username]){
                    [self.friendsDictionary setObject:[@[user,@"no pic"]mutableCopy] forKey:user.username];
              
                    
                }
                dispatch_async(dispatch_get_main_queue(),^{
                    [self.tableView reloadData];
                });
            }
        }];
    }else{
        
        int followersCount = self.myUser.follows_count.integerValue*2;
        NSLog(@"FOLLOWERSCOUNT %d",followersCount);

        [NRGramKit getUsersFollowingUserWithId:self.myUser.Id count:followersCount withCallback:^(NSArray *following) {
             self.currentNames=[@[]mutableCopy];
            for (IGUser *user in following) {
                [self.currentNames addObject:user.username];
                if(![self.friendsDictionary objectForKey:user.username]){
                    [self.friendsDictionary setObject:[@[user,@"no pic"]mutableCopy] forKey:user.username];
                    
                }
                dispatch_async(dispatch_get_main_queue(),^{
                    [self.tableView reloadData];
                });
            }
        }];

    
    }
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    NSPredicate *searchPredicate =[NSPredicate predicateWithFormat:@"description contains[c] %@",searchString];
    self.searchResult = [self.currentNames filteredArrayUsingPredicate:searchPredicate];
    
    
    return YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return self.searchResult.count;
    }else{
        return self.currentNames.count;
        
    }}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchFriendsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
   

    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        cell.userInteractionEnabled = NO;
        NSString *userName = self.searchResult[indexPath.row];
        IGUser *user =self.friendsDictionary[userName][0];
        [self createImage:user];
        
     //   NSLog(@"search");
        cell.nameLabel.text = user.username;
   
        cell.imageLabel.image =self.friendsDictionary[user.username][2];

    }else{
        NSString *userName = self.currentNames[indexPath.row];
        IGUser *user =self.friendsDictionary[userName][0];
        [self createImage:user];
        
       // NSLog(@"not search");
        cell.nameLabel.text = user.username;
        cell.imageLabel.image =self.friendsDictionary[user.username][2];
        
    }
    return cell;
    
}
-(void)createImage:(IGUser *)user
{
    NSString *imageMessage = self.friendsDictionary[user.username][1];
    
    if([imageMessage isEqualToString:@"no pic"]){
        NSURL *fotoURL =[NSURL URLWithString:user.profile_picture];
        NSData *data= [[NSData alloc]initWithContentsOfURL:fotoURL];
        UIImage *image= [[UIImage alloc] initWithData:data];
        NSMutableArray *userArray = [@[user,@"pic",image]mutableCopy];
        [self.friendsDictionary setObject:userArray forKey:user.username];
        
        
    }
    
    
}




@end
