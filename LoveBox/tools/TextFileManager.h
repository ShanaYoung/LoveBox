//
//  TextFileManager.h
//  恋爱储蓄
//
//  Created by qianfeng on 16/5/13.
//  Copyright © 2016年 Shana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFileManager : NSObject

-(void)save:(NSArray *)arrFile saveAsName:(NSString *)fileName;
-(NSArray *)readFile:(NSString *)fileName;
+(void)clearCaches;
@end
