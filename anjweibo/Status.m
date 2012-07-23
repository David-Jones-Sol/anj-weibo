//
//  Status.m
//  anjweibo
//
//  Created by anjun on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Status.h"
#import "NSDictionary+Additions.h"
#import "User.h"
#import "RegexKitLite.h"

@implementation Status
@synthesize thumbnail_pic = _thumbnail_pic;

@synthesize statusId = _statusId;
//@synthesize in_reply_to_screen_name = _in_reply_to_screen_name;
@synthesize reposts_count = _reposts_count;
@synthesize comments_count = _comments_count;
@synthesize createdAt = _createdAt;
@synthesize text = _text;
@synthesize source = _source;
@synthesize retweeted_status = _retweeted_status;
//@synthesize sourceUrl = _sourceUrl;
//@synthesize favorited = _favorited;
//@synthesize truncated = _truncated;
//@synthesize longitude = _longitude;
//@synthesize latitude = _latitude;
//@synthesize inReplyToStatusId;
//@synthesize inReplyToUserId = _inReplyToUserId;
//@synthesize inReplyToScreenName = inReplyToScreenName;
//@synthesize thumbnailPic = _thumbnailPic;
//@synthesize bmiddlePic = _bmiddlePic;
//@synthesize originalPic = _originalPic;
@synthesize user = _user;


@synthesize timestamp = _timestamp;
@synthesize geo = _geo;


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
        self.statusId = [value longLongValue];
    
    else [super setValue:value forUndefinedKey:key];
}


-(void) setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"user"])
         self.user = [[User alloc] initWithDictionary:value];
    if([key isEqualToString:@"created_at"])
        self.createdAt = [self humanTime:value];
    if([key isEqualToString:@"source"])
        [self doSource:value];
  
    NSArray  *ar = [self.source captureComponentsMatchedByRegex:@">(.*)<"];
  
    if ([ar count]>0) {
        self.source = [ar objectAtIndex:1];
    }
    
    
    if([key isEqualToString:@"retweeted_status"])
        self.retweeted_status = [[Status alloc] initWithDictionary:value];
    else
        [super setValue:value forKey:key];
}

-(void) doSource:(NSString*)src
{
  }
-(NSString*) humanTime:(NSString*)timeStr
{
   return [self timestamp:[self getTimeT:timeStr defaultValue:0]];
    
}
- (time_t)getTimeT:(NSString *)timmStr defaultValue:(time_t)defaultValue {
	NSString *stringTime   = timmStr;
    if ((id)stringTime == [NSNull null]) {
        stringTime = @"";
    }
	struct tm created;
    time_t now;
    time(&now);
    
	if (stringTime) {
		if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
			strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
		}
        printf("%ld",mktime(&created));
		return mktime(&created);
	}
    return defaultValue;
}


- (NSString*)timestamp:(time_t)cTime
{
	NSString *atimestamp;
    // Calculate distance time string
    //
    time_t now;
    time(&now);
    
    int distance = (int)difftime(now, cTime);
    if (distance < 0) distance = 0;
    
    if (distance < 60) {
        atimestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"秒前" : @"秒前"];
    }
    else if (distance < 60 * 60) {  
        distance = distance / 60;
        atimestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"分钟前" : @"分钟前"];
    }  
    else if (distance < 60 * 60 * 24) {
        distance = distance / 60 / 60;
        atimestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"小时前" : @"小时前"];
    }
    else if (distance < 60 * 60 * 24 * 7) {
        distance = distance / 60 / 60 / 24;
        atimestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"天前" : @"天前"];
    }
    else if (distance < 60 * 60 * 24 * 7 * 4) {
        distance = distance / 60 / 60 / 24 / 7;
        atimestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"周前" : @"周前"];
    }
    else {
        static NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        }
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:cTime];        
        atimestamp = [dateFormatter stringFromDate:date];
    }
    return atimestamp;
}

//=========================================================== 
//  Keyed Archiving
//
//=========================================================== 
- (void)encodeWithCoder:(NSCoder *)encoder 
{
    [encoder encodeInt64:self.statusId  forKey:@"statusId"];
    [encoder encodeObject:self.createdAt forKey:@"createdAt"];
    [encoder encodeObject:self.text forKey:@"text"];
    [encoder encodeObject:self.source forKey:@"source"];
    [encoder encodeInteger:self.reposts_count forKey:@"reposts_count"];
    [encoder encodeInteger:self.comments_count forKey:@"comments_count"];
    [encoder encodeObject:self.thumbnail_pic forKey:@"thumbnail_pic"];
 }

- (id)initWithCoder:(NSCoder *)decoder 
{
    if ((self = [super init])) {
        self.statusId       =  [decoder decodeInt64ForKey:@"statusId"];
        self.createdAt      =  [decoder decodeObjectForKey:@"createdAt"];
        self.text           =  [decoder decodeObjectForKey:@"text"];
        self.source         =  [decoder decodeObjectForKey:@"source"];
        self.reposts_count  =  [decoder decodeIntegerForKey:@"reposts_count"];
        self.comments_count =  [decoder decodeIntegerForKey:@"comments_count"];
        self.thumbnail_pic   =  [decoder decodeObjectForKey:@"thumbnail_pic"];
    }
    return self;
}


@end
