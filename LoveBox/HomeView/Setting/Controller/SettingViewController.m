//
//  SettingViewController.m
//  
//
//  Copyright © 2016年 Shana. All rights reserved.
//

#import "SettingViewController.h"
#import "DeleteRecording.h"
#import "DeleteRecordingViewController.h"
#import "DeleteLetterViewController.h"
#import "ShowUsageViewController.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *settingTable;
    
}
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createChildVC];
    [self createNavigationDetails];
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

-(void)createChildVC
{
    DeleteRecordingViewController *drvc=[[DeleteRecordingViewController alloc] init];
    [self addChildViewController:drvc];
    
}

-(void)createUI
{
    settingTable=[[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    settingTable.delegate=self;
    settingTable.dataSource=self;
    [self.view addSubview:settingTable];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"settingCell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingCell"];
    }
    
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text=@"本地音频文件管理";
            break;
        case 1:
            cell.textLabel.text=@"本地文本文件管理";
            break;
        case 2:
            cell.textLabel.text=@"使用介绍";
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#warning 设置点击跳转
    switch (indexPath.row)
    {
        case 0:
            [self.navigationController pushViewController:[[DeleteRecordingViewController alloc] init] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[[DeleteLetterViewController alloc] init] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[[ShowUsageViewController alloc] init] animated:YES];
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
