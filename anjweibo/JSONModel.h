//
//  ModelBase.h
//  anjweibo
//
//  Created by anjun on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface JSONModel : NSObject <NSCoding, NSCopying, NSMutableCopying> {

}

-(id) initWithDictionary:(NSDictionary*) jsonObject;

@end
