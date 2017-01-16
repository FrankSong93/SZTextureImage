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

+ (instancetype)shareInstance;

- (void)removeObjectForKey:(NSString *)key;

@end
