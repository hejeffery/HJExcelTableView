//
//  HJExcelTableViewLayout.m
//  HJExcelTableView
//
//  Created by JefferyHe on 2017/7/26.
//  Copyright © 2017 JefferyHe. All rights reserved.
//

#import "HJExcelTableViewLayout.h"
#import "HJExcelHeadView.h"

#ifndef ScreenWidth
// 屏幕宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#endif

#ifndef ScreenHeight
// 屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#endif

// 比例
static const CGFloat kGreaterRadio = 0.75f;

/*!
 @class
 @abstract SectionModel，用来存储多section的情况
 */
@interface HJExcelTableViewSectionModel : NSObject

/*!
 @property
 @abstract 记录每一个section的列数
 */
@property (nonatomic, assign) NSInteger columnNumber;

/*!
 @property
 @abstract 记录每一个section的行数
 */
@property (nonatomic, assign) NSInteger rowNumber;

/*!
 @property
 @abstract 记录每一个section的列的宽度
 */
@property (nonatomic, strong) NSArray<NSNumber *> *columnWidths;

/*!
 @property
 @abstract 记录每一个section的行高
 */
@property (nonatomic, assign) CGFloat rowHeight;

/*!
 @property
 @abstract 记录计算每一个section中的attributes的前一个x的值
 */
@property (nonatomic, assign) CGFloat previousAttributesX;

/*!
 @property
 @abstract 记录计算每一个section中的最后一个attributes
 */
@property (nonatomic, strong) UICollectionViewLayoutAttributes *lastAttributesLayout;

/*!
 @property
 @abstract 记录每一个section的headerAttributes
 */
@property (nonatomic, strong) UICollectionViewLayoutAttributes *headerAttributes;

/*!
 @property
 @abstract 记录每一个section的footerAttributes
 */
@property (nonatomic, strong) UICollectionViewLayoutAttributes *footerAttributes;

/*!
 @property
 @abstract 记录总宽度，只读属性
 */
@property (nonatomic, assign, readonly) CGFloat totalWidth;

@end

@implementation HJExcelTableViewSectionModel

- (CGFloat)totalWidth {
    CGFloat width = 0;
    for (NSNumber *widthNumber in self.columnWidths) {
        width += fabs(widthNumber.floatValue);
    }
    return width;
}

@end

@interface HJExcelTableViewLayout ()

/*!
 @property
 @abstract tableHeaderView的高度。默认是0。如果HJExcelTableView设置了tableHeaderView属性，才会有值
 */
@property (nonatomic, assign) CGFloat tableHeaderViewHeight;

/*!
 @property
 @abstract 所有的cell
 */
@property (nonatomic, strong) NSMutableArray *attributes;

/*!
 @property
 @abstract 可见的cell
 */
@property (nonatomic, strong) NSMutableArray *visibleAttributes;

/*!
 @property
 @abstract 列间距
 */
@property (nonatomic, assign) CGFloat columnSpacing;

/*!
 @property
 @abstract 行间距
 */
@property (nonatomic, assign) CGFloat rowSpacing;

/*!
 @property
 @abstract Section间的间距
 */
@property (nonatomic, assign) CGFloat sectionSpacing;

/*!
 @property
 @abstract 固定的列数
 */
@property (nonatomic, assign) NSInteger stickColumnNumber;

/*!
 @property
 @abstract 固定的行数
 */
@property (nonatomic, assign) NSInteger stickRowNumber;

/*!
 @property
 @abstract 保存HJExcelTableViewSectionModel的数组
 */
@property (nonatomic, strong) NSMutableArray *sectionModels;

/*!
 @property
 @abstract excelHeadView
 */
@property (nonatomic, weak) HJExcelHeadView *excelHeadView;

/*!
 @property
 @abstract 返回计算出来的contentSize
 */
@property (nonatomic, assign) CGSize realContentSize;

/*!
 @property
 @abstract 可见区域的Rect
 */
@property (nonatomic, assign) CGRect visibleRect;

/*!
 @property
 @abstract 可见区域的宽
 */
@property (nonatomic, assign) CGFloat visibleWidth;

/*!
 @property
 @abstract 可见区域的高
 */
@property (nonatomic, assign) CGFloat visibleHeight;

@end

@implementation HJExcelTableViewLayout

#pragma mark - Init
- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.tableHeaderViewHeight = 0.0f;
    self.columnSpacing = 0.0f;
    self.rowSpacing = 0.0f;
    self.sectionSpacing =  0.0f;
    self.sectionHeaderViewHeight = 0.0f;
    self.sectionFooterViewHeight = 0.0f;
}

