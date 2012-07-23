//
//  Global.h
//  anj
//
//  Created by anjun on 12-6-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define kBgQueue                    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) 
#define WEIBO_V2_DOMAIN             @"https://api.weibo.com/2"
#define WEIBO_API_AUTHORIZE         @"https://api.weibo.com/oauth2/authorize"
#define WEIBO_API_ACCESS_TOKEN      @"https://api.weibo.com/oauth2/access_token"

#define WEIBO_APP_KEY               @"132577065"
#define WEIBO_APP_SECRET            @"513132ecc5bbb7968214f0531b238e3b"



#define CACHE_PATH  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject]
#define MMWEIBORequestFailed        @"MMWEIBORequestFailed"

#define WEIBO_FOLLOWERS_URL @"url=https://api.weibo.com/2/friendships/followers.json?cursor=0&count=50&uid=1959366851&access_token=" //粉丝列表
#define WEIBO_FRIENDS_URL @"https://api.weibo.com/2/friendships/friends.json?cursor=0&count=50&uid=1959366851&access_token=" //关注列表
#define WEIBO_  @"https://api.weibo.com/2/remind/unread_count.json?uid=1959366851&access_token="
#define   MY_WEIBO @"statuses/user_timeline"