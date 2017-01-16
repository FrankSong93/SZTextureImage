//
//  CacheManager.m
//  Texture-objc
//
//  Created by FrankSong on 2017/1/16.
//  Copyright © 2017年 FrankSong. All rights reserved.
//

#import "SZCacheManager.h"
#import <UIKit/UIKit.h>

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

- (instancetype)init {
	if (self = [super init]) {
		_shouldRemoveAllObjectsOnMemoryWarning = YES;
		_shouldRemoveAllObjectsWhenEnteringBackground = YES;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_appDidReceiveMemoryWarningNotification) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_appDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
	}
	return self;
}

- (void)_appDidReceiveMemoryWarningNotification {
	if (_shouldRemoveAllObjectsOnMemoryWarning) {
		[self.imageCache removeAllObjects];
		[self.spirteDataCache removeAllObjects];
		[self.spirteImageCache removeAllObjects];
	}
}

- (void)_appDidEnterBackgroundNotification {
	if (_shouldRemoveAllObjectsWhenEnteringBackground) {
		[self.imageCache removeAllObjects];
		[self.spirteDataCache removeAllObjects];
		[self.spirteImageCache removeAllObjects];
	}	
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
