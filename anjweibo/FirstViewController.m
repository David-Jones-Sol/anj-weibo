//
//  FirstViewController.m
//  anjweibo
//
//  Created by anjun on 12-6-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+Additions.h"
#import "StatusesCell.h"
#import "FirstViewController.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "UIImageView+WebCache.h"
#import "Status.h"
#import "WBMessage.h"
#import "AppCache.h"
#import "CommentViewController.h"


extern NSString *uid;
extern NSString *accessToken;
extern WBEngine *engine;
@interface FirstViewController ()

@end

@implementation FirstViewController


@synthesize statuses = _statuses;
@synthesize pageCount = _pageCount;


- (IBAction)refresh:(UIBarButtonItem *)sender {
   
    self.refreshing = YES;
    [engine getHomeLine:-1 maxID:-1 count:-1 page:-1 baseApp:-1 feature:-1];
 
}

-(void) loadingComplete  {
    [self refresh:nil];
    self.loading = NO;
}


-(void) incrementPageCount  {
    int pageC = self.pageCount +1;
     [engine getHomeLine:-1 maxID:-1 count:-1 page:pageC baseApp:-1 feature:-1];

}

-(void)prepare{
    [engine getHomeLine:-1 maxID:-1 count:-1 page:-1 baseApp:-1 feature:-1];
    self.pageCount = 0;
    self.numberOfSections = 1;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didGetHomeLine:)    name:MMSinaGotHomeLine          object:nil];
    [center addObserver:self selector:@selector(shouldAuth)    name:MMSinaShouldAuth          object:nil];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!accessToken) {
        [self shouldAuth];
    }else {
         [self prepare];
    }
   
}


-(void)didGetHomeLine:(NSNotification*)sender
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

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (self.isOauth) {
        [self prepare];
        self.isOauth = NO;
    }
   
}
- (void)viewWillDisappear:(BOOL)animated
{  
    [super viewWillDisappear:animated];
}
- (void)viewDidUnload
{
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:MMSinaShouldAuth object:nil];
    [center removeObserver:self name:MMSinaGotHomeLine object:nil];
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}*/

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

    if ([self.statuses count] >0) {
        Status *status = [self.statuses objectAtIndex:indexPath.row];
        [cell setupCell:status];
    }
    

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
    if ([self.statuses count] == 0) {
        return 44.f;
    }
    Status *status = [self.statuses objectAtIndex:indexPath.row];
   
    
    static NSString *CellIdentifier = @"statusCell";
    StatusesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StatusCell" owner:self options:nil];
		cell = (StatusesCell*)[nib objectAtIndex:0];
	}
	
    CGFloat height = [self getHeight:cell withContent:status];
    return height;
  /*  
    CGFloat height = [self cellHeight:status.text with:310.f ];

    if (status.thumbnail_pic) {
        height = height+IMAGE_VIEW_HEIGHT;
    }
    //有转发的博文
    if (retweeted_status && ![retweeted_status isEqual:[NSNull null]])
    {
        NSString *screenName = [status.retweeted_status.user valueForKey:@"screen_name"];
        height = height + [self cellHeight:[NSString stringWithFormat:@"%@:%@",screenName, retweeted_status.text] with:250.0f]+10.f;
    
//        if (retweeted_status.thumbnail_pic) {
//            height = height +IMAGE_VIEW_HEIGHT;
//        }
    }

    return height+60.f;*/
}
//计算text 的高度。
-(CGFloat)cellHeight:(NSString*)contentText with:(CGFloat)with
{
    
    CGSize size=[contentText sizeWithFont:[UIFont  systemFontOfSize:14.f] constrainedToSize:CGSizeMake(with, 30000.0f) lineBreakMode:UILineBreakModeWordWrap];
    return  size.height+40.f;
    
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Status *status = [self.statuses objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"firstDetail" sender:status];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([[segue identifier] isEqualToString:@"firstDetail"])
    {
        CommentViewController *vc = [segue destinationViewController];
        vc.status = sender;
    }
    
}


@end
