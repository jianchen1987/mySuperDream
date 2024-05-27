//
//  SACouponRedemptionView.m
//  SuperApp
//
//  Created by Chaos on 2021/1/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACouponRedemptionView.h"
#import "SATableView.h"
#import "SAMultiLanguageManager.h"
#import "SACouponRedemptionViewModel.h"
#import "SACouponRedemptionCell.h"


@interface SACouponRedemptionView () <UITableViewDelegate, UITableViewDataSource>

/// tableView
@property (nonatomic, strong) SATableView *tableView;
/// 顶部视图
@property (nonatomic, strong) UIImageView *headerIV;
/// viewModel
@property (nonatomic, strong) SACouponRedemptionViewModel *viewModel;

@end


@implementation SACouponRedemptionView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    [self addSubview:self.tableView];

    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setGradualChangingColors:@[HexColor(0xFFC938), HexColor(0xFE741E), HexColor(0xFD1401)] startPoint:CGPointMake(0.5, 0) endPoint:CGPointMake(0.5, 1)];
    };
}

- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SACouponTicketModel *cellModel = self.viewModel.dataSource[indexPath.row];
    cellModel.isFirstCell = indexPath.row == 0;
    SACouponRedemptionCell *cell = [SACouponRedemptionCell cellWithTableView:tableView];
    cell.model = cellModel;
    cell.clickUseNowBlock = ^(SACouponTicketModel *_Nonnull model) {
        [self navigationToBussinessLineHomePageWithModel:model];
    };
    cell.clickViewDetailBlock = ^(SACouponRedemptionCell *_Nonnull cell, SACouponTicketModel *_Nonnull model) {
        model.isExpanded = !model.isExpanded;
        NSIndexPath *indexPath = [tableView indexPathForCell:cell];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    return cell;
}

#pragma mark - private methods
- (void)navigationToBussinessLineHomePageWithModel:(SACouponTicketModel *)model {
    if (HDIsStringNotEmpty(model.useLink)) {
        [self.viewController.navigationController popToRootViewControllerAnimated:false];
        [SAWindowManager openUrl:model.useLink withParameters:nil];
        return;
    }
    if (model.businessTypeList.count != 1) {
        [SAWindowManager switchWindowToMainTabBarController];
        return;
    }
    if (model.businessTypeList.firstObject.unsignedIntegerValue == SACouponTicketBusinessLineYumNow) {
        [self.viewController.navigationController popToRootViewControllerAnimated:false];
        [HDMediator.sharedInstance navigaveToYumNowController:nil];
    } else if (model.businessTypeList.firstObject.unsignedIntegerValue == SACouponTicketBusinessLineTinhNow) {
        [self.viewController.navigationController popToRootViewControllerAnimated:false];
        [HDMediator.sharedInstance navigaveToTinhNowController:nil];
    } else {
        [SAWindowManager switchWindowToMainTabBarController];
    }
}

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        SATableView *tableView = SATableView.new;
        tableView.tableHeaderView = self.headerIV;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.needRefreshFooter = false;
        tableView.needRefreshHeader = false;
        tableView.backgroundColor = UIColor.clearColor;
        tableView.estimatedRowHeight = kRealWidth(118);
        tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView = tableView;
    }
    return _tableView;
}

- (UIImageView *)headerIV {
    if (!_headerIV) {
        _headerIV = UIImageView.new;
        if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeCN]) {
            _headerIV.image = [UIImage imageNamed:@"coupon_header_cn"];
        } else if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeEN]) {
            _headerIV.image = [UIImage imageNamed:@"coupon_header_en"];
        } else if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeKH]) {
            _headerIV.image = [UIImage imageNamed:@"coupon_header_km"];
        }
        _headerIV.frame = CGRectMake(0, 0, kScreenWidth, 110.0 / 375.0 * kScreenWidth);
    }
    return _headerIV;
}

@end