- (NSMutableArray *)attributes {
    if (!_attributes) {
        _attributes = [NSMutableArray array];
    }
    return _attributes;
}

- (NSMutableArray *)visibleAttributes {
    if (!_visibleAttributes) {
        _visibleAttributes = [NSMutableArray array];
    }
    return _visibleAttributes;
}

- (NSMutableArray *)sectionModels {
    if (!_sectionModels) {
        _sectionModels = [NSMutableArray array];
    }
    return _sectionModels;
}

#pragma mark - Override
- (void)prepareLayout {
    [super prepareLayout];
    
    NSInteger section = self.collectionView.numberOfSections;
    // section有值并且self.attributes中没有值才处理
    if (section && !self.attributes.count) {
        self.visibleWidth = CGRectGetWidth(self.collectionView.bounds);
        self.visibleHeight = CGRectGetHeight(self.collectionView.bounds);
        
        self.columnSpacing = [self.delegate columnSpacingOfExcelTableViewLayout:self];
        self.rowSpacing = [self.delegate rowSpacingOfExcelTableViewLayout:self];
        self.sectionSpacing = [self.delegate sectionSpacingOfExcelTableViewLayout:self];
        self.stickColumnNumber = [self.delegate numberOfStickColumnExcelTableViewLayout:self];
        self.stickRowNumber = [self.delegate numberOfStickRowExcelTableViewLayout:self];

        for (NSInteger i = 0; i < section; i++) {
            HJExcelTableViewSectionModel *sectionModel = [[HJExcelTableViewSectionModel alloc] init];
            // 每个section的列数
            sectionModel.columnNumber = [self.delegate columnOfExcelTableViewLayout:self inSection:i];
            // 每个section的列的宽度的数组
            sectionModel.columnWidths = [self.delegate excelTableViewLayout:self columnWidthsInSection:i];
            
            if (!sectionModel.columnWidths.count) {
                break;
            }
            
            // 如果每个section的列数和列的宽度的数组的个数不一致，取列的宽度的数组的个数为列数
            if (sectionModel.columnNumber != sectionModel.columnWidths.count) {
                sectionModel.columnNumber = sectionModel.columnWidths.count;
            }
            
            sectionModel.rowHeight = [self.delegate excelTableViewLayout:self rowHeightInSection:i];

            // 每个section中的个数
            NSInteger count = [self.collectionView numberOfItemsInSection:i];
            sectionModel.rowNumber = (count + sectionModel.columnNumber - 1) / sectionModel.columnNumber;

            [self.sectionModels addObject:sectionModel];
            
            // 如果需要显示header或者是footer才会处理HeaderView或者FooterView，否则不处理
            NSIndexPath *headerFooterIndexPath = [NSIndexPath indexPathWithIndex:i];
            // 有值才处理HeaderView
            if (self.sectionHeaderViewHeight) {
                UICollectionViewLayoutAttributes *headerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                          atIndexPath:headerFooterIndexPath];
                [self.attributes addObject:headerAttributes];
            }
            
            // 有值才处理FooterView
            if (self.sectionFooterViewHeight) {
                UICollectionViewLayoutAttributes *footerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                                          atIndexPath:headerFooterIndexPath];
                [self.attributes addObject:footerAttributes];
            }
            
            // 处理cell
            for (NSInteger j = 0; j < count; j++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                UICollectionViewLayoutAttributes *layoutes = [self layoutAttributesForItemAtIndexPath:indexPath];
                [self.attributes addObject:layoutes];
            }
            
            self.realContentSize = [self calculateContentSize];
        }
    }
    
    self.visibleRect = CGRectMake(self.collectionView.contentOffset.x,
                                  self.collectionView.contentOffset.y,
                                  self.visibleWidth,
                                  self.visibleHeight);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    [self.visibleAttributes removeAllObjects];
    [self.attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *itemAttributes, NSUInteger idx, BOOL *stop) {
        if (CGRectIntersectsRect(itemAttributes.frame, self.visibleRect)) {
            
            if (itemAttributes.representedElementCategory == UICollectionElementCategoryCell) {
                [self calculateStickyItemAttributes:itemAttributes];
                
            } else if (itemAttributes.representedElementCategory == UICollectionElementCategorySupplementaryView) {
                
                [self calculateHeaderFooterAttributes:itemAttributes supplementaryViewOfKind:itemAttributes.representedElementKind];
            }
            
            [self.visibleAttributes addObject:itemAttributes];
        }
    }];
    
    if (self.hasTableHeaderView && self.enableStickTableHeaderView) {
        CGRect headerViewFrame = self.excelHeadView.frame;
        headerViewFrame.origin.x = self.collectionView.contentOffset.x;
        self.excelHeadView.frame = headerViewFrame;
    }
    
    return self.visibleAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind
                                                                     atIndexPath:(NSIndexPath *)indexPath {
    // 不调用layoutAttributesForSupplementaryViewOfKind方法，就不会掉用HJExcelTableView.m中的viewForSupplementaryElementOfKind代理方法
    // 创建SupplementaryElement
    UICollectionViewLayoutAttributes *supplementaryAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind
                                                                                                                               withIndexPath:indexPath];
    [self calculateHeaderFooterAttributes:supplementaryAttributes supplementaryViewOfKind:elementKind];
    return supplementaryAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 创建Item
    UICollectionViewLayoutAttributes *cellAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    HJExcelTableViewSectionModel *sectionModel = self.sectionModels[indexPath.section];

    // 算出当前的列号
    NSInteger currentColumn = indexPath.item % sectionModel.columnNumber;
    // 算出当前的行号
    NSInteger currentRow = indexPath.item / sectionModel.columnNumber;
    // 取出当前列号的宽度
    CGFloat attributesW = fabs(sectionModel.columnWidths[currentColumn].floatValue);
    // 获取当前行的高度
    CGFloat attributesH = sectionModel.rowHeight;

    // 计算出y值
    CGFloat attributesY = 0;
    if (indexPath.section == 0) {// section为0时
        // tableHeaderView和sectionHeaderView都有的情况
        if (self.hasTableHeaderView && self.sectionHeaderViewHeight) {
            attributesY = (self.rowSpacing + attributesH) * currentRow + self.tableHeaderViewHeight + self.sectionHeaderViewHeight;
            
        } else if (self.hasTableHeaderView) {// 有tableHeaderView，加self.tableHeaderViewHeight
            attributesY = (self.rowSpacing + attributesH) * currentRow + self.tableHeaderViewHeight;

        } else if (self.sectionHeaderViewHeight) {// 有sectionHeaderView，加self.sectionHeaderViewHeight
            attributesY = (self.rowSpacing + attributesH) * currentRow + self.sectionHeaderViewHeight;
            
        } else {// headerView和sectionHeaderView都没有
            attributesY = (self.rowSpacing + attributesH) * currentRow;
        }

    } else {

        // 如果sectionHeaderViewHeight不为0，section之间的距离取sectionHeaderViewHeight，否则取sectionSpacing
        if (self.sectionHeaderViewHeight != 0) {
            attributesY += self.sectionHeaderViewHeight;

        } else {
            if (self.sectionFooterViewHeight != 0) {
                attributesY += 0;

            } else {// sectionHeaderView和sectionFooterView都没有，取sectionSpacing
                attributesY += self.sectionSpacing;
            }
        }

        // 取出上一个SectionModel
        HJExcelTableViewSectionModel *lastCalculateSectionModel = self.sectionModels[indexPath.section - 1];
        attributesY += CGRectGetMaxY(lastCalculateSectionModel.lastAttributesLayout.frame) + (self.rowSpacing + attributesH) * currentRow;
        if (self.sectionFooterViewHeight != 0) {
            attributesY += self.sectionFooterViewHeight;
        }
    }
    
    // 计算出x值
    // 列号为0，sectionModel.previousAttributesX为0
    if (currentColumn == 0) {
        sectionModel.previousAttributesX = 0;

    } else {
        // 列号不为0，当前的x为前一个的宽度 + self.columnSpacing
        sectionModel.previousAttributesX += fabs(sectionModel.columnWidths[currentColumn - 1].floatValue) + self.columnSpacing;
    }
    CGFloat attributesX = sectionModel.previousAttributesX;
    cellAttributes.frame = CGRectMake(attributesX, attributesY, attributesW, attributesH);

    sectionModel.lastAttributesLayout = cellAttributes;

    return cellAttributes;
}

