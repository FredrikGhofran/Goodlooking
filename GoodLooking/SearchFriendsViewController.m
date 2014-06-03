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
#import "Database.h"
@interface SearchFriendsViewController ()
@property(nonatomic)IGUser *myUser;
@property(nonatomic)NSMutableArray *currentNames;
@property(nonatomic)NSMutableDictionary *friendsDictionary;
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
   
    self.currentNames =[[NSMutableArray alloc]init];
    self.myUser = [LoggedInUser myUser];
    int followingCount = self.myUser.follows_count.intValue*2;
    if(!self.friendsDictionary){
        
    
    [NRGramKit getUsersFollowingUserWithId:self.myUser.Id count:followingCount withCallback:^(NSArray * following) {
         self.friendsDictionary =[[NSMutableDictionary alloc]init];
        for (IGUser *user in following) {
        
            [NRGramKit getRelationshipWithUser:user.Id withCallback:^(IGIncomingRelationshipStatus incoming, IGOutgoingRelationshipStatus outcoming) {
                if (outcoming == IGOutgoingRelationshipFollows && incoming ==IGIncomingRelationshipFollowedBy ) {
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
    
    [self getLikes];
}


- (IBAction)logUtClick:(id)sender {
    [NRGramKit logout];
    
    UINavigationController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StartView"];
    [self presentViewController:vc animated:YES completion:nil];
    
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
        cell.otherUser = user;
        if([[Database database] objectForKey:user.username]){
            
            cell.imageButton.image =[UIImage imageNamed:@"heartSmiley"];
        }else{
        cell.imageButton.image =[UIImage imageNamed:@"smilie"];
        }
        [self createImage:user];
        
     //   NSLog(@"search");
        cell.nameLabel.text = user.username;
   
        cell.imageLabel.image =self.friendsDictionary[user.username][2];

    }else{
        NSString *userName = self.currentNames[indexPath.row];
        IGUser *user =self.friendsDictionary[userName][0];
        cell.otherUser = user;
        if([[Database database] objectForKey:user.username]){
            
            cell.imageButton.image =[UIImage imageNamed:@"heartSmiley"];
        }else{

            cell.imageButton.image =[UIImage imageNamed:@"smilie"];
        }
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

-(void)getLikes
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    NSString *urlString = [NSString stringWithFormat:@"http://fredrikghofran.com/goodlooking/getLikes.php?userID=%@",self.myUser.username];
    
    
    NSURL *URL = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *parseError;
        NSLog(@"data =%@ ",data);
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
        NSLog(@"JSONARRAY %@",jsonArray);
        if(jsonArray.count >=1){
            NSLog(@"you have liked %d persons",jsonArray.count);
            for(int i = 0;i<jsonArray.count;i++){
                NSDictionary *dic = jsonArray[i];
                
                NSString *name = dic[@"otherUser"];
                
                [[Database database] setObject:name forKey:name];
            }
            
        }else{
            NSLog(@"no likes");
            
        }
        
    }];
    
    
    [task resume];


}




@end
