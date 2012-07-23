//
//  FirstDetailViewController.h
//  anjweibo
//
//  Created by anjun on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshViewController.h"
#import "Status.h"
@interface CommentViewController : PullToRefreshViewController
@property(nonatomic,strong) NSMutableArray *comments;
@property(nonatomic,strong) Status *status;
@property int pageCount;

@end
