//
//  HomeViewController.m
//  anjweibo
//
//  Created by anjun on 12-6-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserStatusViewController.h"
#import "StatusesCell.h"
#import "WBMessage.h"
#import "Status.h"
#import "User.h"
#import "UIImageView+WebCache.h"
#import "CommentViewController.h"

extern  WBEngine    *engine;
extern NSString *accessToken;
extern NSString *uid;
@interface UserStatusViewController ()

@end

@implementation UserStatusViewController
@synthesize statuses = _statuses;
@synthesize user =  _user;

@synthesize screen_name = _screen_name;
@synthesize followers_count = _followers_count;

@synthesize friends_count = _friends_count;
@synthesize statuses_count = _statuses_count;
@synthesize desc = _desc;
@synthesize avatar_large = _avatar_large;

- (IBAction)refresh:(UIBarButtonItem *)sender {
    self.refreshing = YES;
    [engine getUserStatusUserID:
     [NSString stringWithFormat:@"%llu", self.user.userId ]
                        sinceID:-1 maxID:-1 count:-1 page:-1 baseApp:-1 feature:-1];    
}
-(void) loadingComplete  {
    [self refresh:nil];
    self.loading = NO;
}
-(void) incrementPageCount  {
    int pageC = self.pageCount +1;
    [engine getUserStatusUserID:
     uid sinceID:-1 maxID:-1 count:-1 page:pageC baseApp:-1 feature:-1];
}

- (IBAction)compose:(UIBarButtonItem *)sender {
    [self.tableView reloadData];
}
-(void)prepare{
    [engine getUserStatusUserID:
     [NSString stringWithFormat:@"%llu", self.user.userId ]
                        sinceID:-1 maxID:-1 count:-1 page:-1 baseApp:-1 feature:-1];
   
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:MMSinaShouldAuth object:nil];
    [center addObserver:self selector:@selector(didGetUserStatus:) name:MMSinaGotUserStatus object:nil];
    [center addObserver:self selector:@selector(shouldAuth)    name:MMSinaShouldAuth          object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.numberOfSections =1;

    if (!accessToken) {
        [self shouldAuth];
    }else {
        [self prepare];
    }


}
-(void)viewWillAppear:(BOOL)animated{
    [self setupUser];
    if (self.isOauth) {
        [self prepare];
        self.isOauth = NO;
    }
    [super viewWillAppear:YES];
}
- (void)viewDidUnload
{
  
    [self setScreen_name:nil];
    [self setFollowers_count:nil];
    [self setFriends_count:nil];
    [self setStatuses_count:nil];
    [self setDesc:nil];
    [self setAvatar_large:nil];
    [super viewDidUnload];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:MMSinaGotUserStatus object:nil];
    [center removeObserver:self name:MMSinaShouldAuth object:nil ];

}
-(void)setupUser
{
    [self.avatar_large setImageWithURL:[NSURL URLWithString:self.user.avatar_large] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.friends_count.text = [NSString stringWithFormat:@"%d", self.user.friends_count];
    self.statuses_count.text = [NSString stringWithFormat:@"%d",self.user.statuses_count];
    self.followers_count.text = [NSString stringWithFormat:@"%d",self.user.followers_count];
    self.screen_name.text = self.user.screen_name;
    self.desc.text = self.user.location; 
    self.navigationItem.title = self.user.screen_name;
}
-(void)didGetUserInfo:(NSNotification*)sender
{
    NSDictionary *dic = sender.object;
    self.user = [[User alloc]initWithDictionary:dic];
    [self setupUser];

}
-(void)didGetUserStatus:(NSNotification*)sender
{
    if(self.statuses == nil) self.statuses = [[NSMutableArray alloc]init];
    if (self.refreshing) {
        [self.statuses removeAllObjects];
        self.refreshing = NO;
    }
    for (NSMutableDictionary *dic in sender.object) {
        Status *status = [[Status alloc]initWithDictionary:dic];
        [self.statuses addObject:status];
    }
    self.pageCount = [self.statuses count]/20;
    if(self.pageCount == 3) self.endReached = YES;
    [self.tableView reloadData];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == self.numberOfSections)  {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
    return [self.statuses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == self.numberOfSections)  {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    static NSString *CellIdentifier = @"statusCell";
    
    StatusesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

   if (cell == nil) {
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StatusCell" owner:self options:nil];
		cell = (StatusesCell*)[nib objectAtIndex:0];
	}
    
    
    Status *status = [self.statuses objectAtIndex:indexPath.row];
    [cell setupCell:status];
    return cell;
}
-(CGFloat)getHeight:(StatusesCell*)cell withContent:(Status*)status 
{
    CGFloat h=0.f;
    cell.statusText.text = status.text;
    h = cell.statusText.contentSize.height;
    
    Status *retweeted  =status.retweeted_status;
    if (retweeted) {
        NSString *screenName = [retweeted.user valueForKey:@"screen_name"];
        cell.retweetedText.text = [NSString stringWithFormat:@"%@:%@",screenName, retweeted.text];
        h = h + cell.retweetedText.contentSize.height+20.f;
    }
    
    if (status.thumbnail_pic) {
        h = h + 90.f;
    }
    
    return h+60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Status *status = [self.statuses objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"statusCell";
    StatusesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StatusCell" owner:self options:nil];
		cell = (StatusesCell*)[nib objectAtIndex:0];
	}
	
    CGFloat height = [self getHeight:cell withContent:status];
    return height;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
    CommentViewController *vc = [story instantiateViewControllerWithIdentifier:@"commentVC"];
    vc.status  = [self.statuses objectAtIndex:indexPath.row]; 
    [self.navigationController pushViewController:vc animated:YES];
}

@end
