//
//  HotRepostViewController.m
//  anjweibo
//
//  Created by anjun on 12-7-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HotRepostViewController.h"
#import "StatusesCell.h"
#import "Status.h"
#import "UIImageView+WebCache.h"
#import "CommentViewController.h"

static NSNotificationCenter *center;
extern NSString *uid;
extern NSString *accessToken;
extern WBEngine *engine;
@interface HotRepostViewController ()

@end

@implementation HotRepostViewController
@synthesize statuses = _statuses;
- (IBAction)refresh:(UIBarButtonItem *)sender {
    
    [engine getHotRepostDaily:50];
    
}
-(void) loadingComplete  {
    [self refresh:nil];
    self.loading = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    engine = [WBEngine sharedInstance];
    if (!accessToken) {
        [self shouldAuth];
    }else {
        
        [engine getHotRepostDaily:50];
        
        center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(didGetHotRepostDaily:) name:MMSinaGotHotRepostDaily object:nil];
    }
    
    
}
-(void)didGetHotRepostDaily:(NSNotification*)sender
{
    if(self.statuses == nil) self.statuses = [[NSMutableArray alloc]init];

    for (NSMutableDictionary *dic in sender.object) {
        Status *status = [[Status alloc]initWithDictionary:dic];
        [self.statuses addObject:status];
    }

    [self.tableView reloadData];
       
}
#pragma WBEngine delegate mothed
-(void)shouldAuth
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
    [self presentViewController:[story instantiateViewControllerWithIdentifier:@"oauthVC"]animated:YES completion:nil];    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [center removeObserver:self name:MMSinaGotHotRepostDaily object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.statuses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
	[self.tableView reloadData];
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
