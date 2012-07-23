//
//  UserCell.h
//  anjweibo
//
//  Created by anjun on 12-7-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
@protocol UserCellDelegate <NSObject>

-(void)userButtonAction:(long long)userId;

@end
#import <UIKit/UIKit.h>

@interface UserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *userButton;
@property (weak, nonatomic) id<UserCellDelegate> delegate;
@property (assign,nonatomic) long long userId;
@end