- (CGSize)collectionViewContentSize {
    if (!self.sectionModels.count) {
        return CGSizeZero;
    }
    
    return self.realContentSize;
}

#pragma mark - Getter/Setter
- (void)setHasTableHeaderView:(BOOL)hasTableHeaderView {
    _hasTableHeaderView = hasTableHeaderView;
    NSArray *subviews = self.collectionView.subviews;
    for (UIView *subView in subviews) {
        if ([subView isKindOfClass:[HJExcelHeadView class]]) {
            self.excelHeadView = (HJExcelHeadView *)subView;
            self.tableHeaderViewHeight = CGRectGetHeight(subView.frame);
            break;
        }
    }
}

#pragma mark - Private Method
- (BOOL)greaterWidthWithStickColumn:(NSInteger)stickColumn columnWidths:(NSArray<NSNumber *> *)columnWidths {
    CGFloat calculateWidth = 0;
    for (NSInteger i = 0; i < stickColumn; i++) {
        calculateWidth += fabs(columnWidths[i].floatValue);
    }
    return (calculateWidth > ScreenWidth * kGreaterRadio) ? YES : NO;
}

- (BOOL)greaterHeightWithStickRow:(NSInteger)stickRow rowHeight:(CGFloat)rowHeight {
    CGFloat calculateHeight = stickRow * rowHeight;
    return (calculateHeight > ScreenHeight * kGreaterRadio) ? YES : NO;
}

