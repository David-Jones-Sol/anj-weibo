//
//  RESTEngine.m
//  anjWeibo
//
//  Created by anjun on 12-6-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WBEngine.h"
#import "Status.h"
#import "JSONKit.h"
#import "JSONModel.h"
extern NSString *accessToken;
extern NSString *uid;
@implementation WBEngine
@synthesize delegate = _delegate;
@synthesize networkQueue = _networkQueue;
@synthesize requiredAuth = _requiredAuth;
@synthesize accessToken = _accessToken;
@synthesize uid = _uid;
+ (id)sharedInstance {
    static WBEngine *shared = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shared = [[WBEngine alloc] init];
    });
    return shared;
}
-(void)initQueue
{
    self.uid = (long long) [[[NSUserDefaults standardUserDefaults] objectForKey:USER_OAUTH_KEY] objectForKey:@"uid"];
    self.networkQueue = [ASINetworkQueue queue];
    [self.networkQueue setMaxConcurrentOperationCount:16];
    [self.networkQueue setDelegate:self];
    [self.networkQueue go];

}
-(NSString*) accessToken
{
    if(!_accessToken)
    {
        _accessToken = [[[NSUserDefaults standardUserDefaults] objectForKey:USER_OAUTH_KEY] objectForKey:@"access_token"];
    }
    
    return _accessToken;
}

