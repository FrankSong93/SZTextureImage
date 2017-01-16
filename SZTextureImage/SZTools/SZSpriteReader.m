//
//  SpriteReader.m
//  Texture-objc
//
//  Created by FrankSong on 2016/11/17.
//  Copyright © 2016年 FrankSong. All rights reserved.
//

#import "SZSpriteReader.h"
#import "SZCacheManager.h"
#import "SZSpriteData.h"
#import <UIKit/UIKit.h>

/**
 Return the path scale.
 
 e.g.
 <table>
 <tr><th>Path            </th><th>Scale </th></tr>
 <tr><td>"icon.png"      </td><td>1     </td></tr>
 <tr><td>"icon@2x.png"   </td><td>2     </td></tr>
 <tr><td>"icon@2.5x.png" </td><td>2.5   </td></tr>
 <tr><td>"icon@2x"       </td><td>1     </td></tr>
 <tr><td>"icon@2x..png"  </td><td>1     </td></tr>
 <tr><td>"icon@2x.png/"  </td><td>1     </td></tr>
 </table>
 */
static CGFloat _NSStringPathScale(NSString *string) {
    if (string.length == 0 || [string hasSuffix:@"/"]) return 1;
    NSString *name = string.stringByDeletingPathExtension;
    __block CGFloat scale = 1;
    
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:@"@[0-9]+\\.?[0-9]*x$" options:NSRegularExpressionAnchorsMatchLines error:nil];
    [pattern enumerateMatchesInString:name options:kNilOptions range:NSMakeRange(0, name.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if (result.range.location >= 3) {
            scale = [string substringWithRange:NSMakeRange(result.range.location + 1, result.range.length - 2)].doubleValue;
        }
    }];
    
    return scale;
}

@implementation SZSpriteReader

+ (NSDictionary *)spritesWithContentOfFile:(NSString *)filename
{
    if (!filename) {
        return nil;
    }
    
    SZCacheManager *manager = [SZCacheManager shareInstance];
    
    if ([manager.spirteDataCache objectForKey:filename]) {
        return [manager.spirteDataCache objectForKey:filename];
    }
    
    // split file name
    NSString* file = [[filename lastPathComponent] stringByDeletingPathExtension];
    NSString* extension = [filename pathExtension];
    
    // check if the filename contained a path
    BOOL isContainedPath = NO;
    NSUInteger nameLength = file.length + extension.length + 1;
    if(nameLength < filename.length) {
        file = [NSString stringWithFormat:@"%@%@",[filename substringToIndex:filename.length - nameLength],file];
        isContainedPath = YES;
    }
    
    // check if we need to load the @2x/@3x file
    NSString *filePath = [NSString stringWithFormat:@"%@@%dx", file, (int)[UIScreen mainScreen].scale];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:filePath ofType:extension]]) {
        file = filePath;
    }
    
    // read the data from the plist file
    NSDictionary* xmlDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:extension]];
    
    // cache big UIImage
    NSDictionary *mate = [xmlDictionary objectForKey:@"meta"];
    NSString *imageName = [mate objectForKey:@"image"];
    
    NSString* imageFile = [[imageName lastPathComponent] stringByDeletingPathExtension];
    NSString* imageExtension = [imageName pathExtension];
    
    if (isContainedPath) {
        imageFile = [NSString stringWithFormat:@"%@%@",[filename substringToIndex:filename.length - nameLength], imageFile];
    }
    
    NSData *imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageFile ofType:imageExtension]];
    UIImage *image = [UIImage imageWithData:imageData scale:_NSStringPathScale(imageFile)];
    
    if (image) {
        [manager.imageCache setObject:image forKey:filename];
    }
    
    // target dictionary containing the TPSpriteData objects
    NSMutableDictionary* tpDict = [[NSMutableDictionary alloc] init];
    
    // extract frames
    NSDictionary* frames = [xmlDictionary objectForKey:@"frames"];
    
    for (NSString* name in [frames allKeys])
    {
        NSDictionary *sprite = [frames objectForKey:name];
        
        // create the frame object
        SZSpriteData *temp = [[SZSpriteData alloc] init];
        [temp setPositionX:[[sprite objectForKey:@"x"] floatValue]];
        [temp setPositionY:[[sprite objectForKey:@"y"] floatValue]];
        [temp setSpriteWidth:[[sprite objectForKey:@"w"] floatValue]];
        [temp setSpriteHeight:[[sprite objectForKey:@"h"] floatValue]];
        
        // get the offset if sprite is trimmed
        NSString *oXString = [sprite objectForKey:@"oX"];
        NSString *oYString = [sprite objectForKey:@"oY"];
        [temp setOffsetX:oXString ? [oXString floatValue] : 0];
        [temp setOffsetY:oYString ? [oYString floatValue] : 0];
        
        // add frame to data
        [tpDict setObject:temp forKey:name];
    }
    
    [manager.spirteDataCache setObject:tpDict forKey:filename];
    
    return tpDict;
}

+ (UIImage *)imageWithFileName:(NSString *)filename {
    if (!filename) {
        return nil;
    }
    
    SZCacheManager *manager = [SZCacheManager shareInstance];
    if ([manager.imageCache objectForKey:filename]) {
        return [manager.imageCache objectForKey:filename];
    }
    
    // split file name
    NSString* file = [[filename lastPathComponent] stringByDeletingPathExtension];
    NSString* extension = [filename pathExtension];
    
    // check if the filename contained a path
    BOOL isContainedPath = NO;
    NSUInteger nameLength = file.length + extension.length + 1;
    if(nameLength < filename.length) {
        isContainedPath = YES;
        file = [NSString stringWithFormat:@"%@%@",[filename substringToIndex:filename.length - nameLength],file];
    }
    
    // check if we need to load the @2x/@3x file
    NSString *filePath = [NSString stringWithFormat:@"%@@%dx", file, (int)[UIScreen mainScreen].scale];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:filePath ofType:extension]]) {
        file = filePath;
    }

    // read the data from the plist file
    NSDictionary* xmlDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:extension]];
    
    // cache UIImage
    NSDictionary *mate = [xmlDictionary objectForKey:@"meta"];
    NSString *imageName = [mate objectForKey:@"image"];
    
    NSString* imageFile = [[imageName lastPathComponent] stringByDeletingPathExtension];
    NSString* imageExtension = [imageName pathExtension];
    
    if (isContainedPath) {
        imageFile = [NSString stringWithFormat:@"%@%@",[filename substringToIndex:filename.length - nameLength], imageFile];
    }
    
    NSData *imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageFile ofType:imageExtension]];
    UIImage *image = [UIImage imageWithData:imageData scale:_NSStringPathScale(imageFile)];
    
    if (image) {
        [manager.imageCache setObject:image forKey:filename];
    }
    
    return image;
    
}

@end
