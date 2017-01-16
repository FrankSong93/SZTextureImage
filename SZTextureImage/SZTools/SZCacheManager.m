//
//  CacheManager.m
//  Texture-objc
//
//  Created by FrankSong on 2017/1/16.
//  Copyright © 2017年 FrankSong. All rights reserved.
//

#import "SZCacheManager.h"

@implementation SZCacheManager

+ (instancetype)shareInstance {
	static SZCacheManager *cacheManager;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		cacheManager = [[SZCacheManager alloc] init];
		cacheManager.spirteDataCache = [[NSCache alloc] init];
		cacheManager.spirteDataCache.name = @"CacheManager_spirteDataCache";

		cacheManager.imageCache = [[NSCache alloc] init];
		cacheManager.imageCache.name = @"CacheManager_imageCache";
		
		cacheManager.spirteImageCache = [[NSCache alloc] init];
		cacheManager.spirteImageCache.name = @"CacheManager_spirteImageCache";
	});
	return cacheManager;
}

- (void)removeObjectForKey:(NSString *)key {
	NSDictionary *spirtesData =  [self.spirteDataCache objectForKey:key];
	for (NSString *prefixKey in spirtesData.allKeys) {
		NSString *cacheKey = [NSString stringWithFormat:@"%@_%@", prefixKey, key];
		[self.spirteImageCache removeObjectForKey:cacheKey];
	}
	
	[self.spirteDataCache removeObjectForKey:key];
	[self.imageCache removeObjectForKey:key];
}

@end