-(void)requestWith:(NSURL*)url tag:(NSUInteger)aTag{
    if(_networkQueue == nil) [self initQueue];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.tag = aTag;
    [self.networkQueue addOperation:request];
    NSLog(@"request url:%@",[url absoluteString]);
}
-(void)requestFinished:(RESTRequest*) request 
{
    NSMutableDictionary *dic ;
    switch ( request.tag) {
        case SinaGetPublicTimeline:
            dic = [[request responseString] objectFromJSONString];
            [self.delegate didGetPublicTimelineWithStatues:[dic objectForKey:@"statuses"]];
            break;
        case SinaGetUserID:
            if ([self.delegate respondsToSelector:@selector(didGetUserID:)]) {
                [self.delegate didGetUserID:USER_UID];
            }
            break;
        case SinaGetUserInfo:
             dic = [[request responseString] objectFromJSONString];
            if ([self.delegate respondsToSelector:@selector(didGetUserInfo:)]) {
                [self initError:dic];
                [self.delegate didGetUserInfo:dic];
            }
            break;
        case     SinaGetBilateralIdList:
        case     SinaGetBilateralIdListAll:
            if ([self.delegate respondsToSelector:@selector(didGetBilateralIdList:)]) {
             //   [delegate didGetBilateralIdList:arr];
            }
            break;    
        case     SinaGetBilateralUserList:
        case     SinaGetBilateralUserListAll:
            if ([self.delegate respondsToSelector:@selector(didGetBilateralUserList:)]) {
               // [delegate didGetBilateralUserList:userArr];
            }
            break;
        case     SinaFollowByUserID:
        case     SinaFollowByUserName:
             dic = [[request responseString] objectFromJSONString];
            [self initError:dic];
            if ([self.delegate respondsToSelector:@selector(didFollowByUserIDWithResult:)]) {
                
                [self.delegate didFollowByUserIDWithResult:dic];
            }
            break;         
        case     SinaUnfollowByUserID:

        case     SinaUnfollowByUserName:
             dic = [[request responseString] objectFromJSONString];
            [self initError:dic];
            if ([self.delegate respondsToSelector:@selector(didUnfollowByUserIDWithResult:)]) {
                
                [self.delegate didUnfollowByUserIDWithResult:dic];
            }
            break;       
        case     SinaGetTrendStatues:
            if ([self.delegate respondsToSelector:@selector(didGetTrendStatues:)]) {
              //  [delegate didGetTrendStatues:statuesArr];
            }
            break;          
        case     SinaFollowTrend:
            if ([self.delegate respondsToSelector:@selector(didGetTrendIDAfterFollowed:)]) {
               // [delegate didGetTrendIDAfterFollowed:topicID];
            }
            break;              
        case     SinaUnfollowTrend:
            if ([self.delegate respondsToSelector:@selector(didGetTrendResultAfterUnfollowed:)]) {
               // [delegate didGetTrendResultAfterUnfollowed:isTrue];
            }
            break;            
        case     SinaPostText:
        case     SinaPostTextAndImage:
            if ([self.delegate respondsToSelector:@selector(didGetPostResult:)]) {
                [self.delegate didGetPostResult:nil];
            }
            break;         
        case     SinaGetHomeLine:
             dic = [[request responseString] objectFromJSONString];
            if ([self.delegate respondsToSelector:@selector(didGetHomeLine:)]) {
                [self initError:dic];
                NSArray *statusArr = [dic objectForKey:@"statuses"];
                [self.delegate didGetHomeLine:statusArr];
            }
            break;              
        case     SinaGetComment:
            dic = [[request responseString] objectFromJSONString];
            if ([self.delegate respondsToSelector:@selector(didGetCommentList:)]) {
                [self initError:dic];
                NSArray *arr = [dic objectForKey:@"comments"];
                [self.delegate didGetCommentList:arr];
            }
            break;               
        case     SinaGetUserStatus:
             dic = [[request responseString] objectFromJSONString];
            if ([self.delegate respondsToSelector:@selector(didGetUserStatus:)]) {
                [self initError:dic];
                NSArray *statusArr = [dic objectForKey:@"statuses"];
                [self.delegate didGetUserStatus:statusArr];
            }
            break;            
        case     SinaRepost:
            if ([self.delegate respondsToSelector:@selector(didRepost:)]) {
              //  [delegate didRepost:sts];
            }
            break;                   
        case     SinaGetFollowingUserList:
             dic = [[request responseString] objectFromJSONString];
            if ([self.delegate respondsToSelector:@selector(didGetFollowingUsersList:)]) {
                [self initError:dic];
                NSArray *userArr = [dic objectForKey:@"users"];
                [self.delegate didGetFollowingUsersList:userArr];
            }
            break;     
        case     SinaGetFollowedUserList:
             dic = [[request responseString] objectFromJSONString];
            if ([self.delegate respondsToSelector:@selector(didGetFollowedUsersList:)]) {
                [self initError:dic];
                NSArray *userArr = [dic objectForKey:@"users"];
                [self.delegate didGetFollowedUsersList:userArr];
            }
            break;      
        case     SinaGetHotRepostDaily:
            if ([self.delegate respondsToSelector:@selector(didGetHotRepostDaily:)]) {
                NSArray *arr = [[request responseString] objectFromJSONString];
                [self.delegate didGetHotRepostDaily:arr];
            }
            break;        
        case     SinaGetHotCommentDaily:
            if ([self.delegate respondsToSelector:@selector(didGetHotCommentDaily:)]) {
               
               NSArray *arr = [[request responseString] objectFromJSONString];
                [self.delegate didGetHotCommentDaily:arr];
            }
            break;       
       case SinaGetUnreadCount:
            if ([self.delegate respondsToSelector:@selector(didGetUnreadCount:)]) {
//                [delegate didGetUnreadCount:userInfo];
            }
            break; 
    }

}
-(void)requestFailed:(RESTRequest*) request
{
    NSLog(@"request error:%@",[request error]);
}

- (RESTRequest*) prepareRequestForURLString:(NSString*) urlString
{
    RESTRequest *request = [RESTRequest requestWithURL:[NSURL URLWithString:urlString]];  
    return request;
}


#pragma mark -
#pragma mark Custom Methods

// Add your custom methods here



- (NSURL*)generateURL:(NSString*)baseURL params:(NSDictionary*)params {
	if (params) {
		NSMutableArray* pairs = [NSMutableArray array];
		for (NSString* key in params.keyEnumerator) {
			NSString* value = [params objectForKey:key];
            
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
	
		}
		
		NSString* query = [pairs componentsJoinedByString:@"&"];
		NSString* url = [NSString stringWithFormat:@"%@?%@", baseURL, query];
		return [NSURL URLWithString:url];
	} else {
		return [NSURL URLWithString:baseURL];
	}
}

