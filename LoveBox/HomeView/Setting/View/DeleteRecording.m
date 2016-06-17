//
//  DeleteRecording.m
//  恋爱储蓄
//
//  Copyright © 2016年 Shana. All rights reserved.
//

#import "DeleteRecording.h"
#import "RecordManager.h"

@interface DeleteRecording ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UITableView *myTableView;
}
@end

@implementation DeleteRecording

-(UIView *)view
{
    myTableView.frame=[UIScreen mainScreen].bounds;
    myTableView.dataSource=self;
    myTableView.delegate=self;
    [self addSubview:myTableView];
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc] init];
    cell.textLabel.text=@"删除所有录音数据";
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"确定删除所有录音?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除全部" otherButtonTitles:nil, nil];
    
    [sheet showInView:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        
        
    }
}

@end
