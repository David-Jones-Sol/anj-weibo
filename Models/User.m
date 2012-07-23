//
//  User.m
//  anjweibo
//
//  Created by anjun on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@implementation User
@synthesize userId = _userId;
@synthesize screenName = _screenName;
@synthesize name = _name;
@synthesize province = _province;
@synthesize city = _city;
@synthesize location = _location;
@synthesize description = _description;
@synthesize url = _url;
@synthesize profileImageUrl = _profileImageUrl;
@synthesize profileLargeImageUrl = _profileLargeImageUrl;
@synthesize domain = _domain;
@synthesize gender = _gender;
@synthesize followersCount = _followersCount;
@synthesize friendsCount = _friendsCount;
@synthesize statusesCount = _statusesCount;
@synthesize favoritesCount = _favoritesCount;
@synthesize createdAt = _createdAt;
@synthesize following = _following;
@synthesize verified = _verified;
@synthesize allowAllActMsg = _allowAllActMsg;
@synthesize geoEnabled = _geoEnabled;
@synthesize userKey = _userKey;
@synthesize avatarImage = _avatarImage;
- (id)initWithDictionary:(NSDictionary *)aDictionary
{
   	if ([self init]) {
		self.userId = [aDictionary valueForKey:@"userId"];
    }
    return self;
}
@end