#pragma weibo request 
-(void)getPublicTimelineWithCount:(int)count withPage:(int)page{
    
    NSString                *countString = [NSString stringWithFormat:@"%d",count];
    NSString                *pageString = [NSString stringWithFormat:@"%d",page];
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.accessToken,   @"access_token",
                                       countString, @"count",
                                       pageString,  @"page",
                                       nil];
    
    NSString                *baseUrl =[NSString  stringWithFormat:@"%@/statuses/public_timeline.json",WEIBO_API_BASE];
    
    //NSString                   *urlStr = PUBLIC_TIMELINE_URL(self.accessToken,countString,pageString);
    NSURL *url = [self generateURL:baseUrl params:params];
    
    [self requestWith:url tag:SinaGetPublicTimeline];

}
//获取登陆用户的UID
-(void)getUserID
{
    //https://api.weibo.com/2/account/get_uid.json
   
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.accessToken,   @"access_token",
                                       nil];
    NSString                *baseUrl = [NSString  stringWithFormat:@"%@/account/get_uid.json",WEIBO_API_BASE];
    NSURL                   *url = [self generateURL:baseUrl params:params];
    
   [self requestWith:url tag:SinaGetUserID];
}

//获取任意一个用户的信息
-(void)getUserInfoWithUserID:(long long)uid
{
    //https://api.weibo.com/2/users/show.json
 
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.accessToken,                                   @"access_token",
                                       [NSString stringWithFormat:@"%lld",uid],     @"uid",
                                       nil];
    NSString                *baseUrl =[NSString  stringWithFormat:@"%@/users/show.json",WEIBO_API_BASE];
    NSURL                   *url = [self generateURL:baseUrl params:params];
    
    [self requestWith:url tag:SinaGetUserInfo];

}

-(void)getCommentListWithID:(long long)weiboID
{
    //https://api.weibo.com/2/comments/show.json
   
    
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.accessToken,                                       @"access_token",
                                       [NSString stringWithFormat:@"%lld",weiboID],     @"id",
                                       nil];
    NSString                *baseUrl =[NSString  stringWithFormat:@"%@/comments/show.json",WEIBO_API_BASE];
    NSURL                   *url = [self generateURL:baseUrl params:params];
    
   
    
   [self requestWith:url tag:SinaGetComment];
    
    
}

//获取用户双向关注的用户ID列表，即互粉UID列表
-(void)getBilateralIdList:(long long)uid count:(int)count page:(int)page sort:(int)sort
{
    //https://api.weibo.com/2/friendships/friends/bilateral/ids.json
    

    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.accessToken,                                   @"access_token",
                                       [NSString stringWithFormat:@"%lld",uid],     @"uid",
                                       [NSString stringWithFormat:@"%d",count],     @"count",
                                       [NSString stringWithFormat:@"%d",page],      @"page",
                                       [NSString stringWithFormat:@"%d",sort],      @"sort",
                                       nil];
    NSString                *baseUrl =[NSString  stringWithFormat:@"%@/friendships/friends/bilateral/ids.json",WEIBO_API_BASE];
    NSURL                   *url = [self generateURL:baseUrl params:params];
    
   
    
[self requestWith:url tag:SinaGetBilateralIdList];
    
    
}

//获取用户双向关注的用户ID列表，即互粉UID列表 不分页
-(void)getBilateralIdListAll:(long long)uid sort:(int)sort
{
    //https://api.weibo.com/2/friendships/friends/bilateral/ids.json
    
    
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.accessToken,                                   @"access_token",
                                       [NSString stringWithFormat:@"%lld",uid],     @"uid",
                                       [NSString stringWithFormat:@"%d",sort],      @"sort",
                                       nil];
    NSString                *baseUrl =[NSString  stringWithFormat:@"%@/friendships/friends/bilateral/ids.json",WEIBO_API_BASE];
    NSURL                   *url = [self generateURL:baseUrl params:params];
    
   
    
 [self requestWith:url tag:SinaGetBilateralIdListAll];
    
    
}

