//
//  Status.m
//  anjweibo
//
//  Created by anjun on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Status.h"

@implementation Status
@synthesize statusId = _statusId;
@synthesize createdAt = _createdAt;
@synthesize text = _text;
@synthesize source = _source;
@synthesize sourceUrl = _sourceUrl;
@synthesize favorited = _favorited;
@synthesize truncated = _truncated;
@synthesize longitude = _longitude;
@synthesize latitude = _latitude;
@synthesize inReplyToStatusId;
@synthesize inReplyToUserId = _inReplyToUserId;
@synthesize inReplyToScreenName = inReplyToScreenName;
@synthesize thumbnailPic = _thumbnailPic;
@synthesize bmiddlePic = _bmiddlePic;
@synthesize originalPic = _originalPic;
@synthesize user = _user;
@synthesize commentsCount = _commentsCount;
@synthesize retweetsCount = _retweetsCount;
@synthesize retweetedStatus = retweetedStatus;
@synthesize unread = _unread;
@synthesize hasReply = _hasReply;
@synthesize statusKey = _statusKey;
@synthesize hasRetwitter = _hasRetwitter;
@synthesize haveRetwitterImage = _haveRetwitterImage;
@synthesize hasImage = _hasImage;
@synthesize timestamp = _timestamp;
@end
