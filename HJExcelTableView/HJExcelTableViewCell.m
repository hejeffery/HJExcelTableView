//
//  HJExcelTableViewCell.m
//  HJExcelTableView
//
//  Created by JefferyHe on 2017/7/26.
//  Copyright © 2017 JefferyHe. All rights reserved.
//

#import "HJExcelTableViewCell.h"

@implementation HJExcelTableViewCell

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
    self.textLabel.frame = self.contentView.frame;
}

- (void)setup {
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont systemFontOfSize:13.0f];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:textLabel];
    _textLabel = textLabel;
}

@end
