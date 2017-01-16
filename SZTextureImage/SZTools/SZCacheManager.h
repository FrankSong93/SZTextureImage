//
//  CacheManager.h
//  Texture-objc
//
//  Created by FrankSong on 2017/1/16.
//  Copyright © 2017年 FrankSong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZCacheManager : NSObject

@property (nonatomic, strong) NSCache *imageCache; // 缓存大张的image
@property (nonatomic, strong) NSCache *spirteDataCache; // 缓存每张大图对应小图的frame
@property (nonatomic, strong) NSCache *spirteImageCache; // 缓存切好的小图

/**
 If `YES`, the cache will remove all objects when the app receives a memory warning.
 The default value is `YES`.
 */
@property (nonatomic, assign) BOOL shouldRemoveAllObjectsOnMemoryWarning;

/**
 If `YES`, The cache will remove all objects when the app enter background.
 The default value is `YES`.
 */
@property (nonatomic, assign) BOOL shouldRemoveAllObjectsWhenEnteringBackground;

+ (instancetype)shareInstance;

- (void)removeObjectForKey:(NSString *)key;

@end
