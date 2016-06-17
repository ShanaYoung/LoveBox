//
//  DeleteLetterViewController.m
//  恋爱储蓄
//
//  Copyright © 2016年 Shana. All rights reserved.
//

#import "DeleteLetterViewController.h"
#import "TextFileManager.h"

@interface DeleteLetterViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UITableView *myTableView;
}
@end

@implementation DeleteLetterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createView
{
    myTableView=[[UITableView alloc] init];
    myTableView.frame=self.view.frame;
    myTableView.dataSource=self;
    myTableView.delegate=self;
    [self.view addSubview:myTableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text=@"清除所有小纸条";
    cell.textLabel.textColor=[UIColor redColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"确定删除所有小纸条?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除全部" otherButtonTitles:nil, nil];
    
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [TextFileManager clearCaches];
    }
}

@end
