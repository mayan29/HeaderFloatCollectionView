//
//  ViewController.m
//  HeaderFloatCollectionView
//
//  Created by mayan on 2018/6/8.
//  Copyright © 2018年 mayan. All rights reserved.
//

#import "ViewController.h"
#import "UICollectionHeaderView.h"
#import "MYHeaderFloatFlowLayout.h"

#define ScreenWidth     self.view.bounds.size.width
#define RGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:0.5]
#define RandomColor     RGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *foldSectionArray;

@end

@implementation ViewController

static NSString *const kCellID   = @"cellID";
static NSString *const kHeaderID = @"headerID";


#pragma mark - Init

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MYHeaderFloatFlowLayout *layout = [[MYHeaderFloatFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(ScreenWidth / 4, ScreenWidth / 4);
    layout.headerReferenceSize = CGSizeMake(ScreenWidth, 50);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellID];
    [collectionView registerClass:[UICollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderID];
}


#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 20;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.foldSectionArray containsObject:@(section)] ? 0 : 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    cell.backgroundColor = RandomColor;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self)wself = self;
    __weak typeof(collectionView)wcollectionView = collectionView;

    // 如果是头部视图
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderID forIndexPath:indexPath];
        headerView.textLabel.text = [NSString stringWithFormat:@"第 %ld 个 section", (long)indexPath.section];
        headerView.backgroundColor = [UIColor whiteColor];
        headerView.headerTouchBlock = ^{
            
            // header 点击收起、展开
            if ([wself.foldSectionArray containsObject:@(indexPath.section)]) {
                [wself.foldSectionArray removeObject:@(indexPath.section)];
            } else {
                [wself.foldSectionArray addObject:@(indexPath.section)];
            }
            
            [wcollectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
        };
        return headerView;
    } else {
        return nil;
    }
}


#pragma mark - Lazy Load

- (NSMutableArray *)foldSectionArray {
    if (!_foldSectionArray) {
        _foldSectionArray = [NSMutableArray array];
    }
    return _foldSectionArray;
}


@end
