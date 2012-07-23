//
//  ViewController.m
//  anjweibo
//
//  Created by anjun on 12-6-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "WBEngine.h"

#import "ASIHTTPRequest.h"
#import "OauthViewController.h"
extern NSString *uid;
extern NSString *accessToken;
@interface OauthViewController ()

@end

@implementation OauthViewController
@synthesize webView = _webView;


#pragma webviwedelegate
 - (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSURL *url = [request URL];
    NSString *urlstr = [url absoluteString];
    if([urlstr hasPrefix:WEIBO_CALLBACK_URL]){
      NSLog(@"Login callback's url = %@",url);
      NSDictionary *queryDic =  [self parseQueryString:[url fragment]];
        NSLog(@"USER_AUTH_INFO:%@",queryDic);
       if([queryDic objectForKey:@"access_token"]  !=nil){
            [[NSUserDefaults standardUserDefaults] setObject:queryDic forKey:USER_OAUTH_KEY];
           uid = [queryDic objectForKey:@"uid"];//update global uid
           accessToken = [queryDic objectForKey:@"access_token"];
        }
        return NO;
    }
   
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"LoginError:%@",[error localizedDescription]);
   // [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"DISMISS");
    }];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:WEIBO_OAUTH_URL];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
  
}
 -(void)viewDidAppear
{

}
- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
#pragma method
- (NSDictionary *)parseQueryString:(NSString *)query {
    NSLog(@"query:%@",query);
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:pairs.count];
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

@end
