//
//  Status.h
//  anjweibo
//
//  Created by anjun on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "User.h"
#import <Foundation/Foundation.h>

@interface Status : NSObject
@property (nonatomic, assign) long long     statusId;
@property (nonatomic, strong) NSNumber*		statusKey;
@property (nonatomic, assign) time_t        createdAt;
@property (nonatomic, readonly) NSString*   timestamp;
@property (nonatomic, strong) NSString*     text;
@property (nonatomic, strong) NSString*     source; 
@property (nonatomic, strong) NSString*		sourceUrl;
@property (nonatomic, assign) BOOL          favorited; //是否已收藏(正在开发中，暂不支持)
@property (nonatomic, assign) BOOL          truncated; //是否被截断
@property (nonatomic, assign) double        latitude;
@property (nonatomic, assign) double        longitude;
@property (nonatomic, assign) long long     inReplyToStatusId; //回复ID
@property (nonatomic, assign) int           inReplyToUserId; //回复人UID
@property (nonatomic, strong) NSString*     inReplyToScreenName; //回复人昵称
@property (nonatomic, strong) NSString*		thumbnailPic; //缩略图
@property (nonatomic, strong) NSString*		bmiddlePic; //中型图片
@property (nonatomic, strong) NSString*		originalPic; //原始图片
@property (nonatomic, strong) User*         user; //作者信息
@property (nonatomic, assign) int           commentsCount; //评论数
@property (nonatomic, assign) int           retweetsCount; // 转发数

@property (nonatomic, strong) Status*       retweetedStatus; //转发的博文，内容为status，如果不是转发，则没有此字段

@property (nonatomic, assign) BOOL          unread;
@property (nonatomic, assign) BOOL          hasReply;

@property (nonatomic, assign) BOOL          hasRetwitter;
@property (nonatomic, assign) BOOL          haveRetwitterImage;
@property (nonatomic, assign) BOOL          hasImage;


@end
