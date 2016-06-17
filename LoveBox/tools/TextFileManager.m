//
//  TextFileManager.m
//  恋爱储蓄
//
//  Copyright © 2016年 Shana. All rights reserved.
//

#import "TextFileManager.h"

@interface TextFileManager ()

@end

@implementation TextFileManager

-(void)save:(NSArray *)arrFile saveAsName:(NSString *)fileName// toFile:(NSString *)filePath
{
    NSString *cachePth=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    NSString *file_name=[NSString stringWithFormat:@"%@.plist",fileName];
    
    //拼接文件名
    NSString *file_path=[cachePth stringByAppendingPathComponent:file_name];
    if ([[NSFileManager defaultManager] fileExistsAtPath:file_path] == false) {
        [[NSFileManager defaultManager] createFileAtPath:file_path contents:nil attributes:nil];
    }
    
    [arrFile writeToFile:file_path atomically:YES];
}


-(NSArray *)readFile:(NSString *)fileName
{
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //  在这里,我们指定搜索的是Cache目录,所以结果只有一个,取出Cache目录
    
    NSString *cachePath = array[0];
    // 拼接文件路径
    NSString *file_name=[NSString stringWithFormat:@"%@.plist",fileName];
    
    NSString *filePathName = [cachePath stringByAppendingPathComponent:file_name];
    
//    // 从文件当中读取字典, 保存的plist文件就是一个字典,这里直接填写plist文件所存的路径
//    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePathName];
    
    // 如果保存的是一个数组.那就通过数组从文件当中加载.
//    NSArray *dataArray = [NSArray arrayWithContentsOfFile:filePathName];
    NSMutableArray *dataArray=[[NSMutableArray alloc] initWithArray:[NSArray arrayWithContentsOfFile:filePathName]];
    return dataArray;
}

+(void)clearCaches
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    //NSFileManager文件操作的一个类
    NSFileManager *manager = [NSFileManager defaultManager];
    //获得当前文件的所有子文件:subpathsAtPath:
    NSArray *pathList = [manager subpathsAtPath:path];
    //需要只获得录音文件
    //遍历这个文件夹下面的子文件
    int index=0;
    for (NSString *letterPath in pathList) {
        //通过对比文件的延展名（扩展名、尾缀）来区分是不是录音文件
        if ([letterPath.pathExtension isEqualToString:@"plist"]) {
            //把筛选出来的文件放到数组中 -> 得到所有的音频文件
            NSString *delePath= [path stringByAppendingPathComponent:letterPath];
            [manager removeItemAtPath:delePath error:nil];
            index++;
        }
    }
    if (index==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有小纸条信息噢" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}



+(void)createFolder:(NSString*)path
{
    BOOL isDir = NO;
    
    NSFileManager *fileManger = [NSFileManager defaultManager];
    
    BOOL existed = [fileManger fileExistsAtPath:path isDirectory:&isDir];
    
    if (!(isDir == YES  && existed == YES)) {
        
        [fileManger createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

@end
