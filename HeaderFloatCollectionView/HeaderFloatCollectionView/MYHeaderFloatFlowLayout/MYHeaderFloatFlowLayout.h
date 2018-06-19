//
//  MYHeaderFloatFlowLayout.h
//  HeaderFloatCollectionView
//
//  Created by mayan on 2018/6/8.
//  Copyright © 2018年 mayan. All rights reserved.
//  https://github.com/mayan29/HeaderFloatCollectionView

#import <UIKit/UIKit.h>

@interface MYHeaderFloatFlowLayout : UICollectionViewFlowLayout

// 默认为 64，iPhone X 需要自己适配
@property (nonatomic, assign) CGFloat navBarHeight;

@end
