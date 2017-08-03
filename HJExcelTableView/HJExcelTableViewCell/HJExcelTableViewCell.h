//
//  HJExcelTableViewCell.h
//  HJExcelTableView
//
//  Created by JefferyHe on 2017/7/26.
//  Copyright © 2017 JefferyHe. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class
 @abstract HJExcelTableView的Cell。已经有一个textLabel的只读属性。如果要自定义Cell，请继承这个类
 */
@interface HJExcelTableViewCell : UICollectionViewCell

/*!
 @property
 @abstract textLabel
 */
@property (nonatomic, weak, readonly) UILabel *textLabel;

@end
