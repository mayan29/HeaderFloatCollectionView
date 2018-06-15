//
//  UICollectionHeaderView.m
//  HeaderFloatCollectionView
//
//  Created by mayan on 2018/6/8.
//  Copyright © 2018年 mayan. All rights reserved.
//

#import "UICollectionHeaderView.h"

@interface CustomLayer: CALayer

@end

@implementation CustomLayer

- (CGFloat)zPosition {
    
    // 系统版本大于 iOS 11 header 会挡住滚动条
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 11.0) {
        return 0;
    } else {
        return [super zPosition];
    }
}

@end


@implementation UICollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, (frame.size.width - 20) / 2, frame.size.height)];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.userInteractionEnabled = YES;
        [self addSubview:_textLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTouchClick)];
        [_textLabel addGestureRecognizer:tap];
    }
    return self;
}

- (void)headerTouchClick {
    if (self.headerTouchBlock) {
        self.headerTouchBlock();
    }
}

+ (Class)layerClass {
    return [CustomLayer class];
}


@end
