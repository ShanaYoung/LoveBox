//
//  ViewController.m
//  恋爱储蓄
//
//  Copyright © 2016年 Shana. All rights reserved.
//

#import "ViewController.h"
#import "PopMenu.h"
#import "RecordViewController.h"
#import "EditViewController.h"
#import "RecordManager.h"
#import "AnimationManager.h"
#import "TextFileManager.h"
#import "SettingViewController.h"
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"

@interface ViewController ()<PopMenuDelegate>
{
    UITapGestureRecognizer *tap;
    UITapGestureRecognizer *tap1;
    CGMutablePathRef _starPath;
    int value_choice;
    NSArray *textFile;
    NSArray *recordFile;
}
@property(strong,nonatomic)UIImageView *imageForShake;
@property(strong,nonatomic)NSMutableArray<CALayer *> *redLayers;
@property(strong,nonatomic)NSMutableArray<CALayer *> *rotationLayers;

@property(strong,nonatomic)CALayer *chLayer;
@property(strong,nonatomic)UIImageView *girlImg;
@property (nonatomic,strong)PopMenu * popView;
@property(nonatomic,strong)UIButton *MenuBtn;
@property(nonatomic,strong)UIButton *btn_Record;
@property(nonatomic,strong)RecordManager *recordManager;
@property(strong,nonatomic)NSString *recordFileName;
@property(nonatomic,strong)AnimationManager *animationManager;
@property(nonatomic,strong)UILabel *hintLabel;
@property(nonatomic,strong)UIImageView *back_img;
@property(nonatomic,strong)UIButton *btn_Read;
@property(nonatomic,strong)UIImageView *img_letter;
@property(nonatomic,strong)TextFileManager *textFileManager;
@property(nonatomic,strong)UITextView *letter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recordManager=[[RecordManager alloc] init];
    self.animationManager=[[AnimationManager alloc]init];
    self.rotationLayers=[[NSMutableArray alloc]init];
    self.textFileManager=[[TextFileManager alloc] init];
    [self setForUI];
    [self createNavigationDetails];
}

-(void)createNavigationDetails
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    btn.frame=CGRectMake(0, 0, 30, 30);
    [btn addTarget:self action:@selector(showSetting) forControlEvents:UIControlEventTouchUpInside];
    
    //修改导航栏右边的item
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)showSetting
{
    [self.recordManager stopRecording];
    SettingViewController *svc=[[SettingViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
}

#pragma mark - 创建界面
-(void)setForUI
{
    
    UITextView *letter=[[UITextView alloc] initWithFrame:CGRectMake(40, 43, 200, 200)];
    letter.font=[UIFont systemFontOfSize:12];
    letter.transform=CGAffineTransformRotate(letter.transform, -0.11);
    letter.backgroundColor=[UIColor clearColor];
    self.letter=letter;
    
    UIImageView *back_img=[[UIImageView alloc] initWithFrame:self.view.frame];
    back_img.image=[UIImage imageNamed:@"background_first"];
    [self.view addSubview:back_img];
    self.back_img=back_img;
    [self.view sendSubviewToBack:back_img];
    
    tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchDownGirl)];
    tap1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu)];
    UIView *aView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *imgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menuClick"]];
    imgView.userInteractionEnabled=YES;
    [imgView addGestureRecognizer:tap1];
    imgView.frame=CGRectMake(0, 0, 32, 32);
    
    self.MenuBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.MenuBtn setImage:[UIImage imageNamed:@"menuClick"] forState:UIControlStateNormal];
    [self.MenuBtn setImage:[UIImage imageNamed:@"menuSelected"] forState:UIControlStateHighlighted];
    [self.MenuBtn addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:self.MenuBtn];
    self.navigationItem.titleView=aView;
    
    self.imageForShake=[[UIImageView alloc] init];
    [self.view addSubview:self.imageForShake];
    
    self.imageForShake.image=[UIImage imageNamed:@"gift"];
    [self.imageForShake makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.top.equalTo(self.view).offset(20);
        make.width.height.equalTo(self.view.width).multipliedBy(1/4.0);
    }];
    
    
    self.girlImg=[[UIImageView alloc] init];
    [self.view addSubview:self.girlImg];
    self.girlImg.image=[UIImage imageNamed:@"human_girl1"];
    [_girlImg makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).multipliedBy(1/5.0);
        make.height.equalTo(_girlImg.width).multipliedBy(3);
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-10);
    }];
    
    self.girlImg.userInteractionEnabled=YES;
    
    _popView = [[PopMenu alloc]initWithFrame:self.view.frame];
    _popView.delegate = self;
    [self.view addSubview:_popView];
    
    self.redLayers = [[NSMutableArray alloc]init];
    
    UIButton *btn_Record=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 52)];
    btn_Record.center=CGPointMake(self.view.center.x, self.view.center.y-52);
    [btn_Record setImage:[UIImage imageNamed:@"cidai"] forState:UIControlStateNormal];
    [btn_Record addTarget:self action:@selector(showRecording) forControlEvents:UIControlEventTouchUpInside];
    self.btn_Record=btn_Record;
    [self.view addSubview:btn_Record];
    
    self.btn_Record.hidden=YES;
    
    UIButton *btn_Read=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 52)];
    btn_Read.center=CGPointMake(self.view.center.x, self.view.center.y-52);
    [btn_Read setImage:[UIImage imageNamed:@"envelope"] forState:UIControlStateNormal];
    [btn_Read addTarget:self action:@selector(showLetters) forControlEvents:UIControlEventTouchUpInside];
    self.btn_Record=btn_Record;
    [self.view addSubview:btn_Record];
    self.btn_Read.hidden=YES;
    
    self.hintLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 200, 200, 30)];
    self.hintLabel.transform=CGAffineTransformMakeRotation(-0.3);
    self.hintLabel.font=[UIFont systemFontOfSize:12];
    self.hintLabel.textColor=[UIColor lightGrayColor];

    self.hintLabel.hidden=NO;
}

