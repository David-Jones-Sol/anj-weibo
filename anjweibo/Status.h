//
//  Status.h
//  anjweibo
//
//  Created by anjun on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "User.h"
#import "JSONModel.h"

#import <Foundation/Foundation.h>

@interface Status : JSONModel
@property(nonatomic,assign) long long statusId;
@property(nonatomic,strong) NSString *text;
@property(nonatomic,strong) NSString *source;
@property(nonatomic,strong) NSString *geo;
@property(nonatomic,strong) NSString *createdAt;
@property(nonatomic,assign) int reposts_count;//转发数
@property(nonatomic,assign) int comments_count;//评论数
@property(nonatomic,strong) NSString *thumbnail_pic;
@property(nonatomic,strong) User    *user;
@property(nonatomic, readonly) NSString*   timestamp;
@property(nonatomic,strong) Status *retweeted_status;
/*
@property (nonatomic, assign) long long     statusId;
@property (nonatomic, strong) NSString*     in_reply_to_screen_name;
@property (nonatomic, strong) NSNumber*     reposts_count;
@property (nonatomic, strong) NSNumber*     comments_count;

@property (nonatomic, strong) NSString*     createdAt;

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
@property(nonatomic,strong) NSDictionary*    geo;

*/
- (NSString*)timestamp;
@end
