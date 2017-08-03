//
//  TestExcelReusableHeadView.m
//  HJExcelTableView
//
//  Created by JefferyHe on 2017/8/1.
//  Copyright © 2017 JefferyHe. All rights reserved.
//

#import "TestExcelReusableHeadView.h"

@interface TestExcelReusableHeadView ()

@end

@implementation TestExcelReusableHeadView

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

- (void)setup {
    UILabel *headTitle1 = [[UILabel alloc] init];
    headTitle1.textColor = [UIColor blackColor];
    headTitle1.font = [UIFont systemFontOfSize:16.0f];
    headTitle1.backgroundColor = [UIColor cyanColor];
    headTitle1.frame = CGRectMake(0.0f, 0.0f, 80.0f, 30.0f);
    [self addSubview:headTitle1];
    _headTitle1 = headTitle1;
    
    UILabel *headTitle2 = [[UILabel alloc] init];
    headTitle2.textColor = [UIColor blackColor];
    headTitle2.font = [UIFont systemFontOfSize:16.0f];
    headTitle2.backgroundColor = [UIColor cyanColor];
    headTitle2.frame = CGRectMake(80.0f, 0.0f, 80.0f, 30.0f);
    [self addSubview:headTitle2];
    _headTitle2 = headTitle2;
}

@end
