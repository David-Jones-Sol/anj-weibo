//
//  Draft.h
//  anjweibo
//
//  Created by anjun on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	DraftTypeNewTweet,
	DraftTypeReTweet,
	DraftTypeReplyComment,
	DraftTypeDirectMessage,
} DraftType;

typedef enum {
	DraftStatusDraft,
	DraftStatusSending,
	DraftStatusSentFailt,
} DraftStatus;

@interface Draft : NSObject
@property (nonatomic, strong) NSString *draftId;
@property (nonatomic, assign) DraftType draftType;
@property (nonatomic, assign) DraftStatus draftStatus;
@property (nonatomic, assign) long long statusId;
@property (nonatomic, assign) long long commentId;
@property (nonatomic, assign) int recipientedId;
@property (nonatomic, assign) BOOL commentOrRetweet;
@property (nonatomic, assign) time_t createdAt;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, readonly) NSData *attachmentData;
@property (nonatomic, strong) UIImage *attachmentImage;

@end