//获取用户的双向关注user列表，即互粉列表
-(void)getBilateralUserList:(long long)uid count:(int)count page:(int)page sort:(int)sort
{
    //https://api.weibo.com/2/friendships/friends/bilateral.json
    
   
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.accessToken,                                   @"access_token",
                                       [NSString stringWithFormat:@"%lld",uid],     @"uid",
                                       [NSString stringWithFormat:@"%d",count],     @"count",
                                       [NSString stringWithFormat:@"%d",page],      @"page",
                                       [NSString stringWithFormat:@"%d",sort],      @"sort",
                                       nil];
    NSString                *baseUrl =[NSString  stringWithFormat:@"%@/friendships/friends/bilateral.json",WEIBO_API_BASE];
    NSURL                   *url = [self generateURL:baseUrl params:params];
    
   
    
    [self requestWith:url tag:SinaGetBilateralUserList];
    
    
}

//获取用户双向关注的用户user列表，即互粉user列表 不分页
-(void)getBilateralUserListAll:(long long)uid sort:(int)sort
{
    //https://api.weibo.com/2/friendships/friends/bilateral/ids.json
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.accessToken,                                   @"access_token",
                                       [NSString stringWithFormat:@"%lld",uid],     @"uid",
                                       [NSString stringWithFormat:@"%d",sort],      @"sort",
                                       nil];
    NSString                *baseUrl =[NSString  stringWithFormat:@"%@/friendships/friends/bilateral.json",WEIBO_API_BASE];
    NSURL                   *url = [self generateURL:baseUrl params:params];
    
    [self requestWith:url tag:SinaGetBilateralUserListAll];
}

//获取用户的关注列表
-(void)getFollowingUserList:(long long)uid count:(int)count cursor:(int)cursor
{
    //https://api.weibo.com/2/friendships/friends.json
    
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.accessToken,                                   @"access_token",
                                       [NSString stringWithFormat:@"%lld",uid],     @"uid",
                                       [NSString stringWithFormat:@"%d",count],     @"count",
                                       [NSString stringWithFormat:@"%d",cursor],      @"cursor",
                                       nil];
    NSString                *baseUrl =[NSString  stringWithFormat:@"%@/friendships/friends.json",WEIBO_API_BASE];
    NSURL                   *url = [self generateURL:baseUrl params:params];
    
    [self requestWith:url tag:SinaGetFollowingUserList];
    
    
}

//获取用户粉丝列表
-(void)getFollowedUserList:(long long)uid count:(int)count cursor:(int)cursor
{
    //https://api.weibo.com/2/friendships/followers.json
   
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.accessToken,                                   @"access_token",
                                       [NSString stringWithFormat:@"%lld",uid],     @"uid",
                                       [NSString stringWithFormat:@"%d",count],     @"count",
                                       [NSString stringWithFormat:@"%d",cursor],    @"cursor",
                                       nil];
    NSString                *baseUrl =[NSString  stringWithFormat:@"%@/friendships/followers.json",WEIBO_API_BASE];
    NSURL                   *url = [self generateURL:baseUrl params:params];
    
   
    
    [self requestWith:url tag:SinaGetFollowedUserList];
    
    
}

//关注一个用户 by User ID
-(void)followByUserID:(long long)uid
{
    //https://api.weibo.com/2/friendships/create.json
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/2/friendships/create.json"];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
   
    
    [item setPostValue:accessToken           forKey:@"access_token"];
    [item setPostValue:[NSString stringWithFormat:@"%lld",uid]  forKey:@"uid"];
    
    [item setTag:SinaFollowByUserID];
   /* NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:SinaFollowByUserID] forKey:USER_INFO_KEY_TYPE];
    [dict setObject:[NSString stringWithFormat:@"%lld",uid] forKey:@"uid"];
    [item setUserInfo:dict];*/

    
    [self.networkQueue addOperation:item];
   
}



