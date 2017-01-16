//
//  SpriteReader.h
//  Texture-objc
//
//  Created by FrankSong on 2016/11/17.
//  Copyright © 2016年 FrankSong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;
@interface SZSpriteReader : NSObject

// TexturePacker Data Format choose UIKit(Plist)
+ (NSDictionary *)spritesWithContentOfFile:(NSString *)fileName;

// 获取对应的合成图
+ (UIImage *)imageWithFileName:(NSString *)fileName;

@end
