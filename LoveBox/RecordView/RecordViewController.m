//
//  RecordViewController.m
//  恋爱储蓄
//
//  Copyright © 2016年 Shana. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordManager.h"
#import "Masonry.h"

@interface RecordViewController ()
{
    CALayer *_layer;
    CAAnimationGroup *_animaTionGroup;
    CADisplayLink *_disPlayLink;
    
}

@property(nonatomic,strong)UILabel *hintLabel;
@property(strong,nonatomic)UIButton *recordBtn;
@property(nonatomic,strong)CALayer *staticLayer;
@property(nonatomic,strong)CAGradientLayer *staticShadowLayer;
@property(nonatomic)double getAddressTime;
@property(nonatomic,strong)NSTimer *timer;
@property(strong,nonatomic)UILongPressGestureRecognizer *longPressGes;
@property(nonatomic,strong)RecordManager *recordManger;

@end

@implementation RecordViewController

-(CALayer *)staticLayer
{
    if (!_staticLayer) {
        self.staticLayer=[[CALayer alloc] init];
        self.staticLayer.cornerRadius=[UIScreen mainScreen].bounds.size.width/4;
        self.staticLayer.frame=CGRectMake(0, 0, self.staticLayer.cornerRadius*2, self.staticLayer.cornerRadius*2);
        self.staticLayer.borderWidth=1;
        self.staticLayer.position=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        UIColor *color=[UIColor colorWithRed:1 green:0.5 blue:0.5 alpha:0.2];
        
        self.staticLayer.borderColor=color.CGColor;
    }
    
    return _staticLayer;
}

-(CAGradientLayer *)staticShadowLayer
{
    if (!_staticShadowLayer) {
        self.staticShadowLayer=[[CAGradientLayer alloc] init];
        self.staticShadowLayer.cornerRadius=[UIScreen mainScreen].bounds.size.width/4;
        self.staticShadowLayer.frame=CGRectMake(0, 0, self.staticLayer.cornerRadius*2-1, self.staticLayer.cornerRadius*2-1);
        
        self.staticShadowLayer.position=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        UIColor *backColor=[UIColor colorWithRed:1 green:0.5 blue:0.5 alpha:0.2];
        self.staticShadowLayer.colors=[NSArray arrayWithObjects:(id)backColor.CGColor,[UIColor whiteColor].CGColor,nil];
    }
    
    return _staticShadowLayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recordBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.recordBtn.frame=CGRectMake(0, 0, 100, 100);
    self.recordBtn.center=self.view.center;
    [self.recordBtn setBackgroundImage:[UIImage imageNamed:@"大录音"] forState:UIControlStateNormal];
    
    UILongPressGestureRecognizer *longPressGes=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(judgeForStateOfGes:)];
    self.longPressGes=longPressGes;
    [self.recordBtn addGestureRecognizer:longPressGes];
    [self.view addSubview:self.recordBtn];
    
    [self.view addSubview:self.hintLabel];
    
    [self createNavigationDetails];
    
    [self startAnimation];
}

-(void)createNavigationDetails
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    btn.frame=CGRectMake(0, 0, 70, 30);
    //让按钮内部的所有内容左对齐
    btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    
    //让按钮的内容往左偏移10
    btn.contentEdgeInsets=UIEdgeInsetsMake(0, -10, 0, 0);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    //修改导航栏左边的item
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)judgeForStateOfGes:(UIGestureRecognizer *)ges
{
    if (ges.state==UIGestureRecognizerStateBegan) {
        [self touchBtn];
    }
    else if(ges.state==UIGestureRecognizerStateEnded){
        [self endBtn];
    }
}

-(UILabel *)hintLabel
{
    if (_hintLabel==nil) {
        _hintLabel=[[UILabel alloc] init];
        _hintLabel.text=@"按住录音按钮 开始录制想说的话";
//        _hintLabel.textColor=[UIColor colorWithRed:189.0/255 green:65.0/255 blue:103.0/255 alpha:1];
        _hintLabel.textColor=[UIColor lightGrayColor];
        _hintLabel.frame=CGRectMake(self.view.center.x-120, self.view.center.y+100, 250, 30);
        _hintLabel.textAlignment=NSTextAlignmentCenter;
        _hintLabel.contentMode=UIViewContentModeCenter;
        _hintLabel.font=[UIFont fontWithName:@ "Arial Rounded MT Bold"  size:(17.0)];
    }
    return _hintLabel;
}

