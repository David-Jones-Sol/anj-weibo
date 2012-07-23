//
//  AppCache.h
//  anjweibo
//
//
//  Created by anjun on 12-6-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface AppCache : NSObject {

}

+(NSString*) cacheDirectory;
+(void) clearCache;
+(NSString*) appVersion;

+(void) saveCache:(NSMutableArray*)obj
                  toFile:(NSString*)fileName;
+(NSMutableArray*) getCache:(NSString* )fileName;
+(BOOL) isStale:(NSString*)item;

@end
