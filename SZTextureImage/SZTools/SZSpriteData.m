//
//  SpriteData.m
//  Texture-objc
//
//  Created by FrankSong on 2016/11/17.
//  Copyright © 2016年 FrankSong. All rights reserved.
//

#import "SZSpriteData.h"

@implementation SZSpriteData

- (CGRect)toRect {
    return CGRectMake(_positionX, _positionY, _spriteWidth, _spriteHeight);
}

@end
