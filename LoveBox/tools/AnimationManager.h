//
//  AnimationManager.h
//  恋爱储蓄
//
//  Created by qianfeng on 16/5/11.
//  Copyright © 2016年 Shana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimationManager : NSObject

/** 创建曲线移动动画 */
-(CALayer *)layerFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint withImage:(NSString *)imageName addToView:(UIView *)view;

/** 创建中心等于父控件中心的旋转图片动画 */
-(CALayer *)createCenterRotationImage:(NSString *)imageNamed addToView:(UIView *)view;

@end
