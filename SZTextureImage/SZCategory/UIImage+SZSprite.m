//
//  UIImage+Texture.m
//  Texture-objc
//
//  Created by FrankSong on 2016/11/16.
//  Copyright © 2016年 FrankSong. All rights reserved.
//

#import "UIImage+SZSprite.h"
#import "SZSpriteReader.h"
#import "SZSpriteData.h"
#import "SZCacheManager.h"
#import <objc/runtime.h>

static char nameKey;

@implementation UIImage (SZSprite)

@dynamic name;

- (void)setName:(NSString *)name {
	objc_setAssociatedObject(self, &nameKey, name, OBJC_ASSOCIATION_COPY);
}

- (NSString *)name {
	return objc_getAssociatedObject(self, &nameKey);
}

+ (instancetype)imageWithName:(NSString *)imageName fileName:(NSString *)fileName {
    if (!imageName || !fileName) {
        return nil;
    }
	
    NSString *cacheKey = [NSString stringWithFormat:@"%@_%@", imageName, fileName];
    if ([[SZCacheManager shareInstance].spirteImageCache objectForKey:cacheKey]) {
        return [[SZCacheManager shareInstance].spirteImageCache objectForKey:cacheKey];
    }
    
    NSDictionary *spriteDic = [SZSpriteReader spritesWithContentOfFile:fileName];
    SZSpriteData *imageFrame = [spriteDic objectForKey:imageName];
    if (!imageFrame) {
        return nil;
    }
    
    UIImage *spritesImage = [SZSpriteReader imageWithFileName:fileName];
	spritesImage.name = imageName;
    CGImageRef sprite = CGImageCreateWithImageInRect(spritesImage.CGImage, [imageFrame toRect]);
    spritesImage = [UIImage imageWithCGImage:sprite scale:1.0 orientation:UIImageOrientationUp];
    CGImageRelease(sprite);

    [[SZCacheManager shareInstance].spirteImageCache setObject:spritesImage forKey:cacheKey];
    
    return spritesImage;
}

+ (NSMutableArray<UIImage *> *)getImagesWithFileName:(NSString *)fileName {
	if (!fileName) {
		return nil;
	}
	// 1. get FilePlist info
	NSDictionary *spirtesData = [SZSpriteReader spritesWithContentOfFile:fileName];
	// 2. get bigImage
	UIImage *bigImage = [SZSpriteReader imageWithFileName:fileName];
	
	if (!bigImage || !spirtesData) {
		return nil;
	}
	
	// 3. get Spirte from bigImage
	NSMutableArray<UIImage *> *images = [NSMutableArray arrayWithCapacity:spirtesData.allKeys.count];
	
	for (NSString *key in spirtesData.allKeys) {
		NSString *cacheKey = [NSString stringWithFormat:@"%@_%@", key, fileName];
		if ([[SZCacheManager shareInstance].spirteImageCache objectForKey:cacheKey]) {
			[images addObject:[[SZCacheManager shareInstance].spirteImageCache objectForKey:cacheKey]];
			continue;
		}
		
		SZSpriteData *imageFrame = [spirtesData objectForKey:key];
		if (!imageFrame) {
			return nil;
		}
		
		CGImageRef sprite = CGImageCreateWithImageInRect(bigImage.CGImage, [imageFrame toRect]);
		UIImage *newImage = [UIImage imageWithCGImage:sprite scale:1.0 orientation:UIImageOrientationUp];
		newImage.name = key;
		CGImageRelease(sprite);
		
		[[SZCacheManager shareInstance].spirteImageCache setObject:newImage forKey:cacheKey];
		[images addObject:newImage];
	}
	
	return images;
}

+ (NSArray<UIImage *> *)imagesOfFile:(NSString *)fileName {
	NSMutableArray<UIImage *> *images = [UIImage getImagesWithFileName:fileName];
	[images sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
		UIImage *image1 = (UIImage *)obj1;
		UIImage *image2 = (UIImage *)obj2;
		return [image1.name compare:image2.name];
	}];
    
    return [images copy];
}

+ (NSArray<UIImage *> *)imagesOfFile:(NSString *)fileName withComparator:(NSComparator)comparator {
	NSMutableArray<UIImage *> *images = [UIImage getImagesWithFileName:fileName];
	[images sortUsingComparator:comparator];
	
	return [images copy];
}

@end
