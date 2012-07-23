//
//  HomeCell.h
//  anjweibo
//
//  Created by anjun on 12-7-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Status.h"
@interface StatusesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profile_image_url;
@property (weak, nonatomic) IBOutlet UILabel *screenName;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UITextView *statusText;
@property (weak, nonatomic) IBOutlet UILabel *source;
@property (weak, nonatomic) IBOutlet UILabel *createdAt;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UIView *retweetedView;
@property (weak, nonatomic) IBOutlet UITextView *retweetedText;
@property (weak, nonatomic) IBOutlet UIImageView *retweetedImageView;
-(void)setupCell:(Status*)status;
@property (weak, nonatomic) IBOutlet UIImageView *retweetedBG;

@end
