//
//  ComposeViewController.h
//  anjweibo
//
//  Created by anjun on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposeViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (assign ,nonatomic) BOOL isWithImage;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
