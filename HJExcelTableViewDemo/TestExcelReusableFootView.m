//
//  TestExcelReusableFootView.m
//  HJExcelTableView
//
//  Created by JefferyHe on 2017/8/1.
//  Copyright © 2017 JefferyHe. All rights reserved.
//

#import "TestExcelReusableFootView.h"

@interface TestExcelReusableFootView ()

@property (nonatomic, weak) UILabel *headTitle;

@end

@implementation TestExcelReusableFootView

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
    UILabel *headTitle = [[UILabel alloc] init];
    headTitle.text = @"footer";
    headTitle.textColor = [UIColor blackColor];
    headTitle.font = [UIFont systemFontOfSize:16.0f];
    headTitle.backgroundColor = [UIColor purpleColor];
    headTitle.frame = CGRectMake(0.0f, 0.0f, 50.0f, 30.0f);
    [self addSubview:headTitle];
    self.headTitle = headTitle;
}

@end
