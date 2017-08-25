//
//  HJExcelTableView.h
//  HJExcelTableView
//
//  Created by JefferyHe on 2017/7/26.
//  Copyright © 2017 JefferyHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJExcelTableViewCell.h"
#import "HJExcelHeadView.h"
#import "HJExcelReusableView.h"

@protocol HJExcelTableViewDataSource;
@protocol HJExcelTableViewDelegate;

/*!
 @class
 @abstract 类似Excel能够水平和垂直方向上滑动的TableView
 */
@interface HJExcelTableView : UIView

/*!
 @property
 @abstract 有多少列，默认是1列。
           但是实际列数以代理方法“excelTableView:(HJExcelTableView *)excelTableView columnWidthsInSection:(NSInteger)section”返回的数组的个数为主
 */
@property (nonatomic, assign) NSInteger column;

/*!
 @property
 @abstract 行间距，默认是1.0f。如果要显示网格状的，水平间距和垂直间距设置为同一数值，设置的值最好是要 / [UIScreen mainScreen].scale
 */
@property (nonatomic, assign) CGFloat rowSpacing;

/*!
 @property
 @abstract 列间距，默认是0.0f。如果要显示网格状的，水平间距和垂直间距设置为同一数值，设置的值最好是要 / [UIScreen mainScreen].scale
 */
@property (nonatomic, assign) CGFloat columnSpacing;

/*!
 @property
 @abstract 每个section的间距，默认是0.0f。如果sectionHeaderView和sectionFooterView都没有设置，section间的距离用sectionSpacing
           设置的值最好是要 / [UIScreen mainScreen].scale
 */
@property (nonatomic, assign) CGFloat sectionSpacing;

/*!
 @property
 @abstract 显示垂直方向上的指示器， 默认是YES
 */
@property (nonatomic, assign) BOOL showsVerticalScrollIndicator;

/*!
 @property
 @abstract 显示水平方向上的指示器， 默认是YES
 */
@property (nonatomic, assign) BOOL showsHorizontalScrollIndicator;

/*!
 @property
 @abstract 是否有阻尼效果，默认是YES
 */
@property (nonatomic, assign) BOOL bounces;

/*!
 @property
 @abstract TableHeaderView
 @discussion 类似TableView的tableHeaderView，属于整个HJExcelTableView，而非某个Section的HeaderView
 */
@property (nonatomic, strong) HJExcelHeadView *tableHeaderView;

/*!
 @property
 @abstract Section HeaderView的高度，默认是0
 @discussion 如果需要在每个section上显示headerView，需要设置值，否则不显示。并且实现代理方法
             - (HJExcelReusableView *)excelTableView:(HJExcelTableView *)excelTableView viewForHeaderAtIndexPath:(NSIndexPath *)indexPath。
             使用时要注册HJExcelReusableView，否则会报错
 */
@property (nonatomic, assign) CGFloat headerViewHeightOfSection;

/*!
 @property
 @abstract Section FooterView的高度，默认是0
 @discussion 如果需要在每个section上显示footerView，需要设置值，否则不显示。并且实现代理方法：
             - (HJExcelReusableView *)excelTableView:(HJExcelTableView *)excelTableView viewForFooterAtIndexPath:(NSIndexPath *)indexPath
             使用时要注册HJExcelReusableView，否则会报错。
 */
@property (nonatomic, assign) CGFloat footerViewHeightOfSection;

/*!
 @property
 @abstract TableHeaderView在X方向上是否固定，默认是NO，不固定
 */
@property (nonatomic, assign) BOOL enableStickTableHeaderView;

/*!
 @property
 @abstract 是否支持同时x和y方向的滑动，默认是NO
 */
@property (nonatomic, assign) BOOL isMultiDirectionScroll;

/*!
 @property
 @abstract 对外暴露的collectionView，只读属性。暴露的目的是为了能让HJExcelTableView有下拉刷新和上拉加载的功能
 */
@property (nonatomic, weak, readonly) UICollectionView *collectionView;

/*!
 @property
 @abstract HJExcelTableView的数据源代理
 */
@property (nonatomic, weak) id<HJExcelTableViewDataSource> dataSource;

/*!
 @property
 @abstract HJExcelTableView的事件代理
 */
@property (nonatomic, weak) id<HJExcelTableViewDelegate> delegate;

/*!
 @method
 @abstract 获取循环利用的HJExcelTableViewCell的方法
 
 @param identifier 循环利用的id
 @param indexPath indexPath
 
 @result 返回的HJExcelTableViewCell对象
 */
