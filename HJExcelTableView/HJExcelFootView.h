//
//  HJExcelFootView.h
//  HJExcelTableView
//
//  Created by jhe.jeffery on 2017/8/29.
//  Copyright © 2017年 JefferyHe. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class
 @abstract HJExcelTableView的footView。如果要为HJExcelTableView添加FootView，请继承这个类
 @discussion 使用时，可以不用设置x和y，但是要设置width和height，否则无法显示，考虑到了列表可以横向滚动，所以要对width进行设置，灵活性比较高
 */
@interface HJExcelFootView : UIView

@end
