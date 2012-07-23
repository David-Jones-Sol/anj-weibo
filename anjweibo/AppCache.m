//
//  AppCache.m
//  anjweibo
//
//
//  Created by anjun on 12-6-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "AppCache.h"
#define kStaleSeconds 10

@implementation AppCache

#pragma mark -
#pragma mark Singleton Methods

static NSMutableDictionary *memoryCache;
static NSMutableArray *recentlyAccessedKeys;
static int kCacheMemoryLimit;

+(void) initialize
{
  NSString *cacheDirectory = [AppCache cacheDirectory];
  if(![[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory])
  {
    [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory
                              withIntermediateDirectories:YES 
                                               attributes:nil 
                                                    error:nil];            
  }
  
  double lastSavedCacheVersion = [[NSUserDefaults standardUserDefaults] doubleForKey:@"CACHE_VERSION"];
  double currentAppVersion = [[AppCache appVersion] doubleValue];
  
  if( lastSavedCacheVersion == 0.0f || lastSavedCacheVersion < currentAppVersion)
  {
    // assigning current version to preference
    [AppCache clearCache];
    
    [[NSUserDefaults standardUserDefaults] setDouble:currentAppVersion forKey:@"CACHE_VERSION"];					
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
  
  memoryCache = [[NSMutableDictionary alloc] init];
  recentlyAccessedKeys = [[NSMutableArray alloc] init];
  
  // you can set this based on the running device and expected cache size
  kCacheMemoryLimit = 10;
  
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMemoryCacheToDisk:) 
                                               name:UIApplicationDidReceiveMemoryWarningNotification 
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMemoryCacheToDisk:) 
                                               name:UIApplicationDidEnterBackgroundNotification 
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMemoryCacheToDisk:) 
                                               name:UIApplicationWillTerminateNotification 
                                             object:nil];  
}

+(void) dealloc
{
  memoryCache = nil;
  
  recentlyAccessedKeys = nil;
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
  
}

+(void) saveMemoryCacheToDisk:(NSNotification *)notification
{
  for(NSString *filename in [memoryCache allKeys])
  {
    NSString *archivePath = [[AppCache cacheDirectory] stringByAppendingPathComponent:filename];  
    NSData *cacheData = [memoryCache objectForKey:filename];
    [cacheData writeToFile:archivePath atomically:YES];
  }
  
  [memoryCache removeAllObjects];  
}

+(void) clearCache
{
  NSArray *cachedItems = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[AppCache cacheDirectory] 
                                                      error:nil];
  
  for(NSString *path in cachedItems)
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
  
  [memoryCache removeAllObjects];
}

+(NSString*) appVersion
{
	CFStringRef versStr = (CFStringRef)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey);
	NSString *version = [NSString stringWithUTF8String:CFStringGetCStringPtr(versStr,kCFStringEncodingMacRoman)];
	
	return version;
}

+(NSString*) cacheDirectory
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  NSString *cachesDirectory = [paths objectAtIndex:0];
	return [cachesDirectory stringByAppendingPathComponent:@"AppCache"];  
}

#pragma mark -
#pragma mark Custom Methods

// Add your custom methods here

+(void) cacheData:(NSData*) data toFile:(NSString*) fileName
{
  [memoryCache setObject:data forKey:fileName];
  if([recentlyAccessedKeys containsObject:fileName])
  {
    [recentlyAccessedKeys removeObject:fileName];
  }

  [recentlyAccessedKeys insertObject:fileName atIndex:0];
  
  if([recentlyAccessedKeys count] > kCacheMemoryLimit)
  {
    NSString *leastRecentlyUsedDataFilename = [recentlyAccessedKeys lastObject];
    NSData *leastRecentlyUsedCacheData = [memoryCache objectForKey:leastRecentlyUsedDataFilename];
    NSString *archivePath = [[AppCache cacheDirectory] stringByAppendingPathComponent:fileName];  
    [leastRecentlyUsedCacheData writeToFile:archivePath atomically:YES];
    
    [recentlyAccessedKeys removeLastObject];
    [memoryCache removeObjectForKey:leastRecentlyUsedDataFilename];
  }
}

+(NSData*) dataForFile:(NSString*) fileName
{
  NSData *data = [memoryCache objectForKey:fileName];  
  if(data) return data; // data is present in memory cache
    
	NSString *archivePath = [[AppCache cacheDirectory] stringByAppendingPathComponent:fileName];
  data = [NSData dataWithContentsOfFile:archivePath];
  
  if(data)
    [self cacheData:data toFile:fileName]; // put the recently accessed data to memory cache
  
  return data;
}

+(void) saveCache:(NSMutableArray*)obj toFile:(NSString*)fileName
{
  [self cacheData:[NSKeyedArchiver archivedDataWithRootObject:obj]
           toFile:fileName];  
    
}

+(NSMutableArray*) getCache:(NSString*)fileName
{
  return [NSKeyedUnarchiver unarchiveObjectWithData:[self dataForFile:fileName]];
}

+(BOOL) isStale:(NSString*)item
{
  // if it is in memory cache, it is not stale
  if([recentlyAccessedKeys containsObject:item])
    return NO;
  
	NSString *archivePath = [[AppCache cacheDirectory] stringByAppendingPathComponent:item];  
  
  NSTimeInterval stalenessLevel = [[[[NSFileManager defaultManager] attributesOfItemAtPath:archivePath error:nil] fileModificationDate] timeIntervalSinceNow];
  return stalenessLevel > kStaleSeconds;
}
@end
