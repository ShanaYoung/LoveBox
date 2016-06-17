//
//  PopMenu.h
//  恋爱储蓄
//
//  Copyright © 2016年 Shana. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopMenuDelegate <NSObject>

@required
-(void)didClickMenu:(NSInteger)index;

@end

@interface PopMenu : UIView

@property (nonatomic,strong)UIButton * editButton;
@property (nonatomic,strong)UIButton * recordButton;
@property (nonatomic,strong)UIView   * backgroundView;

/** 设置按钮 */
@property(strong,nonatomic)UIButton *settingButton;


@property (nonatomic,strong)NSMutableArray  * centerHigh;
@property (nonatomic,strong)NSMutableArray  * centerLow;
@property (nonatomic,strong)NSMutableArray  * centerMenu;
@property (nonatomic,assign)BOOL              isHidding ;
@property (nonatomic,assign) id<PopMenuDelegate> delegate;

-(void)showMenuView;

@end
