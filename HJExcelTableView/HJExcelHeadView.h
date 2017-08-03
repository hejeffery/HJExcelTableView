//
//  HJExcelHeadView.h
//  HJExcelTableView
//
//  Created by JefferyHe on 2017/7/28.
//  Copyright © 2017 JefferyHe. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class
 @abstract HJExcelTableView的headView。如果要为HJExcelTableView添加HeadView，请继承这个类
 @discussion 使用时，可以不用设置x和y，但是要设置width和height，否则无法显示，考虑到了列表可以横向滚动，所以要对width进行设置，灵活性比较高
 */
@interface HJExcelHeadView : UIView

@end
