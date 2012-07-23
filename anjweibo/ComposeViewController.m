//
//  ComposeViewController.m
//  anjweibo
//
//  Created by anjun on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ComposeViewController.h"
#import "WBMessage.h"
#import "UIAlertView+Blocks.h"
extern WBEngine *engine;
extern NSString *uid;
extern NSString *accessToken;
@interface ComposeViewController ()

@end

@implementation ComposeViewController
@synthesize textView;
@synthesize imageView;
@synthesize isWithImage = _isWithImage;
- (IBAction)addPhoto:(UIButton *)sender {

    [UIAlertView showAlertViewWithTitle:nil
                                message:@"插入图片" 
                      cancelButtonTitle:@"取消" 
                      otherButtonTitles:[NSArray arrayWithObjects:@"系统相册",@"拍照",nil]
                              onDismiss:^(int buttonIndex) {
        if(buttonIndex == 0)
            [self addPhoto];
        else 
            [self takePhoto];
    } onCancel:^{
        
    }];
}
- (IBAction)post:(UIBarButtonItem *)sender {
    NSString *content = self.textView.text;
    UIImage *image = self.imageView.image;
    if (content != nil && [content length] != 0) {
        if (!self.isWithImage) {
            [engine postWithText:content];
        }
        else {
            [engine postWithText:content image:image];
        }
    }
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didPost:) name:MMSinaGotPostResult object:nil];
       [center addObserver:self selector:@selector(shouldAuth)    name:MMSinaShouldAuth          object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}
#pragma WBEngine delegate mothed
-(void)shouldAuth
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
    [self presentViewController:[story instantiateViewControllerWithIdentifier:@"oauthVC"]animated:YES completion:nil]; 
    
}
- (void)viewDidUnload
{
    [self setTextView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:MMSinaShouldAuth object:nil];
    [center removeObserver:self name:MMSinaGotPostResult object:nil];
}
-(void)didPost:(NSNotificationCenter*)sender
{
   // Status *sts = sender.object;
    //if (sts.text != nil && [sts.text length] != 0) {
        
        [self.navigationController popViewControllerAnimated:YES];
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.imageView.image = image;
    self.isWithImage = YES;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - Tool Methods
- (void)addPhoto
{
    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.navigationBar.tintColor = [UIColor colorWithRed:72.0/255.0 green:106.0/255.0 blue:154.0/255.0 alpha:1.0];
	imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	imagePickerController.delegate = self;
	imagePickerController.allowsEditing = NO;
	[self presentModalViewController:imagePickerController animated:YES];

}

- (void)takePhoto
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
    {
        [UIAlertView showAlertViewWithTitle:nil 
                                    message:@"该设备不支持拍照功能" 
                          cancelButtonTitle:@"取消"  
                          otherButtonTitles:nil
                                  onDismiss:^(int buttonIndex) {
            
                                  } onCancel:^{} 
        ];
    }
    else
    {
        UIImagePickerController * imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = NO;
        [self presentModalViewController:imagePickerController animated:YES];
    
    }
}


@end
