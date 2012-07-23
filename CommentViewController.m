//
//  FirstDetailViewController.m
//  anjweibo
//
//  Created by anjun on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommentViewController.h"
#import "NSDictionary+Additions.h"
#import "CommentCell.h"
#import "StatusesCell.h"
#import "Comment.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "UIImageView+WebCache.h"
#import "Status.h"
#import "WBMessage.h"
#import "AppCache.h"

static BOOL refreshing ;
extern NSString *uid;
extern NSString *accessToken;
extern WBEngine *engine;
@interface CommentViewController ()

@end

@implementation CommentViewController

@synthesize status = _status;
@synthesize comments = _comments;
@synthesize pageCount = _pageCount;
- (IBAction)refresh:(UIBarButtonItem *)sender {
    
    [engine getCommentListWithID:self.status.statusId];
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
       
        
       [engine getCommentListWithID:self.status.statusId];
        self.pageCount = 1;
  
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(didGetComments:)    name:MMSinaGotCommentList          object:nil];
        [center addObserver:self selector:@selector(shouldAuth)    name:MMSinaShouldAuth          object:nil];
    }
}
#pragma WBEngine delegate mothed
-(void)shouldAuth
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
    [self presentViewController:[story instantiateViewControllerWithIdentifier:@"oauthVC"]animated:YES completion:nil];
    
}

- (void)viewDidUnload
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:MMSinaShouldAuth object:nil];
    [center removeObserver:self name:MMSinaGotCommentList object:nil];
    [super viewDidUnload];
}
-(void)didGetComments:(NSNotification*)sender
{
    if(self.comments == nil) self.comments = [[NSMutableArray alloc]init];
    if (refreshing) {
        [self.comments removeAllObjects];
        refreshing = NO;
    }
    for (NSMutableDictionary *dic in sender.object) {
        Comment *comment = [[Comment alloc] initWithDictionary:dic];
        [self.comments addObject:comment];
    }

   
    [self.tableView reloadData];
    
 
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([self.comments count]==0) return 1;

    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    if (section == 0) {
        return 1;
    }
    return [self.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row ==  0) {
        static NSString *CellIdentifier = @"statusCell";
        
        StatusesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StatusCell" owner:self options:nil];
            cell = (StatusesCell*)[nib objectAtIndex:0];
        }
        
        [cell setupCell:self.status];
        
        return cell;
    }
  

        static NSString *CellIdentifier = @"commentCell";
        
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil];
            cell = (CommentCell*)[nib objectAtIndex:0];
        }
   
         Comment *comment = [self.comments objectAtIndex:indexPath.row];
        cell.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    /*
    [cell.textLabel setLineBreakMode:UILineBreakModeWordWrap];
    [cell.textLabel setMinimumFontSize:14.f];
    [cell.textLabel setNumberOfLines:0];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14.f]];*/
        cell.textLabel.text = comment.text;
        cell.createdAt.text = comment.createdAt;
        cell.screenName.text = [comment.user valueForKey:@"screen_name"];
        
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
    if (indexPath.section == 0 && indexPath.row == 0) {
     
        Status *status = self.status;    
        
        static NSString *CellIdentifier = @"statusCell";
        StatusesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StatusCell" owner:self options:nil];
            cell = (StatusesCell*)[nib objectAtIndex:0];
        }
        
        CGFloat height = [self getHeight:cell withContent:status];
        return height;
    }
    
    Comment *comment = [self.comments objectAtIndex:indexPath.row];
    CGFloat height = [self cellHeight:comment.text with:200.f ];
    height =MAX(height, 44.f);
    return height+20.f;
    
}
//计算text 的高度。
-(CGFloat)cellHeight:(NSString*)contentText with:(CGFloat)with
{
    
    CGSize size=[contentText sizeWithFont:[UIFont  systemFontOfSize:14.f] constrainedToSize:CGSizeMake(with, 300000.0f) lineBreakMode:UILineBreakModeWordWrap];
    return  size.height;
    
}

@end
