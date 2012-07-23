//
//  FirstViewController.h
//  anjweibo
//
//  Created by anjun on 12-6-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshViewController.h"
#import "WBEngine.h"

@interface FirstViewController : PullToRefreshViewController

@property(nonatomic,strong) NSMutableArray* statuses;


@property int pageCount;

@end
