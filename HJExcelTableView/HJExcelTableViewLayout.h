//
//  HJExcelTableViewLayout.h
//  HJExcelTableView
//
//  Created by JefferyHe on 2017/7/26.
//  Copyright © 2017 JefferyHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HJExcelTableViewLayoutDelegate;

/*!
 @class
 @abstract HJExcelTableViewLayout
 */
@interface HJExcelTableViewLayout : UICollectionViewLayout

/*!
 @property
 @abstract 是否有tableHeaderView，默认是NO
 */
@property (nonatomic, assign) BOOL hasTableHeaderView;

/*!
 @property
 @abstract HeaderView在X方向上是否固定，默认是NO，不固定
 */
@property (nonatomic, assign) BOOL enableStickTableHeaderView;

/*!
 @property
 @abstract 是否有tableFooterView，默认是NO
 */
@property (nonatomic, assign) BOOL hasTableFooterView;

/*!
 @property
 @abstract FooterView在X方向上是否固定，默认是NO，不固定
 */
@property (nonatomic, assign) BOOL enableStickTableFooterView;

/*!
 @property
 @abstract 每个Section的HeaderView的高度
 */
@property (nonatomic, assign) CGFloat sectionHeaderViewHeight;

/*!
 @property
 @abstract 每个Section的FooterView的高度
 */
@property (nonatomic, assign) CGFloat sectionFooterViewHeight;

/*!
 @property
 @abstract HJExcelTableViewLayoutDelegate
 */
@property (nonatomic, weak) id<HJExcelTableViewLayoutDelegate> delegate;

/*!
 @method
 @abstract 刷新数据

 */
- (void)reload;

@end

@protocol HJExcelTableViewLayoutDelegate <NSObject>

@required
/*!
 @method
 @abstract 返回有多少列
 
 @param excelTableViewLayout HJExcelTableViewLayout对象
 @param section section
 
 @result 返回的列数
 */
- (NSInteger)columnOfExcelTableViewLayout:(HJExcelTableViewLayout *)excelTableViewLayout inSection:(NSInteger)section;

/*!
 @method
 @abstract 返回行间距
 
 @param excelTableViewLayout HJExcelTableViewLayout对象
 
 @result 返回的行间距
 */
- (CGFloat)rowSpacingOfExcelTableViewLayout:(HJExcelTableViewLayout *)excelTableViewLayout;

/*!
 @method
 @abstract 返回列间距
 
 @param excelTableViewLayout HJExcelTableViewLayout对象
 
 @result 返回的列间距
 */
- (CGFloat)columnSpacingOfExcelTableViewLayout:(HJExcelTableViewLayout *)excelTableViewLayout;

/*!
 @method
 @abstract 返回Section之间的间距
 
 @param excelTableViewLayout HJExcelTableViewLayout对象
 
 @result 返回的Secion之间的间距
 */
- (CGFloat)sectionSpacingOfExcelTableViewLayout:(HJExcelTableViewLayout *)excelTableViewLayout;

/*!
 @method
 @abstract 返回每一个section对应的cell的宽度
 
 @param excelTableViewLayout HJExcelTableViewLayout对象
 @param section section
 
 @result 返回每一个cell的宽度
 */
- (NSArray<NSNumber *> *)excelTableViewLayout:(HJExcelTableViewLayout *)excelTableViewLayout columnWidthsInSection:(NSInteger)section;

/*!
 @method
 @abstract 返回每一个section对应的cell的高度
 
 @param excelTableViewLayout HJExcelTableViewLayout对象
 @param section section对象
 
 @result 返回每一列的宽度
 */
- (CGFloat)excelTableViewLayout:(HJExcelTableViewLayout *)excelTableViewLayout rowHeightInSection:(NSInteger)section;

/*!
 @method
 @abstract 返回需要固定的列数，默认是0
 
 @param excelTableViewLayout excelTableViewLayout
 
 @result 返回固定的列数
 */
- (NSInteger)numberOfStickColumnExcelTableViewLayout:(HJExcelTableViewLayout *)excelTableViewLayout;

/*!
 @method
 @abstract 返回需要固定的行数，默认是0
 
 @param excelTableViewLayout excelTableViewLayout
 
 @result 返回固定的行数
 */
- (NSInteger)numberOfStickRowExcelTableViewLayout:(HJExcelTableViewLayout *)excelTableViewLayout;

@end
