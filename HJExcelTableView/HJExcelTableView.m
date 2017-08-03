//
//  HJExcelTableView.m
//  HJExcelTableView
//
//  Created by JefferyHe on 2017/7/26.
//  Copyright © 2017 JefferyHe. All rights reserved.
//

#import "HJExcelTableView.h"
#import "HJExcelTableViewCell.h"
#import "HJExcelTableViewLayout.h"

// 滚动的方向
typedef NS_ENUM(NSUInteger, Direction) {
    DirectionNone,// 未知方向
    DirectionVertical,// 垂直方向
    DirectionHorizontal// 水平方向
};

@interface HJExcelTableView () <UICollectionViewDataSource,
    UICollectionViewDelegate,
    HJExcelTableViewLayoutDelegate
>

/*!
 @property
 @abstract HJExcelTableViewLayout
 */
@property (nonatomic, strong) HJExcelTableViewLayout *excelTableViewLayout;

/*!
 @property
 @abstract 滚动开始点的坐标，用于解决能垂直和水平两个方向同时滚动的问题
 */
@property (nonatomic, assign) CGPoint collectionViewStartPoint;

/*!
 @property
 @abstract 滚动的方向，用于解决能垂直和水平两个方向同时滚动的问题
 */
@property (nonatomic, assign) Direction collectionViewDirection;

@end

@implementation HJExcelTableView

#pragma mark - Init
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.frame;
}

- (HJExcelTableViewLayout *)excelTableViewLayout {
    if (!_excelTableViewLayout) {
        _excelTableViewLayout = [[HJExcelTableViewLayout alloc] init];
        _excelTableViewLayout.delegate = self;
    }
    return _excelTableViewLayout;
}

- (void)setup {
    self.column = 1;
    self.rowSpacing = 1.0f / [UIScreen mainScreen].scale;
    self.columnSpacing = 0.0f / [UIScreen mainScreen].scale;
    self.sectionSpacing = 1.0f / [UIScreen mainScreen].scale;
    self.showsVerticalScrollIndicator = YES;
    self.showsHorizontalScrollIndicator = YES;
    self.bounces = YES;
    self.isMultiDirectionScroll = NO;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.excelTableViewLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = self.showsVerticalScrollIndicator;
    collectionView.showsHorizontalScrollIndicator = self.showsVerticalScrollIndicator;
    collectionView.bounces = self.bounces;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.directionalLockEnabled = YES;
    [self addSubview:collectionView];
    _collectionView = collectionView;
}

#pragma mark - Getter/Setter
- (void)setShowsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator {
    _showsVerticalScrollIndicator = showsVerticalScrollIndicator;
    self.collectionView.showsVerticalScrollIndicator = showsVerticalScrollIndicator;
}

- (void)setShowsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator {
    _showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
    self.collectionView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
}

- (void)setBounces:(BOOL)bounces {
    _bounces = bounces;
    self.collectionView.bounces = bounces;
}

- (void)setTableHeaderView:(HJExcelHeadView *)tableHeaderView {
    _tableHeaderView = tableHeaderView;
    if (tableHeaderView) {
        tableHeaderView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableHeaderView.frame), CGRectGetHeight(tableHeaderView.frame));
        [self.collectionView addSubview:tableHeaderView];
        self.excelTableViewLayout.hasTableHeaderView = YES;
    }
}

- (void)setEnableStickTableHeaderView:(BOOL)enableStickTableHeaderView {
    _enableStickTableHeaderView = enableStickTableHeaderView;
    self.excelTableViewLayout.enableStickTableHeaderView = enableStickTableHeaderView;
}

- (void)setHeaderViewHeightOfSection:(CGFloat)headerViewHeightOfSection {
    _headerViewHeightOfSection = headerViewHeightOfSection;
    self.excelTableViewLayout.sectionHeaderViewHeight = self.headerViewHeightOfSection;
}

- (void)setFooterViewHeightOfSection:(CGFloat)footerViewHeightOfSection {
    _footerViewHeightOfSection = footerViewHeightOfSection;
    self.excelTableViewLayout.sectionFooterViewHeight = self.footerViewHeightOfSection;
}

