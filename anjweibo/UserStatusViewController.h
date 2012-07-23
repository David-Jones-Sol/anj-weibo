//
//  HomeViewController.h
//  anjweibo
//
//  Created by anjun on 12-6-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USViewController.h"
#import "WBMessage.h"
#import "User.h"
#import "PullToRefreshViewController.h"
@interface UserStatusViewController :PullToRefreshViewController
@property (nonatomic,strong) NSMutableArray *statuses;
@property (nonatomic,strong) User   *user;
@property (weak, nonatomic) IBOutlet UILabel *screen_name;
@property (weak, nonatomic) IBOutlet UILabel *followers_count;

@property (weak, nonatomic) IBOutlet UILabel *friends_count;
@property (weak, nonatomic) IBOutlet UILabel *statuses_count;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UIImageView *avatar_large;
@end
