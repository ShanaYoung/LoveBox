//
//  EditViewController.m
//  恋爱储蓄
//
//  Copyright © 2016年 Shana. All rights reserved.
//

#import "EditViewController.h"
#import "PlaceholderTextView.h"
#define kTextBorderColor     RGBCOLOR(227,224,216)
#undef  RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define   SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define   SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define MAX_INPUT_LENGTH 200
#import "TextFileManager.h"

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"

@interface EditViewController ()<UITextViewDelegate>

@property (nonatomic, strong) PlaceholderTextView * textView;

@property (nonatomic, strong) UIButton * sendButton;

@property (nonatomic, strong) UIView * aView;

@property (nonatomic, strong)UITextField *textField;

@property(nonatomic,strong)UIImageView *imgView;

@property(nonatomic,strong)TextFileManager *textManager;

@property(nonatomic,strong)NSMutableArray *arrForTextSave;

//字数的限制
@property (nonatomic, strong)UILabel *wordCountLabel;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self.aView layoutIfNeeded];
    
    self.textManager=[[TextFileManager alloc] init];
    self.arrForTextSave=[[NSMutableArray alloc] init];
    
    [self createNavigationDetails];
}

-(void)createUI
{
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255 green:251.0/255 blue:198.0/255 alpha:1.0f];
    UIImageView *img_background=[[UIImageView alloc] initWithFrame:self.view.frame];
    img_background.image=[UIImage imageNamed:@"background-1"];
    [self.view addSubview:img_background];
    
    self.aView = [[UIView alloc]init];
    _aView.backgroundColor = [UIColor colorWithRed:176.0/255 green:172.0/255 blue:84.0/255 alpha:1.0f];
    [self.view addSubview:_aView];
    [_aView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(30);
        make.width.equalTo(self.view).offset(-40);
        make.height.equalTo(260);
    }];
    _aView.layer.cornerRadius=10;
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_sendButton];
    [_sendButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.bottom.equalTo(self.view).offset(-30);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(40);
    }];
    _sendButton.layer.cornerRadius = 2.0f;
    
    _sendButton.backgroundColor = [UIColor colorWithRed:210.0/255 green:151.0/255 blue:0 alpha:1.0f];
    [_sendButton setTitle:@"写进小盒" forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(sendFeedBack) forControlEvents:UIControlEventTouchUpInside];
    
    _imgView=[[UIImageView alloc] init];
    _imgView.image=[UIImage imageNamed:@"装饰2"];
    [self.aView addSubview:self.imgView];
    [_imgView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(50);
        make.height.equalTo(140);
        make.bottom.equalTo(_sendButton.top).offset(-5);
        make.centerX.equalTo(self.view);
    }];
    
    _textView=[[PlaceholderTextView alloc] init];
    [_aView addSubview:self.textView];
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.aView);
        make.top.equalTo(self.aView);
        make.right.equalTo(self.aView);
        make.height.equalTo(200);
    }];
    
    _textView.backgroundColor = [UIColor colorWithRed:243.0/255 green:216.0/255 blue:161.0/255 alpha:1.0f];
    _textView.delegate = self;
    _textField.font = [UIFont fontWithName:@"Party LET" size:20.0f];
    _textField.borderStyle=UITextBorderStyleRoundedRect;
    _textView.textColor = [UIColor colorWithRed:176.0/255 green:172.0/255 blue:84.0/255 alpha:1.0f];
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.editable = YES;
    _textView.layer.cornerRadius = 4.0f;
    _textView.layer.borderColor = kTextBorderColor.CGColor;
    _textView.layer.borderWidth = 0.5;
    _textView.placeholderColor = [UIColor colorWithRed:176.0/255 green:172.0/255 blue:84.0/255 alpha:1.0f];
    _textView.placeholder = @"请记录点点滴滴吧~";
    
    self.wordCountLabel=[[UILabel alloc] init];
    _wordCountLabel.font = [UIFont systemFontOfSize:14.f];
    _wordCountLabel.textColor = [UIColor lightGrayColor];
    self.wordCountLabel.text=[NSString stringWithFormat:@"0/%d",MAX_INPUT_LENGTH];
    self.wordCountLabel.backgroundColor = [UIColor whiteColor];
    self.wordCountLabel.textAlignment = NSTextAlignmentRight;
    //    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(self.textView.frame.origin.x + 20,  self.textView.frame.size.height + 84 - 1 + 23, [UIScreen mainScreen].bounds.size.width - 40, 1)];
    UIView *lineView=[[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(1);
        make.width.equalTo(self.aView);
        make.left.equalTo(self.aView);
        make.bottom.equalTo(self.aView.bottom).offset(-60);
    }];
    
    [self.view addSubview:_wordCountLabel];
    [_wordCountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.aView);
        make.top.equalTo(lineView.bottom).offset(3);
        make.width.equalTo(self.aView);
        make.height.equalTo(20);
    }];
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


- (void)sendFeedBack{
    if (self.textView.text.length == 0) {
        
        UIAlertController *alertLength = [UIAlertController alertControllerWithTitle:@"提示" message:@"什么也没有写哦" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *suer = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertLength addAction:suer];
        [self presentViewController:alertLength animated:YES completion:nil];
    }
    else
    {
        [self saveToLoveBox];
        [self showMessage:@"已经存进小盒"];
    }
}

#pragma mark - 执行文件存储操作
-(void)saveToLoveBox
{
    self.arrForTextSave=[self.textManager readFile:@"arrForTextSave"];
    [self.arrForTextSave addObject:self.textView.text];
    [self.textManager save:self.arrForTextSave saveAsName:@"arrForTextSave"];
}

-(void)showMessage:(NSString *)message
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    showview.center = self.view.center;
    showview.bounds = CGRectMake(0, 0, SCREEN_WIDTH*0.423, SCREEN_WIDTH*0.423);
    [window addSubview:showview];
    
    
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(0.35*showview.bounds.size.width, 0.226*showview.bounds.size.width, 0.296*showview.bounds.size.width, 0.283*showview.bounds.size.height);
    imageView.image = [UIImage imageNamed:@"icon_gift"];
    [showview addSubview:imageView];
    
    UILabel *expLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, showview.bounds.size.width-50, showview.bounds.size.width, 30)];
    expLabel.text = [NSString stringWithFormat:@"%@",message];
    expLabel.textAlignment = NSTextAlignmentCenter;
    expLabel.textColor = [UIColor whiteColor];
    [showview addSubview:expLabel];
    
    [UIView animateWithDuration:2.0f animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger wordCount = textView.text.length;
    self.wordCountLabel.text = [NSString stringWithFormat:@"%ld/%d",(long)wordCount,MAX_INPUT_LENGTH];
}

#pragma mark 超过300字不能输入
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text] == YES)
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    if ([text isEqualToString:@""] && range.length > 0)
    {
        return YES;
    }
    
    else
    {
        if (textView.text.length - range.length + text.length > MAX_INPUT_LENGTH)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"纸条内容太长啦" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        else
        {
            return YES;
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
    [_textField resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backgroundEditTitle"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
