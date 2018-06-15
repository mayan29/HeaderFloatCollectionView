//
//  UICollectionHeaderView.h
//  HeaderFloatCollectionView
//
//  Created by mayan on 2018/6/8.
//  Copyright © 2018年 mayan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionHeaderView : UICollectionReusableView

@property (nonatomic, readonly, strong) UILabel *textLabel;
@property (nonatomic, copy) void (^headerTouchBlock)(void);

@end
