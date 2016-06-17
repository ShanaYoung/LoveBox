//
//  ShowUsageViewController.m
//  恋爱储蓄
//
//  Copyright © 2016年 Shana. All rights reserved.
//

#import "ShowUsageViewController.h"
#import "WgCycleView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ShowUsageViewController ()
{
    UIScrollView *introScroll;
    NSArray<NSString *>*_imageUrls;
}
@end

@implementation ShowUsageViewController

-(void)getDatas{
    
    _imageUrls = @[@"1",@"2",@"3",@"4",@"5"];
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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getDatas];
    
    [self setupUI];
    
    [self createNavigationDetails];
    
}


-(void)setupUI{
    
    WgCycleView *cycleView = [[WgCycleView alloc] init];
    
    cycleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-self.navigationController.navigationBar.frame.size.height);
    cycleView.backgroundColor = [UIColor redColor];
    
    cycleView.imageUrls = _imageUrls;
    
    [self.view addSubview:cycleView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
