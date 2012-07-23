
//
//  RESTEngine.h
//  anjweibo
//
//  Created by anjun on 12-6-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "RESTRequest.h"
#import "Status.h"
#import "String+Util.h"

#define USER_OAUTH_KEY           @"oauthInfo" //NSUserdefaults saved key
#define WEIBO_CALLBACK_URL          @"http://hi.baidu.com/anjsoft"

#define BASE_URL @"https://api.weibo.com"
#define WEIBO_API_BASE @"https://api.weibo.com/2"
#define OAUTH_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"/oauth2/authorize?client_id=132577065&response_type=token&redirect_uri=http://hi.baidu.com/anjsoft&display=mobile"]
#define FRIENDS_TIMELINE_URL(accessToken) [NSString stringWithFormat:@"%@%@%@", BASE_URL, @"/2/statuses/friends_timeline.json?access_token=",accessToken]

#define PUBLIC_TIMELINE_URL(accessToken,count,page) [NSString stringWithFormat:@"%@%@%@&count=%@&page=%@", BASE_URL, @"/2/statuses/public_timeline.json?access_token=",accessToken,count,page]


#define LOGIN_URL @"http://localhost/login"
#define kAccessTokenDefaultsKey @"ACCESS_TOKEN"


#define GET_UID_URL(accessToken) [NSString stringWithFormat:@"%@%@%@", BASE_URL, @"/2/account/get_uid.json?access_token=",accessToken]

#define USER_UID [[[NSUserDefaults standardUserDefaults] objectForKey:USER_OAUTH_KEY] objectForKey:@"uid"]

typedef enum {
    SinaGetOauthCode = 0,           //authorize_code
    SinaGetOauthToken,              //access_token
    SinaGetRefreshToken,            //refresh_token
    SinaGetPublicTimeline,          //获取最新的公共微博
    SinaGetUserID,                  //获取登陆用户的UID
    SinaGetUserInfo,                //获取任意一个用户的信息
    SinaGetBilateralIdList,         //获取用户双向关注的用户ID列表，即互粉UID列表
    SinaGetBilateralIdListAll,      
    SinaGetBilateralUserList,       //获取用户的双向关注user列表，即互粉列表
    SinaGetBilateralUserListAll,
    SinaFollowByUserID,             //关注一个用户 by User ID
    SinaFollowByUserName,           //关注一个用户 by User Name
    SinaUnfollowByUserID,           //取消关注一个用户 by User ID
    SinaUnfollowByUserName,         //取消关注一个用户 by User Name
    SinaGetTrendStatues,            //获取某话题下的微博消息
    SinaFollowTrend,                //关注某话题
    SinaUnfollowTrend,              //取消对某话题的关注
    SinaPostText,                   //发布文字微博
    SinaPostTextAndImage,           //发布文字图片微博
    SinaGetHomeLine,                //获取当前登录用户及其所关注用户的最新微博
    SinaGetComment,                 //根据微博消息ID返回某条微博消息的评论列表
    SinaGetUserStatus,              //获取某个用户最新发表的微博列表
    SinaRepost,                     //转发一条微博
    SinaGetFollowingUserList,       //获取用户的关注列表
    SinaGetFollowedUserList,        //获取用户粉丝列表
    SinaGetHotRepostDaily,          //按天返回热门微博转发榜的微博列表
    SinaGetHotCommentDaily,         //按天返回热门微博评论榜的微博列表
    SinaGetUnreadCount,             //获取某个用户的各种消息未读数
}WBRequestType;

@protocol RESTEngineDelegate <NSObject>
@optional
-(void)shouldAuth;
//获取最新的公共微博
-(void)didGetPublicTimelineWithStatues:(NSArray*)statusArr;

//获取登陆用户的UID
-(void)didGetUserID:(NSString*)userID;

//获取任意一个用户的信息
-(void)didGetUserInfo:(NSDictionary*)userdic;

//根据微博消息ID返回某条微博消息的评论列表
-(void)didGetCommentList:(NSArray *)commentInfo;

//获取用户双向关注的用户ID列表，即互粉UID列表
-(void)didGetBilateralIdList:(NSArray*)arr;

//获取用户的双向关注user列表，即互粉列表
-(void)didGetBilateralUserList:(NSArray*)userArr;

//获取用户的关注列表
-(void)didGetFollowingUsersList:(NSArray*)userArr;

//获取用户粉丝列表
-(void)didGetFollowedUsersList:(NSArray*)userArr;

//获取某话题下的微博消息
-(void)didGetTrendStatues:(NSArray*)statusArr;

