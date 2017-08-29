//
//  TestViewController.m
//  HJExcelTableView
//
//  Created by JefferyHe on 2017/7/26.
//  Copyright © 2017 JefferyHe. All rights reserved.
//

#import "TestViewController.h"
#import "HJExcelTableView.h"
#import "HJExcelTableViewCell.h"
#import "HJExcelHeadView.h"

#import "TestExcelReusableHeadView.h"
#import "TestExcelReusableFootView.h"
#import "TestExcelHeadView.h"
#import "TestExcelFootView.h"

static NSString *const cellID = @"CellID";
static NSString *headerID = @"HeaderID";
static NSString *footerID = @"FooterID";

@interface TestViewController () <
    HJExcelTableViewDataSource,
    HJExcelTableViewDelegate
>

@property (nonatomic, weak) HJExcelTableView *excelTableView;

@end

@implementation TestViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"HJExcelTableView";
    self.excelTableView.hidden = NO;
}

- (HJExcelTableView *)excelTableView {
    if (!_excelTableView) {
        HJExcelTableView *excelTableView = [[HJExcelTableView alloc] init];
        // 注册cell
        [excelTableView registerClass:[HJExcelTableViewCell class] forCellWithReuseIdentifier:cellID];
        
//        // 注册HeadReusableView
//        [excelTableView registerClass:[TestExcelReusableHeadView class]
//           forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
//                  withReuseIdentifier:headerID];
//        // 设置Section HeaderView的高
//        excelTableView.headerViewHeightOfSection = 40.0f;
//    
//        // 注册FootReusableView
//        [excelTableView registerClass:[TestExcelReusableFootView class]
//           forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
//                  withReuseIdentifier:footerID];
//        // 设置Section FooterView的高
//        excelTableView.footerViewHeightOfSection = 50.0f;
        
        excelTableView.frame = self.view.bounds;
        excelTableView.dataSource = self;
        excelTableView.delegate = self;
//        // 设置列间距
//        excelTableView.columnSpacing = 1 / [UIScreen mainScreen].scale;
        excelTableView.column = 4;
        
//        // 设置垂直和水平的indicator不显示
//        excelTableView.showsVerticalScrollIndicator = NO;
//        excelTableView.showsHorizontalScrollIndicator = NO;
        
//        // 设置多方向滚动支持
//        excelTableView.isMultiDirectionScroll = YES;
        
//        // 设置阻力效果
//        excelTableView.bounces = NO;
        
//        // 设置headerView
//        TestExcelHeadView *headerView = [[TestExcelHeadView alloc] init];
//        headerView.frame = CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 44.0f);
//        headerView.backgroundColor = [UIColor blueColor];
//        excelTableView.tableHeaderView = headerView;
//        // 设置headerView固定
//        excelTableView.enableStickTableHeaderView = YES;
        
//        // 设置footerView
//        TestExcelFootView *footerView = [[TestExcelFootView alloc] init];
//        footerView.frame = CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 44.0f);
//        footerView.backgroundColor = [UIColor orangeColor];
//        excelTableView.tableFooterView = footerView;
//        // 设置footerView固定
//        excelTableView.enableStickTableFooterView = YES;
        
        [self.view addSubview:excelTableView];
        _excelTableView = excelTableView;
    }
    return _excelTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - HJExcelTableViewDataSource
- (NSInteger)numberOfSectionsInExcelTableView:(HJExcelTableView *)excelTableView {
    return 3;
}

- (NSInteger)excelTableView:(HJExcelTableView *)excelTableView numberOfItemInSection:(NSInteger)section {
    if (section == 0) {
        return 8;
    
    } else if (section == 1) {
        return 20;
    }
    return 32;
}

- (HJExcelTableViewCell *)excelTableView:(HJExcelTableView *)excelTableView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
                               itemAtRow:(NSInteger)row
                            itemAtColumn:(NSInteger)column {
    HJExcelTableViewCell *cell = [excelTableView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.backgroundColor = [UIColor purpleColor];

    } else if (indexPath.section == 1) {
        cell.backgroundColor = [UIColor magentaColor];

    } else {
        cell.backgroundColor = [UIColor orangeColor];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"(section:%ld, row:%ld, col:%ld)", indexPath.section, row, column];
    return cell;
}

- (NSArray<NSNumber *> *)excelTableView:(HJExcelTableView *)excelTableView columnWidthsInSection:(NSInteger)section {
//    if (section == 0) {
//        return @[@30.0f, @60.0f, @90.0f, @120.0f];
//    }
//    return @[@100.0f, @150.0f, @200.0f, @250.0f];
    return @[@150.0f, @180.0f, @200.0f, @240.0f];
}

- (CGFloat)excelTableView:(HJExcelTableView *)excelTableView rowHeightInSection:(NSInteger)section {
    if (section == 0) {
        return 44.0f;
    } else if (section == 1) {
        return 55.0f;
    }
    return 66.0f;
}

//- (NSInteger)numberOfStickColumnExcelTableView:(HJExcelTableView *)excelTableView {
//    return 1;
//}

//- (NSInteger)numberOfStickRowExcelTableView:(HJExcelTableView *)excelTableView {
//    return 1;
//}

//- (HJExcelReusableView *)excelTableView:(HJExcelTableView *)excelTableView viewForHeaderAtIndexPath:(NSIndexPath *)indexPath {
//    TestExcelReusableHeadView *headerView = (TestExcelReusableHeadView *)[excelTableView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
//                                                                                                            withReuseIdentifier:headerID
//                                                                                                                   forIndexPath:indexPath];
//    headerView.headTitle1.text = [NSString stringWithFormat:@"section%ld", indexPath.section];
//    headerView.headTitle2.text = [NSString stringWithFormat:@"-  section%ld", indexPath.section];
//    headerView.backgroundColor = [UIColor yellowColor];
//    return headerView;
//}

//- (HJExcelReusableView *)excelTableView:(HJExcelTableView *)excelTableView viewForFooterAtIndexPath:(NSIndexPath *)indexPath {
//    TestExcelReusableFootView *footerView = (TestExcelReusableFootView *)[excelTableView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
//                                                                                                            withReuseIdentifier:footerID
//                                                                                                                   forIndexPath:indexPath];
//    footerView.backgroundColor = [UIColor orangeColor];
//    return footerView;
//}

#pragma mark - HJExcelTableViewDelegate
- (void)excelTableView:(HJExcelTableView *)excelTableView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
                                                                         itemAtRow:(NSInteger)row
                                                                      itemAtColumn:(NSInteger)column {
    NSLog(@"选择了 (row = %ld, column = %ld)", row, column);
}


@end
