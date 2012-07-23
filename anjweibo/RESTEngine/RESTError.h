//
//  RESTError.h
//  anjweibo
//
//  Created by anjun on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#define kRequestErrorDomain @"HTTP_ERROR"
#define kBusinessErrorDomain @"BIZ_ERROR" // rename this appropriately

@interface RESTError : NSError {

}

@property (nonatomic, strong) NSString *message;
@property (nonatomic, weak) NSString *errorCode;

- (NSString*) localizedOption;

-(id) initWithDictionary:(NSMutableDictionary*) jsonObject;
@end