#pragma mark - 点击菜单按钮
-(void)didClickMenu:(NSInteger)index
{
    
    if (index==1) {
        RecordViewController *rvc=[[RecordViewController alloc] init];
        [self.navigationController pushViewController:rvc animated:YES];
    }
    else if(index==0)
    {
        EditViewController *evc=[[EditViewController alloc] init];
        [self.navigationController pushViewController:evc animated:YES];
    }
    else
    {
        SettingViewController *svc=[[SettingViewController alloc] init];
        [self.navigationController pushViewController:svc animated:YES];
    }
}

#pragma mark - 显示菜单界面
-(void)presentView
{
    [_popView showMenuView];
}

#pragma mark - 礼物盒摇一摇动画
-(void)shakeView:(UIImageView *)viewToShake
{
    self.hintLabel.hidden=YES;
    CGAffineTransform translateUp = CGAffineTransformRotate(CGAffineTransformIdentity, 0.25);
    CGAffineTransform translateDown = CGAffineTransformRotate(CGAffineTransformIdentity, -0.25);
    viewToShake.transform = translateUp;
    
    [UIView animateWithDuration:0.2 delay:1 options:UIViewAnimationOptionAutoreverse animations:^{
        [UIView setAnimationRepeatCount:2.5];
        viewToShake.transform = translateDown;
    } completion:^(BOOL finished){
        if(finished){
            [self plusTapHandle];
        }
    }];
}

#pragma mark - 屏幕开始摇动
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    self.img_letter.hidden=YES;
    self.btn_Record.hidden=YES;
}
#pragma mark - 屏幕结束摇动
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    self.girlImg.userInteractionEnabled=YES;
    [self.recordManager stopRecording];
    for (CALayer *layer in self.rotationLayers) {
        [layer removeFromSuperlayer];
    }
    [self shakeView:self.imageForShake];
    
}

