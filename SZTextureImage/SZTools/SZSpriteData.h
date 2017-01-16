//
//  SpriteData.h
//  Texture-objc
//
//  Created by FrankSong on 2016/11/17.
//  Copyright © 2016年 FrankSong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>
#import <CoreGraphics/CGGeometry.h>

@interface SZSpriteData : NSObject

@property (nonatomic, assign) CGFloat positionX;
@property (nonatomic, assign) CGFloat positionY;
@property (nonatomic, assign) CGFloat spriteWidth;
@property (nonatomic, assign) CGFloat spriteHeight;
@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic, assign) CGFloat offsetY;

- (CGRect)toRect;

@end
