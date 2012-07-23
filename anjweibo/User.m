//
//  User.m
//  anjweibo
//
//  Created by anjun on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "User.h"
#import "String+Util.h"
#import "NSDictionary+Additions.h"
@implementation User
@synthesize userId = _userId;
@synthesize screen_name = _screen_name;
@synthesize name = _name;
@synthesize province = _province;
@synthesize city = _city;
@synthesize location = _location;
@synthesize desc = _desc;
@synthesize url = _url;
@synthesize profile_image_url = _profile_image_url;

@synthesize domain = _domain;
@synthesize gender = _gender;
@synthesize followers_count = _followers_count;
@synthesize friends_count = _friends_count;
@synthesize statuses_count = _statuses_count;
@synthesize favorites_count = _favorites_count;
@synthesize createdAt = _createdAt;
@synthesize following = _following;
@synthesize verified = _verified;
@synthesize allowAllActMsg = _allowAllActMsg;
@synthesize geoEnabled = _geoEnabled;
@synthesize userKey = _userKey;
@synthesize avatar_large = _avatar_large;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
        self.userId = [value longLongValue];
    if([key isEqualToString:@"description"])
        self.desc = value;
    if([key isEqualToString:@"true"])
    self.following = YES;
    else [super setValue:value forUndefinedKey:key];
}

@end
