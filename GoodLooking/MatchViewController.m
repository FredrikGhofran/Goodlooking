//
//  MatchViewController.m
//  GoodLooking
//
//  Created by Fredrik Ghofran on 2014-06-05.
//  Copyright (c) 2014 GoodLooking. All rights reserved.
//

#import "MatchViewController.h"
#import "Database.h"
@interface MatchViewController ()

@end

@implementation MatchViewController

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
    NSLog(@"VIEW DID LOAD");
    NSLog(@"matches count %d",[Database matches].count);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [Database matches].count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSLog(@"CELL TEXT %@",[Database matches][indexPath.row]);
    cell.textLabel.text = [Database matches][indexPath.row];
    return cell;
}
@end