- (CGSize)calculateContentSize {
    // 计算宽度
    HJExcelTableViewSectionModel *selectedModel = self.sectionModels[0];
    NSInteger count = self.sectionModels.count;
    for (NSInteger i = 1; i < count; i++) {
        HJExcelTableViewSectionModel *sectionModel = self.sectionModels[i];
        if (selectedModel.totalWidth <  sectionModel.totalWidth) {
            selectedModel = sectionModel;
        }
    }
    CGFloat contentW = selectedModel.totalWidth + (selectedModel.columnNumber - 1) * self.columnSpacing;
    
    // 计算高度
    HJExcelTableViewSectionModel *lastModel = self.sectionModels.lastObject;
    CGFloat contentH = CGRectGetMaxY(lastModel.lastAttributesLayout.frame);
    
    // 只加最后一个footer的高度
    if (self.sectionFooterViewHeight) {
        contentH += self.sectionFooterViewHeight;
    }
    
    // +0.5是让宽度稍微大于屏幕的宽度，这样会有反馈的效果
    contentW = MAX(contentW, ScreenWidth + 0.5f);
    contentH = MAX(contentH, ScreenHeight);
    
    return CGSizeMake(contentW, contentH);
}

- (void)calculateStickyItemAttributes:(UICollectionViewLayoutAttributes *)itmeAttributes
{
    NSIndexPath *indexPath = itmeAttributes.indexPath;
    HJExcelTableViewSectionModel *sectionModel = self.sectionModels[indexPath.section];
    // 算出当前的列号
    NSInteger currentColumn = indexPath.item % sectionModel.columnNumber;
    // 算出当前的行号
    NSInteger currentRow = indexPath.item / sectionModel.columnNumber;
    // 获取当前行的高度
    CGFloat attributesH = sectionModel.rowHeight;
    
    // 有固定的行数，并且总行数的高度要小于屏幕高度的四分之三才，且section为1时才处理
    if (self.stickRowNumber &&
        ![self greaterHeightWithStickRow:self.stickRowNumber rowHeight:attributesH] &&
        self.collectionView.numberOfSections == 1) {
        if (currentRow < self.stickRowNumber) {
            CGRect frame = itmeAttributes.frame;
            // 第一行的处理方式
            if (currentRow == 0) {
                frame.origin.y = self.collectionView.contentOffset.y + self.collectionView.contentInset.top;
                
            } else {// 非第一行的处理方式
                frame.origin.y = self.collectionView.contentOffset.y + self.collectionView.contentInset.top + currentRow * attributesH
                               + self.rowSpacing * currentRow;
            }
            itmeAttributes.frame = frame;
            itmeAttributes.zIndex = 1;
        }
    }
    
    // 有固定的列数，并且总列数的宽度要小于屏幕宽度的四分之三才处理
    if (self.stickColumnNumber &&
        ![self greaterWidthWithStickColumn:self.stickColumnNumber columnWidths:sectionModel.columnWidths]) {
        
        if (currentColumn < self.stickColumnNumber) {
            CGRect frame = itmeAttributes.frame;
            // 第一列的处理方式
            if (currentColumn == 0) {
                frame.origin.x = self.collectionView.contentOffset.x;
                
            } else {// 非第一列的处理方式
                frame.origin.x = self.collectionView.contentOffset.x
                               + fabs(sectionModel.columnWidths[currentColumn - 1].floatValue)
                               + self.columnSpacing;
            }
            itmeAttributes.frame = frame;
            itmeAttributes.zIndex = 1;
        }
    }
    
    // 有固定行数和固定列数，且section为1时才处理
    if (self.collectionView.numberOfSections == 1 && self.stickRowNumber && self.stickColumnNumber) {
        if (currentRow < self.stickRowNumber && currentColumn < self.stickColumnNumber) {
            itmeAttributes.zIndex = 2;
        }
    }
}

