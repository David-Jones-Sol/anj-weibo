//
//  Homeself.m
//  anjweibo
//
//  Created by anjun on 12-7-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define IMAGE_VIEW_HEIGHT 80.f
#import "StatusesCell.h"
#import "UIImageView+WebCache.h"
@implementation StatusesCell
@synthesize retweetedBG = _retweetedBG;
@synthesize profile_image_url = _profile_image_url;
@synthesize screenName = _screenName;
@synthesize countLabel = _countLabel;
@synthesize statusText = _statusText;
@synthesize source = _source;
@synthesize createdAt = _createdAt;
@synthesize statusImageView = _statusImageView;
@synthesize retweetedView = _retweetedView;
@synthesize retweetedText = _retweetedText;
@synthesize retweetedImageView = _retweetedImageView;
-(void)setupLayout:(Status *)status
{
  //  Status *retweetedStatus = status.retweeted_status;
  //  [self.statusText layoutIfNeeded];
    
    //主text高
    CGRect frame = self.statusText.frame;
    frame.size = self.statusText.contentSize;
    self.statusText.frame =frame;

    //主图
     frame = self.statusImageView.frame;
    frame.origin.y = self.statusText.frame.origin.y + self.statusText.frame.size.height;
    frame.size.height = IMAGE_VIEW_HEIGHT;
    self.statusImageView.frame =frame;
 
    //转发text高
  //  [self.retweetedView layoutIfNeeded];

    frame = self.retweetedText.frame;
    frame.size = self.retweetedText.contentSize;
    self.retweetedText.frame =frame;
    
    //转发图
//    frame = self.retweetedImageView.frame;
//    frame.origin.y = self.retweetedText.frame.origin.y + self.retweetedText.frame.size.height;
//    frame.size.height = IMAGE_VIEW_HEIGHT;
//    self.retweetedImageView.frame = frame;
// 
    //转发view
    frame = self.retweetedView.frame;
    
//    if (retweetedStatus.thumbnail_pic) frame.size.height = self.retweetedText.frame.size.height + IMAGE_VIEW_HEIGHT + 10.f;
//    else frame.size.height = self.retweetedText.frame.size.height + 10.f;
//    
    frame.size.height = self.retweetedText.frame.size.height+10.f;
    if(status.thumbnail_pic) frame.origin.y = self.statusText.frame.size.height + self.statusText.frame.origin.y + IMAGE_VIEW_HEIGHT+5.f;
    else frame.origin.y = self.statusText.frame.size.height + self.statusText.frame.origin.y;
    self.retweetedView.frame = frame;

    //背景设置

  //  self.retweetedBG.image = [[UIImage imageNamed:@"timeline_rt_border_t.png"] stretchableImageWithLeftCapWidth:130 topCapHeight:7];
//    [self.retweetedView sendSubviewToBack:self.retweetedBG];
  //  self.retweetedView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_rt_border_t.png"]];
}
-(void)setupCell:(Status *)status
{
    NSString *profile_image_url = [status.user valueForKey:@"profile_image_url"];
    [self.profile_image_url setImageWithURL:[NSURL URLWithString: profile_image_url]placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.screenName.text = [status.user valueForKey:@"screen_name"];
    self.statusText.text = status.text;
    if (status.thumbnail_pic) {
        self.statusImageView.hidden = NO;
        [self.statusImageView setImageWithURL:[NSURL URLWithString: status.thumbnail_pic]];
        
    }
      
    
    self.source.text = [NSString stringWithFormat:@"来自: %@", status.source];
    self.createdAt.text = status.createdAt;
   
    self.countLabel.text = [NSString stringWithFormat:@"转发: %d 评论: %d", status.reposts_count,status.comments_count];
    
    if (status.retweeted_status) {
        Status *retweeted_status = status.retweeted_status;
        NSString *retweetedScreenName = [retweeted_status.user valueForKey:@"screen_name"];
        self.retweetedText.text = [NSString stringWithFormat:@"%@:%@",retweetedScreenName, retweeted_status.text];
//        if (retweeted_status.thumbnail_pic) {
//            self.imageView.hidden = NO;
//            [self.statusImageView setImageWithURL:[NSURL URLWithString: retweeted_status.thumbnail_pic]]; 
//            NSLog(@"retweeted.image:%@",retweeted_status.thumbnail_pic);
//        }
        self.retweetedView.hidden = NO;
        
        
        
    }   
    
    [self setupLayout:status];
}

@end
