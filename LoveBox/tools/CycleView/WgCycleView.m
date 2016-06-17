//
//  WgCycleView.m
//  无限轮播
//
//  Created by mac on 16/4/17.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "WgCycleView.h"
#import "WgCollectionViewFlowLayout.h"
#import "WgCell.h"
static NSString *WgCycleViewIdentifier = @"WgCycleView";
@interface WgCycleView()<UICollectionViewDataSource,UICollectionViewDelegate>


@end

@implementation WgCycleView

- (instancetype)init
{

    self = [super initWithFrame:CGRectZero collectionViewLayout:[[WgCollectionViewFlowLayout alloc] init]];
    if (self) {

        [self registerClass:[WgCell class] forCellWithReuseIdentifier:WgCycleViewIdentifier];

        self.dataSource = self;
        self.delegate = self;

        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;

        self.bounces = NO;
        self.pagingEnabled = YES;


        dispatch_async(dispatch_get_main_queue(), ^{

            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.imageUrls.count inSection:0];

            [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        });

    }

    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.imageUrls.count*100;

}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    WgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WgCycleViewIdentifier forIndexPath:indexPath];

    cell.imagUrl = self.imageUrls[indexPath.item%self.imageUrls.count];

    return cell;
}




-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    NSInteger item = scrollView.contentOffset.x/self.bounds.size.width;


    if (item==0||item==self.imageUrls.count*100-1) {

        if (item==0) {

                item = self.imageUrls.count;

            }else{

                item = self.imageUrls.count-1;
        }

        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];

    }
}











@end
