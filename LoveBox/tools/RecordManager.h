//
//  RecordManager.h
//  恋爱储蓄
//
//  Created by qianfeng on 16/5/10.
//  Copyright © 2016年 Shana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordManager : NSObject

/** 开始录音 */
-(void)startRecording;
/** 结束录音 */
-(void)endRecording;
/** 取得录音数组 */
-(NSArray *)recorderList;
/** 播放录音 */
-(void)playRecording:(NSString *)recordName;
/** 结束播放 */
-(void)stopRecording;
/** 清除缓存 */
+(void)clearCaches;

@end
