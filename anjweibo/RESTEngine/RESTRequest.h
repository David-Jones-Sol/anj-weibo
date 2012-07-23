//
//  RESTRequest.h
//  anjweibo
//
//  Created by anjun on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

#import "RESTError.h"

@interface RESTRequest : ASIFormDataRequest

@property (nonatomic, strong) RESTError *restError;

-(NSMutableDictionary*) responseDictionary;
@end
