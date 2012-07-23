//
//  FollowersViewController.m
//  anjweibo
//
//  Created by anjun on 12-6-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FollowersViewController.h"
#import "WBMessage.h"
#import "Status.h"
#import "UIImageView+WebCache.h"
#import "UserCell.h"
#import "User.h"
#import "UserStatusViewController.h"

extern  WBEngine    *engine;
extern  NSString *accessToken;
extern NSString *uid;
@interface FollowersViewController ()

@end

@implementation FollowersViewController
@synthesize users = _users;

- (IBAction)refresh:(UIBarButtonItem *)sender {
    
    [engine getFollowedUserList:[uid longLongValue] count:100 cursor:-1];
    
}
-(void) loadingComplete  {
    [self refresh:nil];
    self.loading = NO;
}
-(void)prepare{
    [engine getFollowedUserList:[uid longLongValue] count:100 cursor:-1];
    
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didGetFollowedUsersList:) name:MMSinaGotFollowedUserList object:nil];
    [center addObserver:self selector:@selector(shouldAuth)    name:MMSinaShouldAuth          object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    engine = [WBEngine sharedInstance];
    if (!engine.accessToken) {
        [self shouldAuth];
    }else {
        
        [self prepare];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (self.isOauth) {
        [self prepare];
        self.isOauth = NO;
    }
    
}
-(void)didGetFollowedUsersList:(NSNotification*)sender
{
    if(self.users == nil) self.users = [[NSMutableArray alloc]init];
    [self.users removeAllObjects];
    for (NSMutableDictionary *dic in sender.object) {
        
        User *user = [[User alloc]initWithDictionary:dic];
        [self.users addObject:user];
    
    }
    
    [self.tableView reloadData];
    NSLog(@"useres.count:%u",[self.users count]);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
     NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:MMSinaGotFollowedUserList object:nil];
    [center removeObserver:self name:MMSinaShouldAuth object:nil];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    static NSString *CellIdentifier = @"userCell";
    
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserCell" owner:self options:nil];
		cell = (UserCell*)[nib objectAtIndex:0];
	}
    
    
    User *user = [self.users objectAtIndex:indexPath.row];
    
    [cell.imageView setImageWithURL:[NSURL URLWithString: user.profile_image_url]placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.nameLabel.text = user.screen_name;
    if(!user.following)
    {
        cell.userButton.titleLabel.text = @"关注";
    }else {
        CGRect frmae = cell.userButton.frame;
        [cell.userButton removeFromSuperview];
        UILabel *newLabel = [[UILabel alloc]initWithFrame:frmae];
        newLabel.text = @"已关注";
        [cell.contentView addSubview:newLabel];
    }
    cell.delegate = self;
    cell.userId = user.userId;
    return cell;
}
-(void)userButtonAction:(long long)userId
{
    [engine followByUserID:userId];
   
    [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(refresh:) userInfo:nil repeats:NO];
    [self.tableView reloadData];
}
-(void)didFollowByUserIDWithResult:(NSNotification*)sender
{
   //
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
    UserStatusViewController *vc = [story instantiateViewControllerWithIdentifier:@"friendUserStatusVC"];
    vc.user  = [self.users objectAtIndex:indexPath.row]; 
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
