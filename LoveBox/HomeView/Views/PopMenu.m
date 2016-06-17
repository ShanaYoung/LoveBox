//
//  PopMenu.m
//  恋爱储蓄
//
//  Copyright © 2016年 Shana. All rights reserved.
//

#import "PopMenu.h"

@implementation PopMenu

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initImageView];
        [self initCenterArray:frame];
        [self setUpView];
        
        
    }
    return self;
}

- (void) initImageView
{
    CGRect  frame = CGRectMake(0, 0, 100, 100);
    
    _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _editButton.frame = frame;
    [_editButton setBackgroundImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
    
    _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _recordButton.frame = frame;
    [_recordButton setBackgroundImage:[UIImage imageNamed:@"recording"] forState:UIControlStateNormal];
    
    _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _settingButton.frame = CGRectMake(0, 0, 60, 60);
    [_settingButton setBackgroundImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    
    _backgroundView = [[UIView alloc]initWithFrame:self.frame];
    
    _editButton.tag = 0;
    _recordButton.tag = 1;
    _settingButton.tag=2;
    
}

-(void)initCenterArray:(CGRect)frame
{
    CGFloat widthUnit = frame.size.width/4;
    CGFloat heightHigh = frame.origin.y - _editButton.frame.size.height/2;
    CGFloat heightLow = frame.size.height + _editButton.frame.size.height/2;
    CGFloat gap = _editButton.frame.size.height/2 + 5;
    
    _centerHigh = [[NSMutableArray alloc]initWithObjects:
                   [NSValue valueWithCGPoint:CGPointMake(widthUnit, heightHigh)],
                   [NSValue valueWithCGPoint:CGPointMake(widthUnit*2, heightHigh)],
                   [NSValue valueWithCGPoint:CGPointMake(widthUnit*3, heightHigh)], nil];
    _centerLow = [[NSMutableArray alloc]initWithObjects:
                  [NSValue valueWithCGPoint:CGPointMake(widthUnit, heightLow)],
                  [NSValue valueWithCGPoint:CGPointMake(widthUnit*2, heightLow)],
                  [NSValue valueWithCGPoint:CGPointMake(widthUnit*3, heightLow)],nil];
    
    
    _centerMenu = [[NSMutableArray alloc]initWithObjects:
                   [NSValue valueWithCGPoint:CGPointMake([UIScreen mainScreen].bounds.size.width/2-70, [UIScreen mainScreen].bounds.size.height/2-70)],
                   [NSValue valueWithCGPoint:CGPointMake([UIScreen mainScreen].bounds.size.width/2+70, [UIScreen mainScreen].bounds.size.height/2-70)],
                   [NSValue valueWithCGPoint:CGPointMake(widthUnit*3, frame.size.height/2 - gap)],
                   [NSValue valueWithCGPoint:CGPointMake(widthUnit, frame.size.height/2 + gap)],
                   [NSValue valueWithCGPoint:CGPointMake(widthUnit*2, frame.size.height/2 + gap)],
                   [NSValue valueWithCGPoint:CGPointMake(widthUnit*3, frame.size.height/2 + gap)],nil];
    
    
}

-(void)setUpView
{
    self.hidden = YES;
    _backgroundView.backgroundColor = [UIColor colorWithRed:1 green:0.5 blue:0.5 alpha:1];
    UITapGestureRecognizer *gestur = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap)];
    [_backgroundView addGestureRecognizer:gestur];
    _backgroundView.userInteractionEnabled = YES;
    
    [_editButton addTarget:self action:@selector(clickMenu:) forControlEvents:UIControlEventTouchUpInside];
    [_recordButton addTarget:self action:@selector(clickMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_backgroundView];
    
    [self addSubview:_editButton];
    [self addSubview:_recordButton];
}

-(void)clickMenu:(UIButton*)sender
{
    NSInteger index = sender.tag;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didClickMenu:)])
    {
        [self hideMenuView];
        [_delegate didClickMenu:index];
        
    }
}

-(void)handleTap
{
    [self hideMenuView];
}

-(void)hideMenuView
{
    if (_isHidding) {
        return;
    }
    
    _isHidding = YES;
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _recordButton.center = [ _centerHigh[1] CGPointValue];
        
    } completion:^(BOOL finished) {
        self.hidden = YES;
        _isHidding = NO;

        
    }];
    
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        _editButton.center =  [_centerHigh[0] CGPointValue];
        _settingButton.center = [_centerHigh[2] CGPointValue];
    } completion:^(BOOL finished) {
        
    }];
    _recordButton.center = [ _centerHigh[1] CGPointValue];
    
    
}

-(void)showMenuView
{
    self.hidden = NO;
    
    _recordButton.center = [_centerLow[1] CGPointValue];
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _recordButton.center = [_centerMenu[1] CGPointValue];
        _settingButton.center=[_centerMenu[2] CGPointValue];
    } completion:^(BOOL finished) {
        
    }];
    _editButton.center = [_centerLow[0] CGPointValue];
    [UIView animateWithDuration:0.6 delay:0.1 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        _recordButton.center = [_centerMenu[0] CGPointValue];
        _editButton.center=[_centerMenu[1] CGPointValue];
        _settingButton.center = [_centerMenu[2] CGPointValue];
    } completion:^(BOOL finished) {
        
    }];
    
}

@end
