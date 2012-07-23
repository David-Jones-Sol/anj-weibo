//
//  User.h
//  anjweibo
//
//  Created by anjun on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

typedef enum {
    GenderUnknow = 0,
    GenderMale,
    GenderFemale,
} Gender;
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "JSONModel.h"
@interface User : JSONModel
@property (nonatomic, assign) long long  userId;
@property (nonatomic, strong) NSNumber*		userKey;
@property (nonatomic, strong) NSString* screen_name;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* province;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* location;
@property (nonatomic, strong) NSString* desc;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSString* profile_image_url;
@property (nonatomic, strong) NSString* domain;
@property (nonatomic, assign) Gender gender;
@property (nonatomic, assign) int  followers_count;
@property (nonatomic, assign) int  friends_count;
@property (nonatomic, assign) int  statuses_count;
@property (nonatomic, assign) int  favorites_count;
@property (nonatomic, assign) time_t	createdAt;
@property (nonatomic, assign) BOOL      following;//YES，我已关注
@property (nonatomic, assign) BOOL		verified;
@property (nonatomic, assign) BOOL		allowAllActMsg;
@property (nonatomic, assign) BOOL		geoEnabled;
@property (nonatomic, retain) NSString*    avatar_large;

@end
