//
//  AnimationManager.m
//  恋爱储蓄
//
//  Created by qianfeng on 16/5/11.
//  Copyright © 2016年 Shana. All rights reserved.
//

#import "AnimationManager.h"

@implementation AnimationManager

#pragma mark - 创建曲线移动动画
-(CALayer *)layerFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint withImage:(NSString *)imageName addToView:(UIView *)view
{
    CALayer *chLayer = [[CALayer alloc] init];
    chLayer.frame = CGRectMake(startPoint.x, startPoint.y, 50, 30);
    //设置背景图片
    chLayer.contents=(id)[UIImage imageNamed:imageName].CGImage;
    [view.layer addSublayer:chLayer];
    CAKeyframeAnimation *CHAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
    CGPathAddQuadCurveToPoint(path, NULL, endPoint.x, startPoint.y, endPoint.x, endPoint.y);
    
    CHAnimation.path = path;
    CHAnimation.removedOnCompletion = NO;
    CHAnimation.fillMode = kCAFillModeBoth;
    CHAnimation.duration = 0.7;
    CHAnimation.delegate = self;
    [chLayer addAnimation:CHAnimation forKey:nil];
    return chLayer;
}

#pragma mark - 创建中心等于父控件中心的旋转图片动画
-(CALayer *)createCenterRotationImage:(NSString *)imageNamed addToView:(UIView *)view
{
    UIImageView *img=[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageNamed]];
    img.frame=CGRectMake(0, 0, 100, 100);
    img.center=CGPointMake(view.center.x, view.center.y-100);
    img.layer.cornerRadius=50;
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    CGFloat point=M_PI_4;
    animation.values=@[@(9*point),@(8*point),@(7*point),@(6 * point),@(5 * point),@(4 * point),@(3 * point),@(2 * point),@(point)];
    animation.repeatCount=MAXFLOAT;
    animation.duration=5;
    
    [img.layer addAnimation:animation forKey:nil];
    [img.layer setMasksToBounds:YES];
    [view addSubview:img];
    
    return img.layer;
}



@end
