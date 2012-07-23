//
//  Comment.m
//  anjweibo
//
//  Created by anjun on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Comment.h"

@implementation Comment
@synthesize commentId = _commentId;
@synthesize commentKey = _commentKey;
@synthesize text = _text;
@synthesize createdAt = _createdAt;
@synthesize source = _source;
@synthesize sourceUrl = _sourceUrl;
@synthesize favorited = _favorited;
@synthesize truncated = _truncated;
@synthesize user = _user;
@synthesize status = _status;
@synthesize replyComment = _replyComment;
@synthesize timestamp = _timestamp;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
        self.commentId = [value longLongValue];
    
    else [super setValue:value forUndefinedKey:key];
}
-(void) setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"user"])
        self.user = [[User alloc] initWithDictionary:value];
    if([key isEqualToString:@"created_at"])
        self.createdAt = [self humanTime:value];
   
    
    else
        [super setValue:value forKey:key];
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

@end
