//
//  SAWalletView.m
//  SuperApp
//
//  Created by VanJay on 2020/8/17.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAWalletView.h"
#import "SATableView.h"
#import "SAWalletTableViewCell.h"
#import "SAWalletViewModel.h"
#import "SAAppTheme.h"


@interface SAWalletView () <UITableViewDelegate, UITableViewDataSource>
/// VM
@property (nonatomic, strong) SAWalletViewModel *viewModel;
/// 列表
@property (nonatomic, strong) SATableView *tableView;
/// 数据源
@property (nonatomic, copy) NSArray<SAWalletItemModel *> *dataSource;
/// 充值按钮
@property (nonatomic, strong) SAOperationButton *chargeBTN;
/// 服务由CoolCash提供支持
@property (nonatomic, strong) SALabel *coolCashLabel;
@end


@implementation SAWalletView
#pragma mark - SAViewProtocol
- (void)hd_setupViews {
    [self addSubview:self.tableView];
    [self addSubview:self.chargeBTN];
    [self addSubview:self.coolCashLabel];

    @HDWeakify(self);
    self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        [self.viewModel getNewData];
    };
}

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    self.dataSource = self.viewModel.dataSource;
    [self.tableView successGetNewDataWithNoMoreData:true];

    @HDWeakify(self);
    self.viewModel.successGetNewDataBlock = ^(NSArray<SAWalletItemModel *> *_Nonnull dataSource) {
        @HDStrongify(self);
        self.dataSource = dataSource;
        [self.tableView successGetNewDataWithNoMoreData:false];
    };
    self.viewModel.failedGetNewDataBlock = ^(NSArray<SAWalletItemModel *> *_Nonnull dataSource) {
        @HDStrongify(self);
        [self.tableView failGetNewData];
    };
}

#pragma mark - SAMultiLanguageRespond
- (void)hd_languageDidChanged {
}

#pragma mark - event response

#pragma mark - public methods
- (void)getNewData {
    [self.tableView getNewData];
}

#pragma mark - private methods
- (void)clickedOnRechargeButton:(SAOperationButton *)button {
    //    [HDMediator.sharedInstance navigaveToWalletChargeViewController:nil];
    [self.viewModel queryAvaliableChannelFinish:^(NSUInteger count) {
        if (count > 0) {
            [HDMediator.sharedInstance navigaveToWalletChargeViewController:nil];
        } else {
            [NAT showAlertWithMessage:SALocalizedString(@"no_avaliable_channel_alert", @"钱包充值维护中，请稍后再试！") buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                              handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                  [alertView dismiss];
                              }];
        }
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataSource.count)
        return UITableViewCell.new;
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:SAWalletItemModel.class]) {
        SAWalletTableViewCell *cell = [SAWalletTableViewCell cellWithTableView:tableView];
        SAWalletItemModel *trueModel = (SAWalletItemModel *)model;
        trueModel.isFirst = indexPath.row == 0;
        trueModel.isLast = indexPath.row == self.dataSource.count - 1;
        cell.model = trueModel;
        return cell;
    }
    return UITableViewCell.new;
}

#pragma mark - layout
- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.chargeBTN.mas_top).offset(-kRealWidth(30));
    }];

    [self.chargeBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(HDAppTheme.value.buttonHeight);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.coolCashLabel.mas_top).offset(-kRealWidth(20));
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(kRealWidth(20));
    }];

    [self.coolCashLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self).offset(-HDAppTheme.value.padding.right);
        make.bottom.equalTo(self).offset(-(kiPhoneXSeriesSafeBottomHeight + kRealWidth(20)));
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = true;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
    }
    return _tableView;
}

- (SAOperationButton *)chargeBTN {
    if (!_chargeBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [button setTitle:SALocalizedString(@"top_up", @"充值") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickedOnRechargeButton:) forControlEvents:UIControlEventTouchUpInside];
        _chargeBTN = button;
    }
    return _chargeBTN;
}

- (SALabel *)coolCashLabel {
    if (!_coolCashLabel) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard4;
        label.textColor = HDAppTheme.color.sa_C2;
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = SALocalizedString(@"Powered_by_CoolCash", @"服务由CoolCash提供支持");
        _coolCashLabel = label;
    }
    return _coolCashLabel;
}
@end