//关注一个用户 by User ID
-(void)didFollowByUserIDWithResult:(NSDictionary*)resultDic;

//取消关注一个用户 by User ID
-(void)didUnfollowByUserIDWithResult:(NSDictionary*)resultDic;

//关注某话题
-(void)didGetTrendIDAfterFollowed:(int64_t)topicID;

//取消对某话题的关注
-(void)didGetTrendResultAfterUnfollowed:(BOOL)isTrue;

//发布微博
-(void)didGetPostResult:(Status*)sts;

//获取当前登录用户及其所关注用户的最新微博
-(void)didGetHomeLine:(NSArray*)statusArr;

//获取某个用户最新发表的微博列表
-(void)didGetUserStatus:(NSArray*)statusArr;

//转发一条微博
-(void)didRepost:(Status*)sts;

//按天返回热门微博转发榜的微博列表
-(void)didGetHotRepostDaily:(NSArray*)statusArr;

//按天返回热门微博评论榜的微博列表
-(void)didGetHotCommentDaily:(NSArray*)statusArr;

//获取某个用户的各种消息未读数
-(void)didGetUnreadCount:(NSDictionary*)dic;
@end

@interface WBEngine : NSObject

+(WBEngine*) sharedInstance;
@property (nonatomic, unsafe_unretained) id<RESTEngineDelegate> delegate;
@property (nonatomic, strong) ASINetworkQueue *networkQueue;
@property (nonatomic, readonly) NSString *accessToken;
@property (nonatomic, strong) NSMutableDictionary *responseDic;
@property (nonatomic, assign) BOOL requiredAuth;
@property (nonatomic, assign) long long uid;
-(void)initQueue;
//留给webview用
-(NSURL*)getOauthCodeUrl;

//temp
//获取最新的公共微博
-(void)getPublicTimelineWithCount:(int)count withPage:(int)page;

//获取登陆用户的UID
-(void)getUserID;

//获取任意一个用户的信息
-(void)getUserInfoWithUserID:(long long)uid;

//根据微博消息ID返回某条微博消息的评论列表
-(void)getCommentListWithID:(long long)weiboID;

//获取用户双向关注的用户ID列表，即互粉UID列表 
-(void)getBilateralIdListAll:(long long)uid sort:(int)sort;
-(void)getBilateralIdList:(long long)uid count:(int)count page:(int)page sort:(int)sort;

//获取用户的关注列表
-(void)getFollowingUserList:(long long)uid count:(int)count cursor:(int)cursor;

//获取用户粉丝列表
-(void)getFollowedUserList:(long long)uid count:(int)count cursor:(int)cursor;

//获取用户的双向关注user列表，即互粉列表
-(void)getBilateralUserList:(long long)uid count:(int)count page:(int)page sort:(int)sort;
-(void)getBilateralUserListAll:(long long)uid sort:(int)sort;

//关注一个用户 by User ID
-(void)followByUserID:(long long)uid;

//关注一个用户 by User Name
-(void)followByUserName:(NSString*)userName;

//取消关注一个用户 by User ID
-(void)unfollowByUserID:(long long)uid;

//取消关注一个用户 by User Name
-(void)unfollowByUserName:(NSString*)userName;

//获取某话题下的微博消息
-(void)getTrendStatues:(NSString *)trendName;

//关注某话题
-(void)followTrend:(NSString*)trendName;

//取消对某话题的关注
-(void)unfollowTrend:(long long)trendID;

//发布文字微博
-(void)postWithText:(NSString*)text;

//发布文字图片微博
-(void)postWithText:(NSString *)text image:(UIImage*)image;

//获取当前登录用户及其所关注用户的最新微博
-(void)getHomeLine:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count page:(int)page baseApp:(int)baseApp feature:(int)feature;

//获取某个用户最新发表的微博列表
-(void)getUserStatusUserID:(NSString *) uid sinceID:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count page:(int)page baseApp:(int)baseApp feature:(int)feature;

//转发一条微博
//isComment(int):是否在转发的同时发表评论，0：否、1：评论给当前微博、2：评论给原微博、3：都评论，默认为0 。
-(void)repost:(NSString*)weiboID content:(NSString*)content withComment:(int)isComment;

//按天返回热门微博转发榜的微博列表
-(void)getHotRepostDaily:(int)count;

//按天返回热门微博评论榜的微博列表
-(void)getHotCommnetDaily:(int)count;

//获取某个用户的各种消息未读数
-(void)getUnreadCount:(NSString*)uid;
@end
