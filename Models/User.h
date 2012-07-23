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

@interface User : NSObject
@property (nonatomic, assign) long long  userId;
@property (nonatomic, strong) NSNumber*		userKey;
@property (nonatomic, strong) NSString* screenName;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* province;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* location;
@property (nonatomic, strong) NSString* description;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSString* profileImageUrl;
@property (nonatomic, strong) NSString* profileLargeImageUrl;
@property (nonatomic, strong) NSString* domain;
@property (nonatomic, assign) Gender gender;
@property (nonatomic, assign) int  followersCount;
@property (nonatomic, assign) int  friendsCount;
@property (nonatomic, assign) int  statusesCount;
@property (nonatomic, assign) int  favoritesCount;
@property (nonatomic, assign) time_t	createdAt;
@property (nonatomic, assign) BOOL      following;
@property (nonatomic, assign) BOOL		verified;
@property (nonatomic, assign) BOOL		allowAllActMsg;
@property (nonatomic, assign) BOOL		geoEnabled;
@property (nonatomic, retain) UIImage*    avatarImage;
- (id)initWithDictionary:(NSDictionary *)aDictionary;
@end
