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
@property(nonatomic)NSMutableArray *followers;  //sparar IGusers i en array för att hämta användar med indexpath
@property(nonatomic)NSMutableArray *followersName;     // sparar IGUsers namn för att kunna visa upp i sök
@property(nonatomic)NSMutableDictionary *followersDic; // Sparar IGUsers med namn nyklar för att kunna hämta users med followers names

@property(nonatomic)NSMutableDictionary *images;
@property(nonatomic)NSArray *searchResult;
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
    self.followersDic =[[NSMutableDictionary alloc]init];
    self.followersName =[[NSMutableArray alloc]init];
    self.myUser = [LoggedInUser myUser];
    self.images = [[NSMutableDictionary alloc]init];
    int followersCount = self.myUser.follows_count.intValue;
    
    [NRGramKit getUsersFollowingUserWithId:self.myUser.Id count:followersCount withCallback:^(NSArray * followers) {
        
        self.followers =[followers mutableCopy];
        for (IGUser *user in self.followers) {
            [self.followersName addObject:user.username];
            [self.followersDic setObject:user forKey:user.username];
        }
        dispatch_async(dispatch_get_main_queue(),^{
            [self.tableView reloadData];
        });
    }];

    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    NSPredicate *searchPredicate =[NSPredicate predicateWithFormat:@"description contains[c] %@",searchString];
    self.searchResult = [self.followersName filteredArrayUsingPredicate:searchPredicate];
    
    
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
        return self.followersName
        .count;
        
    }}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchFriendsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    IGUser *user = self.followers[indexPath.row];
    NSLog(@"INDEXPATH ROW = %d",indexPath.row);
    [self createImage:user];

    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        NSLog(@"search");
        cell.nameLabel.text = self.searchResult[indexPath.row];
        [self createImage:[self.followersDic objectForKey:self.searchResult[indexPath.row]]];
        if(![self.images objectForKey:self.searchResult[indexPath.row]]){
            NSLog(@"BILDEN HAr inte häMTATS");
        }
        cell.imageLabel.image =[self.images objectForKey:self.searchResult[indexPath.row]];

    }else{
        NSLog(@"not search");
        cell.nameLabel.text = self.followersName[indexPath.row];
        cell.imageLabel.image =[self.images objectForKey:user.username];
        
    }
    return cell;
    
}
-(void)createImage:(IGUser *)user
{
    
    if(![self.images objectForKey:user.username]){
        NSURL *fotoURL =[NSURL URLWithString:user.profile_picture];
        
        NSData *data= [[NSData alloc]initWithContentsOfURL:fotoURL];
        
        UIImage *image= [[UIImage alloc] initWithData:data];
        
        [self.images setObject:image forKey:user.username];
        
        
    }
    
    
}




@end
