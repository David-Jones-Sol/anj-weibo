//
//  HotRepostViewController.h
//  anjweibo
//
//  Created by anjun on 12-7-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBMessage.h"
#import "PullToRefreshViewController.h"
@interface HotRepostViewController : PullToRefreshViewController

@property(nonatomic,strong) NSMutableArray* statuses;


@end