#pragma mark - Public Method
- (HJExcelTableViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (HJExcelReusableView *)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind
                                            withReuseIdentifier:(NSString *)identifier
                                                   forIndexPath:(NSIndexPath *)indexPath {
    return [self.collectionView dequeueReusableSupplementaryViewOfKind:elementKind withReuseIdentifier:identifier forIndexPath:indexPath];
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier {
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
}

- (void)registerClass:(Class)viewClass forSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier {
    [self.collectionView registerClass:viewClass forSupplementaryViewOfKind:elementKind withReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)nib forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier {
    [self.collectionView registerNib:nib forSupplementaryViewOfKind:kind withReuseIdentifier:identifier];
}

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInExcelTableView:)]) {
        return [self.dataSource numberOfSectionsInExcelTableView:self];
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource excelTableView:self numberOfItemInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger totalColumn = [self excelTableViewLayout:self.excelTableViewLayout columnWidthsInSection:indexPath.section].count;
    NSInteger itemColumn = indexPath.item % totalColumn;
    NSInteger itemRow = indexPath.item / totalColumn;
    return [self.dataSource excelTableView:self cellForItemAtIndexPath:indexPath itemAtRow:itemRow itemAtColumn:itemColumn];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if ( [kind isEqualToString:UICollectionElementKindSectionHeader] ) {
        if ([self.dataSource respondsToSelector:@selector(excelTableView:viewForHeaderAtIndexPath:)]) {
            return [self.dataSource excelTableView:self viewForHeaderAtIndexPath:indexPath];
        }
        
    } else if( [kind isEqualToString:UICollectionElementKindSectionFooter] ) {
        if ([self.dataSource respondsToSelector:@selector(excelTableView:viewForFooterAtIndexPath:)]) {
            return [self.dataSource excelTableView:self viewForFooterAtIndexPath:indexPath];
        }
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(excelTableView:cellForItemAtIndexPath:itemAtRow:itemAtColumn:)]) {
        NSInteger totalColumn = [self excelTableViewLayout:self.excelTableViewLayout columnWidthsInSection:indexPath.section].count;
        NSInteger itemColumn = indexPath.item % totalColumn;
        NSInteger itemRow = indexPath.item / totalColumn;
        [self.delegate excelTableView:self didSelectItemAtIndexPath:indexPath itemAtRow:itemRow itemAtColumn:itemColumn];
    }
}

#pragma mark - HJExcelTableViewLayoutDelegate
- (NSInteger)columnOfExcelTableViewLayout:(HJExcelTableViewLayout *)excelTableViewLayout inSection:(NSInteger)section {
    return self.column;
}

- (CGFloat)rowSpacingOfExcelTableViewLayout:(HJExcelTableViewLayout *)excelTableViewLayout {
    return self.rowSpacing;
}

- (CGFloat)columnSpacingOfExcelTableViewLayout:(HJExcelTableViewLayout *)excelTableViewLayout {
    return self.columnSpacing;
}

- (CGFloat)sectionSpacingOfExcelTableViewLayout:(HJExcelTableViewLayout *)excelTableViewLayout {
    return self.sectionSpacing;
}

- (NSArray<NSNumber *> *)excelTableViewLayout:(HJExcelTableViewLayout *)excelTableViewLayout columnWidthsInSection:(NSInteger)section {
    return [self.dataSource excelTableView:self columnWidthsInSection:section];
}

- (CGFloat)excelTableViewLayout:(HJExcelTableViewLayout *)excelTableViewLayout rowHeightInSection:(NSInteger)section {
    return [self.dataSource excelTableView:self rowHeightInSection:section];
}

- (NSInteger)numberOfStickColumnExcelTableViewLayout:(HJExcelTableViewLayout *)excelTableViewLayout {
    if ([self.dataSource respondsToSelector:@selector(numberOfStickColumnExcelTableView:)]) {
        return [self.dataSource numberOfStickColumnExcelTableView:self];
    }
    return 0;
}
- (NSInteger)numberOfStickRowExcelTableViewLayout:(HJExcelTableViewLayout *)excelTableViewLayout {
    if ([self.dataSource respondsToSelector:@selector(numberOfStickRowExcelTableView:)]) {
        return [self.dataSource numberOfStickRowExcelTableView:self];
    }
    return 0;
}

#pragma mark - UIScrollViewDelegate 用于解决能垂直和水平两个方向同时滚动的问题
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isMultiDirectionScroll) {
        return;
    }

    if (self.collectionViewDirection == DirectionNone) {
        CGFloat detalX = fabs(self.collectionViewStartPoint.x - scrollView.contentOffset.x);
        CGFloat detalY = fabs(self.collectionViewStartPoint.y - scrollView.contentOffset.y);

        if (detalX < detalY) {
            self.collectionViewDirection = DirectionVertical;

        } else {
            self.collectionViewDirection = DirectionHorizontal;
        }
    }

    if (self.collectionViewDirection == DirectionVertical) {
        scrollView.contentOffset = CGPointMake(self.collectionViewStartPoint.x, scrollView.contentOffset.y);

    } else if (self.collectionViewDirection == DirectionHorizontal) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, self.collectionViewStartPoint.y);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.isMultiDirectionScroll) {
        return;
    }

    self.collectionViewStartPoint = scrollView.contentOffset;
    self.collectionViewDirection = 0;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.isMultiDirectionScroll) {
        return;
    }

    if (decelerate) {
        self.collectionViewDirection = 0;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.isMultiDirectionScroll) {
        return;
    }

    self.collectionViewDirection = 0;
}

@end
