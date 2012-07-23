//
//  ViewController.h
//  anjweibo
//
//  Created by anjun on 12-6-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define WEIBO_OAUTH_URL    @"https://api.weibo.com/oauth2/authorize?client_id=132577065&response_type=token&redirect_uri=http://hi.baidu.com/anjsoft&display=mobile"
#import <UIKit/UIKit.h>

@interface OauthViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
