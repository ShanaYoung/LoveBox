//
//  RecordManager.m
//  恋爱储蓄
//
//  Created by qianfeng on 16/5/10.
//  Copyright © 2016年 Shana. All rights reserved.
//

#import "RecordManager.h"
#import <AVFoundation/AVFoundation.h>

@interface RecordManager ()<AVAudioRecorderDelegate>
{
    
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer *audioPlayer;
}
@end

@implementation RecordManager

-(void)startRecording
{
    [self startAudioRecorder];
    [audioRecorder record];
}

-(void)endRecording
{
    [audioRecorder stop];
}

-(void)startAudioRecorder{
    
    /*
     URL：是本地的URL 是AVAudioRecorder 需要一个存储的路径
     */
    
    NSString *name =[NSString stringWithFormat:@"%d.aiff",(int)[NSDate date].timeIntervalSince1970];
    NSString *path = [[ NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES) firstObject] stringByAppendingPathComponent:name];
    NSError *error;
    //初始化
    /**
     AVNumberOfChannelsKey:声道数 通常为双声道 值2
     AVSampleRateKey：采样率 单位是HZ 通常设置成44100 44.1k
     AVLinearPCMBitDepthKey：比特率  8 16 32
     AVEncoderAudioQualityKey：声音质量 需要的参数是一个枚举 ：
     AVAudioQualityMin    最小的质量
     AVAudioQualityLow    比较低的质量
     AVAudioQualityMedium 中间的质量
     AVAudioQualityHigh   高的质量
     AVAudioQualityMax    最好的质量
     AVEncoderBitRateKey：音频的编码比特率 BPS传输速率 一般为128000bps
     */
    
    NSError *error1 = nil;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error1];
    [session setActive:YES error:nil];
    
    audioRecorder = [[AVAudioRecorder alloc]initWithURL:[NSURL fileURLWithPath:path] settings:@{AVNumberOfChannelsKey:@2,AVSampleRateKey:@44100,AVLinearPCMBitDepthKey:@32,AVEncoderAudioQualityKey:@(AVAudioQualityMax),AVEncoderBitRateKey:@128000} error:&error];
    audioRecorder.delegate = self;
    [audioRecorder prepareToRecord];
    
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    //NSFileManager文件操作的一个类
    NSFileManager *manager = [NSFileManager defaultManager];
    //获得当前文件的所有子文件:subpathsAtPath:
    NSArray *pathList = [manager subpathsAtPath:path];
    //需要只获得录音文件
    NSMutableArray *audioPathList = [NSMutableArray array];
    //遍历这个文件夹下面的子文件
    for (NSString *audioPath in pathList) {
        //通过对比文件的延展名（扩展名、尾缀）来区分是不是录音文件
        if ([audioPath.pathExtension isEqualToString:@"aiff"]) {
            //把筛选出来的文件放到数组中 -> 得到所有的音频文件
            [audioPathList addObject:audioPath];
        }
    }
}

-(NSArray *)recorderList
{
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    //NSFileManager文件操作的一个类
    NSFileManager *manager = [NSFileManager defaultManager];
    //获得当前文件的所有子文件:subpathsAtPath:
    NSArray *pathList = [manager subpathsAtPath:path]
    ;

    //需要只获得录音文件
    NSMutableArray *audioPathList = [NSMutableArray array];
    //遍历这个文件夹下面的子文件
    for (NSString *audioPath in pathList) {
        //通过对比文件的延展名（扩展名、尾缀）来区分是不是录音文件
        if ([audioPath.pathExtension isEqualToString:@"aiff"]) {
            //把筛选出来的文件放到数组中 -> 得到所有的音频文件
            [audioPathList addObject:audioPath];
        }
    }
    
    return audioPathList;
}

-(void)playRecording:(NSString *)recordName
{
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pathStr=[path stringByAppendingPathComponent:recordName];
    audioPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:pathStr] error:nil];
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    
}

-(void)stopRecording
{
    [audioPlayer stop];
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
        for (NSString *audioPath in pathList) {
            //通过对比文件的延展名（扩展名、尾缀）来区分是不是录音文件
            if ([audioPath.pathExtension isEqualToString:@"aiff"]) {
                //把筛选出来的文件放到数组中 -> 得到所有的音频文件
                NSString *delePath= [path stringByAppendingPathComponent:audioPath];
                [manager removeItemAtPath:delePath error:nil];
                index++;
            }
        }
    if (index==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有录音信息噢" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

@end
