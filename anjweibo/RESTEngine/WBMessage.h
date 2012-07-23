//
//  WBMessage.h
//  anjweibo
//
//  Created by anjun on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBEngine.h"

#define IMAGE_VIEW_HEIGHT 80.0f


#define MMSinaShouldAuth @"MMSinaShouldAuth"
//获取最新的公共微博
//返回成员为Status的NSArray
#define MMSinaGotPublicTimeLine @"MMSinaGotPublicTimeLine"

//获取登陆用户的UID
//返回userID(NSString)
#define MMSinaGotUserID @"MMSinaGotUserID"

//获取任意一个用户的信息
//返回一个User对象
#define MMSinaGotUserInfo @"MMSinaGotUserInfo"

//根据微博消息ID返回某条微博消息的评论列表
//返回成员为comment的NSArray.
#define MMSinaGotCommentList @"MMSinaGotCommentList"

//获取用户双向关注的用户ID列表，即互粉UID列表
//返回成员为UID(NSNumber)的NSArray。
#define MMSinaGotBilateralIdList @"MMSinaGotBilateralIdList"

//获取用户的双向关注user列表，即互粉列表
//返回成员为User的NSArray。
#define MMSinaGotBilateralUserList @"MMSinaGotBilateralUserList"

//获取用户的关注列表
//返回成员为User的NSArray。
#define MMSinaGotFollowingUserList @"MMSinaGotFollowingUserList"

//获取用户的粉丝列表
//返回成员为User的NSArray。
#define MMSinaGotFollowedUserList @"MMSinaGotFollowedUserList"

//获取某话题下的微博消息
//返回成员为Status的NSArray
#define MMSinaGotTrendStatues @"MMSinaGotTrendStatues"

//关注一个用户 by User ID
//返回一个Dic
//result:(NSNumber)值，int == 0 成功，int == 1，失败
//uid (NSString)
#define MMSinaFollowedByUserIDWithResult @"MMSinaFollowedByUserIDWithResult"

//取消关注一个用户 by User ID
//返回一个Dic
//result:(NSNumber)值，int == 0 成功，int == 1，失败
//uid (NSString)
#define MMSinaUnfollowedByUserIDWithResult @"UnfollowedByUserIDWithResult"

//关注某话题
//返回long long(NSNumber)类型的 topic ID
#define MMSinaGotTrendIDAfterFollowed @"MMSinaGotTrendIDAfterFollowed"

//取消对某话题的关注
//返回一个BOOL(NSNumber)值
#define MMSinaGotTrendResultAfterUnfollowed @"MMSinaGotTrendResultAfterUnfollowed"

//发布微博
//返回一个Status对象
#define MMSinaGotPostResult @"MMSinaGotPostResult"

//获取当前登录用户及其所关注用户的最新微博
//返回成员为Status的NSArray
#define MMSinaGotHomeLine @"MMSinaGotHomeLine"

//获取某个用户最新发表的微博列表
//返回成员为Status的NSArray
#define MMSinaGotUserStatus @"MMSinaGotUserStatus"

//转发一条微博
//返回一个Status对象
#define MMSinaGotRepost @"MMSinaGotRepost"

//按天返回热门微博转发榜的微博列表
//返回成员为Status的NSArray
#define MMSinaGotHotRepostDaily @"MMSinaGotHotRepostDaily"

//按天返回热门微博评论榜的微博列表
//返回成员为Status的NSArray
#define MMSinaGotHotCommentDaily @"MMSinaGotHotCommentDaily"

//获取某个用户的各种消息未读数
#define MMSinaGotUnreadCount @"MMSinaGotUnreadCount"
@interface WBMessage : NSObject<RESTEngineDelegate>
+(id) sharedInstance;
@end
