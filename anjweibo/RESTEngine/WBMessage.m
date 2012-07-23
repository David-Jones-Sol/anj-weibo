//
//  WBMessage.m
//  anjweibo
//
//  Created by anjun on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WBMessage.h"

@implementation WBMessage
+ (id)sharedInstance {
    static WBMessage *shared = nil;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shared = [[WBMessage alloc] init];
    });
    
    return shared;
}
#pragma restdelegate 
//获取最新的公共微博
-(void)didGetPublicTimelineWithStatues:(NSArray *)statusArr
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotPublicTimeLine object:statusArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//获取登陆用户的UID
-(void)didGetUserID:(NSString *)userID
{
    NSLog(@"userID = %@",userID);
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotUserID object:userID];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//获取任意一个用户的信息
-(void)didGetUserInfo:(NSDictionary *)userDic
{

    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotUserInfo object:userDic];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//根据微博消息ID返回某条微博消息的评论列表
-(void)didGetCommentList:(NSArray *)commentInfo
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotCommentList object:commentInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//获取用户双向关注的用户ID列表，即互粉UID列表
-(void)didGetBilateralIdList:(NSArray *)arr
{
    NSLog(@"BilateralIdList = %@",arr);
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotBilateralIdList object:arr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//获取用户的双向关注user列表，即互粉列表
-(void)didGetBilateralUserList:(NSArray *)userArr
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotBilateralUserList object:userArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//获取用户的关注列表
-(void)didGetFollowingUsersList:(NSArray *)userArr
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotFollowingUserList object:userArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//获取用户的粉丝列表
-(void)didGetFollowedUsersList:(NSArray *)userArr
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotFollowedUserList object:userArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//获取某话题下的微博消息
-(void)didGetTrendStatues:(NSArray *)statusArr
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotTrendStatues object:statusArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//关注一个用户 by User ID
-(void)didFollowByUserIDWithResult:(NSDictionary *)resultDic
{
    NSLog(@"result = %@",resultDic);
    NSNotification *notification = [NSNotification notificationWithName:MMSinaFollowedByUserIDWithResult object:resultDic];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//取消关注一个用户 by User ID
-(void)didUnfollowByUserIDWithResult:(NSDictionary *)resultDic
{
    NSLog(@"result = %@",resultDic);
    NSNotification *notification = [NSNotification notificationWithName:MMSinaUnfollowedByUserIDWithResult object:resultDic];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//关注某话题
-(void)didGetTrendIDAfterFollowed:(int64_t)topicID
{
    NSLog(@"topicID = %lld",topicID);
    NSNumber *number = [NSNumber numberWithLongLong:topicID];
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotTrendIDAfterFollowed object:number];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//取消对某话题的关注
-(void)didGetTrendResultAfterUnfollowed:(BOOL)isTrue
{
    NSLog(isTrue == YES?@"true":@"false");
    NSNumber *number = [NSNumber numberWithBool:isTrue];
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotTrendResultAfterUnfollowed object:number];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//发布微博
-(void)didGetPostResult:(Status *)sts
{
    NSLog(@"sts.text = %@",sts.text);
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotPostResult object:sts];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//获取当前登录用户及其所关注用户的最新微博
-(void)didGetHomeLine:(NSArray *)statusArr
{

    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotHomeLine object:statusArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//获取某个用户最新发表的微博列表
-(void)didGetUserStatus:(NSArray*)statusArr
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotUserStatus object:statusArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//转发一条微博
-(void)didRepost:(Status *)sts
{
    NSLog(@"sts.text = %@",sts.text);
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotRepost object:sts];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//按天返回热门微博转发榜的微博列表
-(void)didGetHotRepostDaily:(NSArray *)statusArr
{
    
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotHotRepostDaily object:statusArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//按天返回热门微博评论榜的微博列表
-(void)didGetHotCommentDaily:(NSArray *)statusArr
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotHotCommentDaily object:statusArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//获取某个用户的各种消息未读数
-(void)didGetUnreadCount:(NSDictionary *)dic
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotUnreadCount object:dic];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
-(void)shouldAuth
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaShouldAuth object:nil ];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
@end
