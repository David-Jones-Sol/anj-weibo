//
//  Comment.h
//  anjweibo
//
//  Created by anjun on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "User.h"
#import "Status.h"
#import "JSONModel.h"
#import <Foundation/Foundation.h>

@interface Comment : JSONModel
@property (nonatomic, assign) long long		commentId; // 评论ID
@property (nonatomic, strong) NSNumber*		commentKey;
@property (nonatomic, readonly) NSString*         timestamp;
@property (nonatomic, strong) NSString*		text; //评论内容
@property(nonatomic,strong) NSString *createdAt;
@property (nonatomic, strong) NSString*		source; //评论来源
@property (nonatomic, strong) NSString*		sourceUrl; //评论来源
@property (nonatomic, assign) BOOL			favorited; //是否收藏
@property (nonatomic, assign) BOOL			truncated; //是否被截断
@property (nonatomic, strong) User*			user; //评论人信息
@property (nonatomic, strong) Status*			status; //评论的微博
@property (nonatomic, strong) Comment*		replyComment; //评论来源
@end
