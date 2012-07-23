//
//  FollowersViewController.h
//  anjweibo
//
//  Created by anjun on 12-6-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshViewController.h"
#import "UserCell.h"
@interface FollowersViewController : PullToRefreshViewController<UserCellDelegate>
@property (nonatomic,strong) NSMutableArray *users;
@end
