//
//  ViewController.m
//  SZTextureImageDemo
//
//  Created by songziqiang on 2017/1/16.
//  Copyright © 2017年 FrankSong. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+SZSprite.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *animatedImageView;

@end

@implementation ViewController {
	NSArray *_images;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	// 使用合成图
	NSDate* tmpStartData1 = [NSDate date];
	
	NSString *fileName = @"images/img_ar_right_answer_gif.plist";
	_images = [UIImage imagesOfFile:fileName];
	
	double deltaTime2 = [[NSDate date] timeIntervalSinceDate:tmpStartData1];
	NSLog(@",cost time = %f", deltaTime2);
	
	
	_animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2)];
	_animatedImageView.animationImages = _images;
	_animatedImageView.animationRepeatCount = 10;
	_animatedImageView.animationDuration = 0.1 * _animatedImageView.animationImages.count;
	[self.view addSubview:_animatedImageView];
	[_animatedImageView startAnimating];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
	_animatedImageView.animationImages = nil;
	[_animatedImageView removeFromSuperview];
	_animatedImageView = nil;
	_images = nil;
}


@end