//取消关注一个用户 by User ID
-(void)unfollowByUserID:(long long)uid
{
    //https://api.weibo.com/2/friendships/destroy.json
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/2/friendships/destroy.json"];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
   
    
    [item setPostValue:accessToken              forKey:@"access_token"];
    [item setPostValue:[NSString stringWithFormat:@"%lld",uid]  forKey:@"uid"];
    
    [item setTag:SinaUnfollowByUserID];
   /* NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:SinaUnfollowByUserID] forKey:USER_INFO_KEY_TYPE];
    [dict setObject:[NSString stringWithFormat:@"%lld",uid] forKey:@"uid"];
    [item setUserInfo:dict];*/
   
    
    [self.networkQueue addOperation:item];
  
}



//获取某话题下的微博消息
-(void)getTrendStatues:(NSString *)trendName
{   
    //http://api.t.sina.com.cn/trends/statuses.json
   
    //NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
      //                                 SINA_APP_KEY,@"source",
//                                       [trendName encodeAsURIComponent],@"trend_name",
//                                       nil];
    NSString                *baseUrl = @"http://api.t.sina.com.cn/trends/statuses.json";
//    NSURL                   *url = [self generateURL:baseUrl params:params];
   
    
//   [self requestWith:url tag:SinaGetTrendStatues];
    
    
}

//关注某话题
-(void)followTrend:(NSString*)trendName
{
    //https://api.weibo.com/2/trends/follow.json
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/2/trends/follow.json"];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
//    self.self.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    
//    [item setPostValue:authToken    forKey:@"access_token"];
    [item setPostValue:trendName    forKey:@"trend_name"];
    
   [self requestWith:url tag:SinaFollowTrend];
    [self.networkQueue addOperation:item];
    
}

//取消对某话题的关注
-(void)unfollowTrend:(long long)trendID
{
    //https://api.weibo.com/2/trends/destroy.json 
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/2/trends/destroy.json"];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
  
    
    [item setPostValue:accessToken                                    forKey:@"access_token"];
    [item setPostValue:[NSString stringWithFormat:@"%lld",trendID]   forKey:@"trend_id"];
    NSLog(@"trendID = %lld",trendID);
   [self requestWith:url tag:SinaUnfollowTrend];
    [self.networkQueue addOperation:item];
  
}


//发布文字微博
-(void)postWithText:(NSString*)text
{
    //https://api.weibo.com/2/statuses/update.json
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/2/statuses/update.json"];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];

    
    [item setPostValue:accessToken    forKey:@"access_token"];
    [item setPostValue:text         forKey:@"status"];
    
    [self requestWith:url tag:SinaPostText];
    [self.networkQueue addOperation:item];
   
}

//发布文字图片微博
-(void)postWithText:(NSString *)text image:(UIImage*)image
{
    //https://api.weibo.com/2/statuses/upload.json
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/2/statuses/upload.json"];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
   
    
    [item setPostValue:accessToken    forKey:@"access_token"];
    [item setPostValue:text         forKey:@"status"];
    [item addData:UIImagePNGRepresentation(image) forKey:@"pic"];
    
    [self requestWith:url tag:SinaPostTextAndImage];
    [self.networkQueue addOperation:item];
   
}

//获取当前登录用户及其所关注用户的最新微博
-(void)getHomeLine:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count page:(int)page baseApp:(int)baseApp feature:(int)feature
{
    //https://api.weibo.com/2/statuses/home_timeline.json
    
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:accessToken,@"access_token",nil];
    if (sinceID >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%lld",sinceID];
        [params setObject:tempString forKey:@"since_id"];
    }
    if (maxID >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%lld",maxID];
        [params setObject:tempString forKey:@"max_id"];
    }
    if (count >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%d",count];
        [params setObject:tempString forKey:@"count"];
    }
    if (page >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%d",page];
        [params setObject:tempString forKey:@"page"];
    }
    if (baseApp >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%d",baseApp];
        [params setObject:tempString forKey:@"baseApp"];
    }
    if (feature >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%d",feature];
        [params setObject:tempString forKey:@"feature"];
    }
    
    NSString                *baseUrl =[NSString  stringWithFormat:@"%@/statuses/home_timeline.json",WEIBO_API_BASE];
    NSURL                   *url = [self generateURL:baseUrl params:params];
    
   
    
    [self requestWith:url tag:SinaGetHomeLine];
    
    
}