- (HJExcelTableViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

/*!
 @method
 @abstract 获取循环利用的HJExcelReusableView的方法
 
 @param elementKind 有两种类型：UICollectionElementKindSectionHeader和UICollectionElementKindSectionFooter
 @param identifier 循环利用的id
 @param indexPath indexPath
 
 @result 返回的HJExcelReusableView对象
 */
- (HJExcelReusableView *)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind
                                            withReuseIdentifier:(NSString *)identifier
                                                   forIndexPath:(NSIndexPath *)indexPath;

/*!
 @method
 @abstract 注册cell
 
 @param cellClass 注册的cell的class
 @param identifier 循环利用的id
 
 */
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;

/*!
 @method
 @abstract 注册cell
 
 @param nib nib
 @param identifier 循环利用的id
 
 */
- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;

/*!
 @method
 @abstract 注册SectionHeaderView或者是SectionFooterView
 
 @param viewClass 注册的cell的class
 @param elementKind 有两种类型：UICollectionElementKindSectionHeader和UICollectionElementKindSectionFooter
 @param identifier 循环利用的id
 
 */
- (void)registerClass:(Class)viewClass forSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier;

/*!
 @method
 @abstract 注册SectionHeaderView或者是SectionFooterView
 
 @param nib nib
 @param kind 有两种类型：UICollectionElementKindSectionHeader和UICollectionElementKindSectionFooter
 @param identifier 循环利用的id
 
 */
- (void)registerNib:(UINib *)nib forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier;

/*!
 @method
 @abstract 刷新数据
 
 */
- (void)reloadData;

@end

@protocol HJExcelTableViewDataSource <NSObject>

@required
/*!
 @method
 @abstract 对应的section有多少个item
 
 @param excelTableView excelTableView
 @param section section
 
 @result 返回的对应的section中的item的个数
 */
- (NSInteger)excelTableView:(HJExcelTableView *)excelTableView numberOfItemInSection:(NSInteger)section;

/*!
 @method
 @abstract 每一个对应的indexpath返回的cell
 @discussion 通过这个方法可以返回cell。和TableView的用法类似。
             不过多了row和column两个参数，都是从0开始。可以根据row和column对cell进行一些细节上的处理，比如label的左右对齐
 
 @param excelTableView excelTableView
 @param indexPath indexPath
 @param row row
 @param column column
 
 @result HJExcelTableViewCell对象
 */
- (HJExcelTableViewCell *)excelTableView:(HJExcelTableView *)excelTableView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
                               itemAtRow:(NSInteger)row
                            itemAtColumn:(NSInteger)column;

/*!
 @method
 @abstract 返回每一个section对应的每一列的宽度
 @discussion 如果该方法返回的数组的个数为0，不显示任何数据。如果该方法返回的数组中有负数，则取负数的绝对值
 
 @param excelTableView excelTableView
 @param section section
 
 @result 返回每一个section对应的每一列的宽度。e.g:@[@100.0f, @150.0f, @200.0f, @250.0f]，总共有四列，每列对应一个值
 */
- (NSArray<NSNumber *> *)excelTableView:(HJExcelTableView *)excelTableView columnWidthsInSection:(NSInteger)section;

/*!
 @method
 @abstract 返回每一个section对应的每一列的高度
 
 @param excelTableView excelTableView
 @param section section
 
 @result 返回每一列的高度
 */
- (CGFloat)excelTableView:(HJExcelTableView *)excelTableView rowHeightInSection:(NSInteger)section;

@optional
/*!
 @method
 @abstract 返回section的个数，默认是1
 
 @param excelTableView excelTableView
 
 @result 返回section的个数
 */
- (NSInteger)numberOfSectionsInExcelTableView:(HJExcelTableView *)excelTableView;

/*!
 @method
 @abstract 返回需要固定的列数，默认是0，不固定列数
 @discussion 从左至右固定。1为固定1列，2为固定2列，以此类推。如果固定总列数的宽度要小于屏幕宽度的四分之三才处理。
 
 @param excelTableView excelTableView
 
 @result 返回需要固定的列数
 */
- (NSInteger)numberOfStickColumnExcelTableView:(HJExcelTableView *)excelTableView;

/*!
 @method
 @abstract 返回需要固定的行数，默认是0，不固定列数
 @discussion 从上至下固定。1为固定1行，2为固定2行，以此类推。如果固定总行数的高度要小于屏幕高度的四分之三才处理。
             需要注意的是，该方法设置只对section为1的情况起作用。section > 1的情况无效。
             如果要实现为每个Section加上一个HeaderView，
             请使用“- (HJExcelReusableView *)excelTableView:(HJExcelTableView *)excelTableView viewForHeaderAtIndexPath:(NSIndexPath *)indexPath”代理反复
 
 @param excelTableView excelTableView
 
 @result 返回需要固定的行数
 */
- (NSInteger)numberOfStickRowExcelTableView:(HJExcelTableView *)excelTableView;

/*!
 @method
 @abstract 返回每一个section对应的HeaderReusableView
 @discussion 需要注意的是，返回的对象必须是HJExcelReusableView的子类，它的宽度是所有列的宽度和。
             如果没有设置headerViewHeightOfSection，实现了这个代理方法也不会显示sectionHeaderView
 
 @param excelTableView excelTableView
 @param indexPath indexPath
 
 @result 返回HJExcelReusableView
 */
- (HJExcelReusableView *)excelTableView:(HJExcelTableView *)excelTableView viewForHeaderAtIndexPath:(NSIndexPath *)indexPath;

/*!
 @method
 @abstract 返回每一个section对应的FooterReusableView
 @discussion 需要注意的是，返回的对象必须是HJExcelReusableView的子类，它的宽度是所有列的宽度和
             如果没有设置footerViewHeightOfSection，实现了这个代理方法也不会显示sectionFooterView
 
 @param excelTableView excelTableView
 @param indexPath indexPath
 
 @result HJExcelReusableView
 */
- (HJExcelReusableView *)excelTableView:(HJExcelTableView *)excelTableView viewForFooterAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol HJExcelTableViewDelegate <NSObject>

@optional
/*!
 @method
 @abstract 点击cell的事件
 
 @param indexPath indexPath
 @param row cell所在的行
 @param column cell所在列

 */
- (void)excelTableView:(HJExcelTableView *)excelTableView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
                                                                         itemAtRow:(NSInteger)row
                                                                      itemAtColumn:(NSInteger)column;

@end
