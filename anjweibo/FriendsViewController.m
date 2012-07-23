//
//  FriendsViewController.m
//  anjweibo
//
//  Created by anjun on 12-6-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FriendsViewController.h"
#import "OauthViewController.h"
#import "WBMessage.h"
#import "Status.h"
#import "UIImageView+WebCache.h"
#import "UserCell.h"
#import "User.h"
#import "UIAlertView+Blocks.h"
#import "UserStatusViewController.h"
extern  WBEngine    *engine;
extern NSString *accessToken;
extern NSString *uid;
@interface FriendsViewController ()

@end

@implementation FriendsViewController
@synthesize users = _users;

- (IBAction)refresh:(UIBarButtonItem *)sender {

    [engine getFollowingUserList:[uid longLongValue] count:100 cursor:-1];
}
- (void)viewWillAppear:(BOOL)animated {
    if (self.isOauth) {
        [self prepare];
        self.isOauth= NO;
    }
    [super viewWillAppear:YES];
}

-(void) loadingComplete  {
      [self refresh:nil];
    self.loading = NO;
}


-(void) incrementPageCount  {
    
    [engine getFollowingUserList:[uid longLongValue] count:100 cursor:-1];
}

-(void) loadMore  {
    
    [self performSelector:@selector(incrementPageCount) withObject:nil afterDelay:2];
}
-(void)prepare{
    
    [engine getFollowingUserList:[uid longLongValue] count:100 cursor:-1];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didGetFollowingUsersList:) name:MMSinaGotFollowingUserList object:nil];
    [center addObserver:self selector:@selector(didUnfollowByUserIDWithResult:) name:MMSinaUnfollowedByUserIDWithResult object:nil];
    [center addObserver:self selector:@selector(shouldAuth) name:MMSinaShouldAuth          object:nil];
    [center addObserver:self selector:@selector(shouldAuth)    name:MMSinaShouldAuth          object:nil];
}
- (void)viewDidLoad
{
 
    self.numberOfSections = 1;
    [super viewDidLoad];

    if (!accessToken) {
        [self shouldAuth];
    }else {
        [self prepare];

    }
   
}
-(void)didGetFollowingUsersList:(NSNotification*)sender
{
    if(self.users == nil) self.users = [[NSMutableArray alloc]init];
    [self.users removeAllObjects];
    for (NSMutableDictionary *dic in sender.object) {
   
        User *user = [[User alloc]initWithDictionary:dic];
        [self.users addObject:user];

    }
   
    [self.tableView reloadData];
    NSLog(@"users:%d",self.users.count);
   

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:MMSinaGotFollowingUserList object:nil];
    [center removeObserver:self name:MMSinaUnfollowedByUserIDWithResult object:nil];
     [center removeObserver:self name:MMSinaShouldAuth object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if(section == self.numberOfSections)  {
//        return [super tableView:tableView numberOfRowsInSection:section];
//    }
    return [self.users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.section == self.numberOfSections)  {
//        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
//    }
    static NSString *CellIdentifier = @"userCell";
    
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserCell" owner:self options:nil];
		cell = (UserCell*)[nib objectAtIndex:0];
	}
    
    if (self.users.count >0) {
        User *user = [self.users objectAtIndex:indexPath.row];
        
        [cell.imageView setImageWithURL:[NSURL URLWithString: user.profile_image_url]placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        cell.nameLabel.text = user.screen_name;
        
        cell.delegate = self;
        cell.userId = user.userId;
    }


    return cell;
}
-(void)userButtonAction:(long long)userId
{
    [UIAlertView showAlertViewWithTitle:@"确认对话框"
                                message:@"你真的要取取消关注吧？" 
                      cancelButtonTitle:@"取消" 
                      otherButtonTitles:[NSArray arrayWithObject:@"确认"] 
                              onDismiss:^(int buttonIndex){
                                  [engine unfollowByUserID:userId];
                                     [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(refresh:) userInfo:nil repeats:NO];
                                    } 
                               onCancel:^{}
                                   
                               ];

}
-(void)didUnfollowByUserIDWithResult:(NSNotification*)sender
{
  
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
