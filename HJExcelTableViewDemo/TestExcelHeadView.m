//
//  TestExcelHeadView.m
//  HJExcelTableView
//
//  Created by JefferyHe on 2017/8/1.
//  Copyright © 2017 JefferyHe. All rights reserved.
//

#import "TestExcelHeadView.h"

@interface TestExcelHeadView ()

@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation TestExcelHeadView

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
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0.0f, 0.0f, 200.0f, 20.0f);
    titleLabel.text = @"TableHeaderView";
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
}

@end
