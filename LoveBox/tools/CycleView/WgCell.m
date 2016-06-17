//
//  WgCell.m
//  无限轮播
//
//  Created by mac on 16/4/17.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "WgCell.h"

@implementation WgCell{

    UIImageView *_imageView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];

        [self addSubview:_imageView];
        
    }
    return self;
}

-(void)setImagUrl:(NSString *)imagUrl{

    _imagUrl = imagUrl;

    _imageView.image = [UIImage imageNamed:imagUrl];
}

@end