- (void)calculateHeaderFooterAttributes:(UICollectionViewLayoutAttributes *)headerFooterAttributes
                supplementaryViewOfKind:(NSString *)elementKind
{
    // 是否固定了列数
    BOOL isStickColumn = [self.delegate numberOfStickColumnExcelTableViewLayout:self];
    
    NSIndexPath *indexPath = headerFooterAttributes.indexPath;
    
    CGFloat headerFooterW = [self collectionViewContentSize].width;
    
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        CGFloat headerViewH = self.sectionHeaderViewHeight;
        CGFloat headerViewX = 0.0f;
        
        // 如果固定列数，并且contentOffset.x < 0，headerview固定不动
        if (isStickColumn && self.collectionView.contentOffset.x < 0) {
            headerViewX = self.collectionView.contentOffset.x;
        }
        
        // 计算y的值
        // section为0，headerViewY为0
        // section不为0，headerViewY = 为前面所有section的高度之和
        if (indexPath.section == 0) {
            CGFloat headerViewY = 0.0f;
            // 有tableHeaderView的情况，再 + self.tableHeaderViewHeight
            if (self.hasTableHeaderView) {
                headerViewY += self.tableHeaderViewHeight;
            }
            headerFooterAttributes.frame = CGRectMake(headerViewX, headerViewY, headerFooterW, headerViewH);
            
        } else {
            CGFloat headerViewY = 0.0f;
            for (NSInteger i = 0; i < indexPath.section; i++) {
                HJExcelTableViewSectionModel *sectionModel = self.sectionModels[i];
                // 要加上行距，也就是self.rowSpacing
                headerViewY += self.sectionHeaderViewHeight + sectionModel.rowHeight * sectionModel.rowNumber
                             + self.rowSpacing * (sectionModel.rowNumber - 1)
                             + self.sectionFooterViewHeight;
            }
            // 有tableHeaderView的情况，再 + self.tableHeaderViewHeight
            if (self.hasTableHeaderView) {
                headerViewY += self.tableHeaderViewHeight;
            }
            headerFooterAttributes.frame = CGRectMake(headerViewX, headerViewY, headerFooterW, headerViewH);
        }
        
    } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        CGFloat footerViewH = self.sectionFooterViewHeight;
        CGFloat footerViewX = 0.0f;
        
        // 如果固定列数，并且contentOffset.x < 0，footerview固定不动
        if (isStickColumn && self.collectionView.contentOffset.x < 0) {
            footerViewX = self.collectionView.contentOffset.x;
        }
        
        // 计算y的值
        // section为0
        if (indexPath.section == 0) {
            HJExcelTableViewSectionModel *sectionModel = self.sectionModels[0];
            CGFloat footerViewY = self.sectionHeaderViewHeight + sectionModel.rowHeight * sectionModel.rowNumber
            + self.rowSpacing * (sectionModel.rowNumber - 1);
            // 有tableHeaderView的情况，再 + self.tableHeaderViewHeight
            if (self.hasTableHeaderView) {
                footerViewY += self.tableHeaderViewHeight;
            }
            headerFooterAttributes.frame = CGRectMake(footerViewX, footerViewY, headerFooterW, footerViewH);
            
        } else {
            // section不为0
            CGFloat footerViewY = 0.0f;
            // 先计算出前几个section的总高度，要加上行距，也就是self.rowSpacing
            for (NSInteger i = 0; i < indexPath.section; i++) {
                HJExcelTableViewSectionModel *sectionModel = self.sectionModels[i];
                footerViewY += self.sectionHeaderViewHeight + self.sectionFooterViewHeight
                             + sectionModel.rowHeight * sectionModel.rowNumber
                             + self.rowSpacing * (sectionModel.rowNumber - 1);
            }
            // 再 + self.sectionHeaderViewHeight + 当前section中的cell的总高度，要加上行距，也就是self.rowSpacing
            HJExcelTableViewSectionModel *currentSectionModel = self.sectionModels[indexPath.section];
            footerViewY += self.sectionHeaderViewHeight + currentSectionModel.rowHeight * currentSectionModel.rowNumber
                         + self.rowSpacing * (currentSectionModel.rowNumber - 1);
            // 有tableHeaderView的情况，再 + self.tableHeaderViewHeight
            if (self.hasTableHeaderView) {
                footerViewY += self.tableHeaderViewHeight;
            }
            headerFooterAttributes.frame = CGRectMake(footerViewX, footerViewY, headerFooterW, footerViewH);
        }
    }
}

@end
