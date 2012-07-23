//
//  UserCell.m
//  anjweibo
//
//  Created by anjun on 12-7-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserCell.h"

@implementation UserCell
@synthesize imageView;
@synthesize nameLabel;
@synthesize userButton;
@synthesize delegate = _delegate;
@synthesize userId = _userId;

- (IBAction)userButtonAction:(UIButton *)sender {
  [self.delegate userButtonAction:self.userId];

}

@end