#pragma mark - 摇出东西
-(void)plusTapHandle
{
    CGPoint startPoint=self.imageForShake.center;
    CGPoint endPoint=self.girlImg.center;
    
    recordFile=[NSArray arrayWithArray:[self.recordManager recorderList]];
    textFile=[self.textFileManager readFile:@"arrForTextSave"];
    
    int num=arc4random()%2;
    
    if (textFile.count!=0&&recordFile.count!=0)
    {
        if (num==0) {
            CALayer *chlayer=[self.animationManager layerFromPoint:startPoint toPoint:endPoint withImage:@"envelope" addToView:self.view];
            [self.redLayers addObject:chlayer];
        }
        else
        {
            CALayer *chlayer=[self.animationManager layerFromPoint:startPoint toPoint:endPoint withImage:@"cidai" addToView:self.view];
            [self.redLayers addObject:chlayer];
        }
    }
    
    else if (textFile.count!=0&&recordFile.count==0)
    {
        CALayer *chlayer=[self.animationManager layerFromPoint:startPoint toPoint:endPoint withImage:@"envelope" addToView:self.view];
        [self.redLayers addObject:chlayer];
    }
    else if (recordFile.count!=0&&textFile.count==0)
    {
        CALayer *chlayer=[self.animationManager layerFromPoint:startPoint toPoint:endPoint withImage:@"cidai" addToView:self.view];
        [self.redLayers addObject:chlayer];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"小盒里是空的 (｡˘•ε•˘｡)" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
    [self.view bringSubviewToFront:self.girlImg];
    [self.girlImg addGestureRecognizer:tap];
    value_choice=num;
}


-(BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - 点击右下角女孩
-(void)touchDownGirl
{
    
    
    if (textFile.count!=0&&recordFile.count!=0) {
        if (value_choice==1) {
            self.btn_Record.hidden=NO;
            [self readContent];
        }
        else
        {
            [self showLetters];
        }
    }
    
    else if (textFile.count!=0&&recordFile.count==0)
    {
        [self showLetters];
    }
    else if (recordFile.count!=0&&textFile.count==0)
    {
        self.btn_Record.hidden=NO;
        [self readContent];
    }
    else
    {
        
        UIAlertController *alertLength = [UIAlertController alertControllerWithTitle:@"提示" message:@"小盒里是空的~" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *suer = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertLength addAction:suer];
        [self presentViewController:alertLength animated:YES completion:nil];
    }
}

#pragma mark - 阅读或听
-(void)readContent
{
    
    int num_random=arc4random()%recordFile.count;
    
    self.recordFileName=recordFile[num_random];
}

-(void)showLetters
{
    self.girlImg.userInteractionEnabled=NO;

    self.btn_Read.hidden=YES;
    UIImageView *img_letter=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"letter"]];
    [self.view addSubview:img_letter];
    [img_letter makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.top.equalTo(self.imageForShake.bottom).offset(5);
        make.height.equalTo(img_letter.width).multipliedBy(2/3.0);
    }];
    img_letter.frame = CGRectMake(0, 0, 300, 200);
    img_letter.center=CGPointMake(self.view.center.x, self.view.center.y-150);
    img_letter.layer.cornerRadius = 8;
    img_letter.layer.masksToBounds = YES;
    //自适应图片宽高比例
    img_letter.contentMode = UIViewContentModeScaleAspectFit;
    
    self.img_letter=img_letter;
    
    int num=arc4random()%textFile.count;
    self.letter.text=textFile[num];
    [self.img_letter addSubview:self.letter];
}

#pragma mark - 展示留声机碟片
-(void)showRecording
{
    self.girlImg.userInteractionEnabled=NO;
    self.btn_Record.hidden=YES;
    [self.rotationLayers addObject:[self.animationManager createCenterRotationImage:@"liushengji" addToView:self.view]];
    [self.recordManager playRecording:self.recordFileName];
}

#pragma mark - 展示菜单
-(void)showMenu
{
    [self.recordManager stopRecording];
    [self.view sendSubviewToBack:self.btn_Record];
    for (CALayer *layer in self.redLayers) {
        [layer removeFromSuperlayer];
    }
    for (CALayer *layer in self.rotationLayers) {
        [layer removeFromSuperlayer];
    }
    [self presentView];
    [self.view sendSubviewToBack:self.girlImg];
    [self.view sendSubviewToBack:self.img_letter];
    [self.view sendSubviewToBack:self.back_img];


}

#pragma mark - 设置navigationBar的颜色
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"background"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