//获取某个用户最新发表的微博列表
-(void)getUserStatusUserID:(NSString *) uid sinceID:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count page:(int)page baseApp:(int)baseApp feature:(int)feature
{
    //https://api.weibo.com/2/statuses/user_timeline.json
    
   
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.accessToken,@"access_token",nil];
    [params setObject:uid forKey:@"uid"];
    NSLog(@"uid = %@",uid);
    if (sinceID >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%lld",sinceID];
        [params setObject:tempString forKey:@"since_id"];
    }
    if (maxID >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%lld",maxID];
        [params setObject:tempString forKey:@"max_id"];
    }
    if (count >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%d",count];
        [params setObject:tempString forKey:@"count"];
    }
    if (page >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%d",page];
        [params setObject:tempString forKey:@"page"];
    }
    if (baseApp >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%d",baseApp];
        [params setObject:tempString forKey:@"baseApp"];
    }
    if (feature >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%d",feature];
        [params setObject:tempString forKey:@"feature"];
    }
    
    NSString                *baseUrl =[NSString  stringWithFormat:@"%@/statuses/user_timeline.json",WEIBO_API_BASE];
    NSURL                   *url = [self generateURL:baseUrl params:params];
    
   
    
   [self requestWith:url tag:SinaGetUserStatus];
    
    
}

//转发一条微博
-(void)repost:(NSString*)weiboID content:(NSString*)content withComment:(int)isComment
{
    //https://api.weibo.com/2/statuses/repost.json
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/2/statuses/repost.json"];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
   
    NSString *sts =[NSString stringWithFormat:@"%d",isComment];
    
    [item setPostValue:self.accessToken    forKey:@"access_token"];
    [item setPostValue:content      forKey:@"status"];
    [item setPostValue:weiboID      forKey:@"id"];
    [item setPostValue:sts          forKey:@"is_comment"];
    
    [self requestWith:url tag:SinaRepost];
    [self.networkQueue addOperation:item];
  
}

//按天返回热门微博转发榜的微博列表
-(void)getHotRepostDaily:(int)count
{
    //https://api.weibo.com/2/statuses/hot/repost_daily.json
   
    NSString                *countString = [NSString stringWithFormat:@"%d",count];
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.accessToken,   @"access_token",
                                       countString, @"count",
                                       nil];
    NSString                *baseUrl =[NSString  stringWithFormat:@"%@/statuses/hot/repost_daily.json",WEIBO_API_BASE];
    NSURL                   *url = [self generateURL:baseUrl params:params];
    
   
    
    [self requestWith:url tag:SinaGetHotRepostDaily];
    
    
}

//按天返回热门微博评论榜的微博列表
-(void)getHotCommnetDaily:(int)count
{
    //https://api.weibo.com/2/statuses/hot/comments_daily.json
   
    NSString                *countString = [NSString stringWithFormat:@"%d",count];
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.accessToken,   @"access_token",
                                       countString, @"count",
                                       nil];
    NSString                *baseUrl =[NSString  stringWithFormat:@"%@/statuses/hot/comments_daily.json",WEIBO_API_BASE];
    NSURL                   *url = [self generateURL:baseUrl params:params];
    
   
    
 [self requestWith:url tag:SinaGetHotCommentDaily];
    
    
}

//获取某个用户的各种消息未读数
-(void)getUnreadCount:(NSString*)uid
{
    //http://rm.api.weibo.com/2/remind/unread_count.json
   
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.accessToken,   @"access_token",
                                       uid,         @"uid",
                                       nil];
    NSString                *baseUrl =[NSString  stringWithFormat:@"%@/remind/unread_count.json",WEIBO_API_BASE];
    NSURL                   *url = [self generateURL:baseUrl params:params];
    
   
    
    [self requestWith:url tag:SinaGetUnreadCount];
    
}

-(void)initError:(NSMutableDictionary*)dic
{
    NSString *errorString = [dic objectForKey:@"error"];
    if (errorString !=nil) {
        [self.delegate shouldAuth];
    }
}
@end