-(void)startAnimation
{
    [self.view.layer addSublayer:self.staticLayer];
    [self.view.layer addSublayer:self.staticShadowLayer];
    
    CAMediaTimingFunction *defaultCurve=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    _animaTionGroup=[CAAnimationGroup animation];
    _animaTionGroup.delegate=self;
    _animaTionGroup.duration=1;
    _animaTionGroup.removedOnCompletion=YES;
    _animaTionGroup.timingFunction=defaultCurve;
    
    _animaTionGroup.autoreverses=YES;
    _animaTionGroup.repeatCount=MAXFLOAT;
    
    CABasicAnimation *scaleAnimation=[CABasicAnimation animationWithKeyPath:@"transform.xy"];
    scaleAnimation.fromValue=@0.7;
    scaleAnimation.toValue=@0.8;
    scaleAnimation.duration=1;
    scaleAnimation.repeatCount=MAXFLOAT;
    scaleAnimation.autoreverses=YES;
    
    CAKeyframeAnimation *opencityAnimation=[CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opencityAnimation.duration=1;
    opencityAnimation.values=@[@0.6,@0.2,@0.2];
    opencityAnimation.keyTimes=@[@0,@0.5,@1];
    opencityAnimation.removedOnCompletion=YES;
    opencityAnimation.autoreverses=YES;
    opencityAnimation.repeatCount=MAXFLOAT;
    
    NSArray *animations=@[scaleAnimation];
    
    _animaTionGroup.animations=animations;
    [self.staticLayer addAnimation:_animaTionGroup forKey:@"groupAnnimation"];
    [self.staticShadowLayer addAnimation:_animaTionGroup forKey:@"groupAnnimation"];
    
    [self.view bringSubviewToFront:self.recordBtn];
}

-(void)click
{
    self.getAddressTime=[[NSDate date] timeIntervalSince1970];
    CALayer *layer=[[CALayer alloc] init];
    layer.cornerRadius=[UIScreen mainScreen].bounds.size.width;
    layer.frame=CGRectMake(0, 0, layer.cornerRadius*2, layer.cornerRadius*2);
    layer.borderWidth=1;
    layer.position=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    
    UIColor *color=[UIColor colorWithRed:1 green:0.5 blue:0.5 alpha:0.2];
    
    UIColor *backColor=[UIColor colorWithRed:1 green:0.5 blue:0.5 alpha:0.2];
    layer.borderColor=color.CGColor;
    [self.view.layer addSublayer:layer];
    
    CAGradientLayer *layer1=[[CAGradientLayer alloc] init];
    layer1.cornerRadius=[UIScreen mainScreen].bounds.size.width;
    layer1.frame=CGRectMake(0, 0, layer.cornerRadius*2-1, layer.cornerRadius*2-1);
    layer1.position=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    
    UIColor * backColor1=[UIColor colorWithRed:1 green:0.5 blue:0.5 alpha:0.2];
    layer1.colors=[NSArray arrayWithObjects:(id)backColor.CGColor, (id)backColor1.CGColor, nil];
    [self.view.layer addSublayer:layer1];
    
    CAMediaTimingFunction *defaultCurve=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    _animaTionGroup=[CAAnimationGroup animation];
    _animaTionGroup.delegate=self;
    _animaTionGroup.duration=2;
    _animaTionGroup.removedOnCompletion=YES;
    _animaTionGroup.timingFunction=defaultCurve;
    
    CABasicAnimation *scaleAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue=@0.15;
    scaleAnimation.toValue=@1;
    scaleAnimation.duration=2;
    
    CAKeyframeAnimation *opencityAnimation=[CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opencityAnimation.duration=2;
    opencityAnimation.values=@[@0.6,@0.2,@0.2];
    opencityAnimation.keyTimes=@[@0,@0.5,@1];
    opencityAnimation.removedOnCompletion=YES;
    
    NSArray *animations=@[scaleAnimation];
    
    _animaTionGroup.animations=animations;
    [layer addAnimation:_animaTionGroup forKey:@"groupAnnimation"];
    [layer1 addAnimation:_animaTionGroup forKey:@"groupAnnimation"];
    
    [self performSelector:@selector(removeLayer:) withObject:layer afterDelay:2];
    [self performSelector:@selector(removeLayer:) withObject:layer1 afterDelay:2];
    [self.view bringSubviewToFront:self.recordBtn];
}

-(void)removeLayer:(CALayer *)layer
{
    [layer removeFromSuperlayer];
    [layer removeAnimationForKey:@"groupAnnimation"];
    
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(action) userInfo:nil repeats:NO];
}

-(void)action
{
    NSTimeInterval currentTime=[[NSDate date] timeIntervalSince1970];
    if (currentTime-self.getAddressTime>2) {
        [self startAnimation];
        [self.timer invalidate];
        self.timer=nil;
    }
    else
    {
        self.timer=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(action) userInfo:nil repeats:NO];
    }
}

-(void)touchBtn
{
    _hintLabel.text=@"松开手指即可结束录音";
    [self.staticShadowLayer removeFromSuperlayer];
    [self.staticShadowLayer removeAnimationForKey:@"groupAnnimation"];
    [self.staticLayer removeFromSuperlayer];
    [self.staticLayer removeAnimationForKey:@"groupAnnimation"];
    
    _disPlayLink=[CADisplayLink displayLinkWithTarget:self selector:@selector(click)];
    _disPlayLink.frameInterval=40;
    [_disPlayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    self.recordManger=[[RecordManager alloc] init];
    [self.recordManger startRecording];
}

-(void)endBtn
{
    [self.recordManger endRecording];
    _hintLabel.text=@"录音存储成功";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _hintLabel.text=@"按住录音按钮 开始录制想说的话";
    });
    [self.view.layer removeAllAnimations];
    [_disPlayLink invalidate];
    _disPlayLink=nil;
}

-(void)delayAnimation
{
    [self startAnimation];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backgroundRecordTitle"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
