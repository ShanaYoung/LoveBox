//
//  WgCollectionViewFlowLayout.m
//  无限轮播
//
//  Created by mac on 16/4/17.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "WgCollectionViewFlowLayout.h"

@implementation WgCollectionViewFlowLayout


-(void)prepareLayout{

    [super prepareLayout];

    self.itemSize = self.collectionView.bounds.size;

    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;

    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    ;

}

@end
