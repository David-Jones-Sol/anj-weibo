//
//  MoreViewController.m
//  anjweibo
//
//  Created by anjun on 12-6-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MoreViewController.h"
#import "WBMessage.h"
#import "UIAlertView+Blocks.h"
extern WBEngine *engine;
extern NSString* uid;
extern NSString *accessToken;

@interface MoreViewController ()

@end

@implementation MoreViewController
@synthesize acountLabel;
- (IBAction)changeAcount:(UIBarButtonItem *)sender {
    
    [UIAlertView showAlertViewWithTitle:nil
                                message:@"真的更换账号吗？" 
                      cancelButtonTitle:@"取消" 
                      otherButtonTitles:[NSArray arrayWithObject:@"确定"]
                              onDismiss:^(int buttonIndex) {
                                  [self shouldAuth];
                              } onCancel:^{
                                  
                              }];
}

-(void)shouldAuth
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
    [self presentViewController:[story instantiateViewControllerWithIdentifier:@"oauthVC"]animated:YES completion:nil]; 
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    engine = [WBEngine sharedInstance];
    [engine getUserInfoWithUserID:[uid longLongValue]] ;
   NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didGetUserInfo:) name:MMSinaGotUserInfo object:nil];
}
-(void)didGetUserInfo:(NSNotification*)sender
{
    NSDictionary *dic = sender.object;
    self.acountLabel.text = [dic objectForKey:@"screen_name"];
}

- (void)viewDidUnload
{
    [self setAcountLabel:nil];
    [super viewDidUnload];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:MMSinaGotUserInfo object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
