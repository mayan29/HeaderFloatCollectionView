//
//  MYHeaderFloatFlowLayout.m
//  HeaderFloatCollectionView
//
//  Created by mayan on 2018/6/8.
//  Copyright © 2018年 mayan. All rights reserved.
//  https://github.com/mayan29/HeaderFloatCollectionView

#import "MYHeaderFloatFlowLayout.h"

@implementation MYHeaderFloatFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navBarHeight = 64.f;
    }
    return self;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    // 返回指定区域的 cell、header、footer 结构信息
    NSMutableArray *superArray = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    NSMutableIndexSet *missingSections = [NSMutableIndexSet indexSet];
    
    // 遍历 superArray 将当前屏幕中 cell 的 section 添加到 missingSections 数组中
    for (UICollectionViewLayoutAttributes *attributes in superArray) {
        if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
            [missingSections addIndex:attributes.indexPath.section];
        }
    }
    // 再次遍历 superArray 将当前屏幕中显示 header 的 section 从 missingSections 数组中移除
    for (UICollectionViewLayoutAttributes *attributes in superArray) {
        if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [missingSections removeIndex:attributes.indexPath.section];
        }
    }
    
    // 遍历 missingSections 将已经离开屏幕的 header 结构信息再次添加到 superArray 中
    [missingSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [superArray addObject:attributes];
    }];
    
    // 遍历 superArray 设置其中的 header 结构信息 frame
    for (UICollectionViewLayoutAttributes *attributes in superArray) {
        if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
           
            NSInteger section = attributes.indexPath.section;
            NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
            
            NSIndexPath *firstItemIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            NSIndexPath *lastItemIndexPath = [NSIndexPath indexPathForItem:MAX(0, numberOfItemsInSection - 1) inSection:section];
            
            // 如果该 section 中存在 items，获取第一个 item 和最后一个 item 的结构信息
            // 如果该 section 中没有 items，获取该 section 的 header 和 footer
            UICollectionViewLayoutAttributes *firstItemAttrs;
            UICollectionViewLayoutAttributes *lastItemAttrs;
            if (numberOfItemsInSection > 0) {
                firstItemAttrs = [self layoutAttributesForItemAtIndexPath:firstItemIndexPath];
                lastItemAttrs = [self layoutAttributesForItemAtIndexPath:lastItemIndexPath];
            } else {
                firstItemAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:firstItemIndexPath];
                lastItemAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:lastItemIndexPath];
            }
            
            CGRect frame = attributes.frame;
            
            if (numberOfItemsInSection > 0) {
                frame.origin.y = MAX(self.collectionView.contentOffset.y + self.navBarHeight + self.collectionView.contentInset.top, CGRectGetMinY(firstItemAttrs.frame) - frame.size.height);
                frame.origin.y = MIN(frame.origin.y, CGRectGetMaxY(lastItemAttrs.frame) - frame.size.height);
            } else {
                frame.origin.y = MAX(self.collectionView.contentOffset.y + self.navBarHeight + self.collectionView.contentInset.top, CGRectGetMinY(firstItemAttrs.frame));
                frame.origin.y = MIN(frame.origin.y, CGRectGetMaxY(lastItemAttrs.frame));
            }
            
            attributes.frame = frame;
        }
    }
    
    return [superArray copy];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}

@end
