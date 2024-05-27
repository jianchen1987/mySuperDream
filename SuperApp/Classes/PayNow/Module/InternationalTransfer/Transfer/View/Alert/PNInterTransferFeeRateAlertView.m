//
//  PNInterTransferFeeRateAlertView.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferFeeRateAlertView.h"
#import "PNInterTransferRateFeeModel.h"
#import "PNOperationButton.h"
#import "PNTableView.h"
#import "PNTransferFormCell.h"


@interface PNInterTransferFeeRateAlertView () <UITableViewDelegate, UITableViewDataSource>
///
@property (strong, nonatomic) NSMutableArray<PNTransferFormConfig *> *dataSource;
///
@property (strong, nonatomic) PNTableView *tableView;
///
@property (strong, nonatomic) UIImageView *logoImageView;
///
@property (strong, nonatomic) PNOperationButton *closeBtn;
///
@property (strong, nonatomic) PNInterTransferRateFeeModel *feeModel;
@end


@implementation PNInterTransferFeeRateAlertView
- (instancetype)initWithFeeModel:(PNInterTransferRateFeeModel *)feeModel {
    self = [super init];
    if (self) {
        self.feeModel = feeModel;
        self.transitionStyle = HDActionAlertViewTransitionStyleSlideFromBottom;
    }
    return self;
}

#pragma mark - HDActionAlertViewOverridable
- (void)layoutContainerView {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
    }];
}

- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.layer.masksToBounds = YES;
    self.allowTapBackgroundDismiss = YES;
    self.containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:10];
    };
}

- (void)setupContainerSubViews {
    [self.containerView addSubview:self.logoImageView];
    [self.containerView addSubview:self.tableView];
    [self.containerView addSubview:self.closeBtn];

    self.dataSource = [NSMutableArray array];

    if (!HDIsArrayEmpty(self.feeModel.feeInfos)) {
        for (PNInterTransferFeeInfoModel *infoModel in self.feeModel.feeInfos) {
            // 手续费
            PNTransferFormConfig *config = PNTransferFormConfig.new;
            config.keyText =
                [NSString stringWithFormat:@"%@ (%@<=%@%@)", PNLocalizedString(@"pn_charge", @"手续费"), PNLocalizedString(@"kwCIcL1x", @"金额"), infoModel.feeEndAmt.amount, infoModel.feeEndAmt.cy];
            if (infoModel.personalRule.feeCalcType == PNInterTransFeeCalcTypePercent) {
                //百分比
                config.valueText = [NSString stringWithFormat:@"%@%%", infoModel.personalRule.feeRate.amount];
            } else if (infoModel.personalRule.feeCalcType == PNInterTransFeeCalcTypeFixedAmount) {
                //固定金额
                config.valueText = [NSString stringWithFormat:@"%@ %@", infoModel.personalRule.feeFixed.cy, infoModel.personalRule.feeFixed.amount];
            }
            config.editType = PNSTransferFormValueEditTypeShow;
            [self.dataSource addObject:config];
        }
    }

    // 费率
    PNTransferFormConfig *config = PNTransferFormConfig.new;
    config.keyText = PNLocalizedString(@"hbQmFhd0", @"费率");
    config.valueText = [NSString stringWithFormat:@"%@ %@=%@ %@",
                                                  self.feeModel.rateInfo.sourceAmt.currency,
                                                  self.feeModel.rateInfo.sourceAmt.amount,
                                                  self.feeModel.rateInfo.targetAmt.currency,
                                                  self.feeModel.rateInfo.targetAmt.amount];
    config.editType = PNSTransferFormValueEditTypeShow;
    [self.dataSource addObject:config];

    if (!HDIsArrayEmpty(self.feeModel.agreements)) {
        // SLA
        config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"HYsS50Ji", @"特定事项约定");
        config.valueText = [self.feeModel.agreements componentsJoinedByString:@"\n"];
        config.editType = PNSTransferFormValueEditTypeShow;
        config.valueContainerHeight = kRealWidth(120);
        [self.dataSource addObject:config];
    }

    [self.tableView successGetNewDataWithNoMoreData:YES];

    @HDWeakify(self);
    [self.KVOController hd_observe:self.tableView keyPath:@"contentSize" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat height = self.tableView.contentSize.height;
            CGFloat maxHeight = kScreenHeight * 0.6;
            if (height > maxHeight) {
                height = maxHeight;
            }
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height);
            }];
        });
    }];
}

- (void)layoutContainerViewSubViews {
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).offset(kRealWidth(10));
        make.centerX.equalTo(self.containerView.mas_centerX);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.top.equalTo(self.logoImageView.mas_bottom).offset(kRealWidth(10));
        make.height.mas_equalTo(100);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-kRealWidth(15) - kiPhoneXSeriesSafeBottomHeight);
        make.top.equalTo(self.tableView.mas_bottom).offset(kRealWidth(15));
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNTransferFormCell *cell = [PNTransferFormCell cellWithTableView:tableView];
    PNTransferFormConfig *config = self.dataSource[indexPath.row];
    cell.config = config;
    return cell;
}

- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

/** @lazy logoImageView */
- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pn_thunes_logo"]];
        [_logoImageView sizeToFit];
    }
    return _logoImageView;
}

/** @lazy closeBtn */
- (PNOperationButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        _closeBtn.titleLabel.font = [HDAppTheme.PayNowFont fontBold:14];
        _closeBtn.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(9), kRealWidth(16), kRealWidth(9), kRealWidth(16));
        [_closeBtn setTitle:PNLocalizedString(@"close", @"关闭") forState:UIControlStateNormal];
        [_closeBtn sizeToFit];
        @HDWeakify(self);
        [_closeBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
        }];
    }
    return _closeBtn;
}

@end
