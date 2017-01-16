//
//  UIImage+Texture.h
//  Texture-objc
//
//  Created by FrankSong on 2016/11/16.
//  Copyright © 2016年 FrankSong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SZSprite)

@property (nonatomic, copy, readonly) NSString *name;
// 获取单张图片
+ (instancetype)imageWithName:(NSString *)imageName fileName:(NSString *)fileName;

// 获取全部图片 sort by name
+ (NSArray<UIImage *> *)imagesOfFile:(NSString *)fileName;

// 获取全部图片
+ (NSArray<UIImage *> *)imagesOfFile:(NSString *)fileName withComparator:(NSComparator)comparator;

@end
