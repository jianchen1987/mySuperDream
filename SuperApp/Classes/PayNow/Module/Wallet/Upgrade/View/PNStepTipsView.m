//
//  PNStepTipsView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/1/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNStepTipsView.h"
#import "PNStepItemView.h"


@interface PNStepTipsView ()

@property (nonatomic, strong) PNStepItemView *firstView;
@property (nonatomic, strong) PNStepItemView *secondView;
@property (nonatomic, strong) PNStepItemView *thirdView;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;

@end


@implementation PNStepTipsView
- (void)setStep:(NSInteger)step {
    _step = step;

    PNStepItemModel *model = PNStepItemModel.new;
    model.numStr = @"2";
    model.tipsStr = PNLocalizedString(@"Upload_information", @"上传证件信息");

    if (self.step == 1) {
        model.isHighlight = NO;
        self.line1.backgroundColor = HDAppTheme.PayNowColor.cFD7127;
        self.line2.backgroundColor = HDAppTheme.PayNowColor.cECECEC;
    } else {
        model.isHighlight = YES;
        self.line1.backgroundColor = HDAppTheme.PayNowColor.cFD7127;
        self.line2.backgroundColor = HDAppTheme.PayNowColor.cFD7127;
    }
    self.secondView.model = model;
}

- (void)setUpgradeStatus:(PNAccountLevelUpgradeStatus)upgradeStatus {
    _upgradeStatus = upgradeStatus;

    PNStepItemModel *model = PNStepItemModel.new;
    model.numStr = @"3";

    if (upgradeStatus == PNAccountLevelUpgradeStatus_INTERMEDIATE_UPGRADEING) {
        model.tipsStr = PNLocalizedString(@"Under_upgrade", @"升级中");
        model.isHighlight = NO;
        self.line1.backgroundColor = HDAppTheme.PayNowColor.cFD7127;
        self.line2.backgroundColor = HDAppTheme.PayNowColor.cECECEC;
    } else if (upgradeStatus == PNAccountLevelUpgradeStatus_INTERMEDIATE_FAILED) {
        model.tipsStr = PNLocalizedString(@"Upgrade_fail", @"升级失败");
        model.isHighlight = YES;
        self.line1.backgroundColor = HDAppTheme.PayNowColor.cFD7127;
        self.line2.backgroundColor = HDAppTheme.PayNowColor.cFD7127;
    } else if (upgradeStatus == PNAccountLevelUpgradeStatus_INTERMEDIATE_SUCCESS) {
        model.tipsStr = PNLocalizedString(@"Upgrade_succeed", @"升级成功");
        model.isHighlight = YES;
        self.line1.backgroundColor = HDAppTheme.PayNowColor.cFD7127;
        self.line2.backgroundColor = HDAppTheme.PayNowColor.cFD7127;
    }

    self.thirdView.model = model;
}

#pragma mark
- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
    [self addSubview:self.firstView];
    [self addSubview:self.secondView];
    [self addSubview:self.thirdView];
    [self addSubview:self.line1];
    [self addSubview:self.line2];
}

- (void)updateConstraints {
    NSInteger itemCount = 3;
    CGFloat spaceLF = kRealWidth(15);
    CGFloat itemSpace = kRealWidth(5);
    CGFloat itemWidth = (kScreenWidth - (2 * spaceLF) - ((itemCount - 1) * itemSpace)) / itemCount;

    [self.firstView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spaceLF);
        make.width.equalTo(@(itemWidth));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(15));
        make.bottom.mas_equalTo(self.mas_bottom).offset(kRealWidth(-15));
    }];
    [self.secondView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.firstView.mas_right).offset(itemSpace);
        make.centerY.mas_equalTo(self.firstView.mas_centerY);
        make.width.mas_equalTo(self.firstView.mas_width);
    }];
    [self.thirdView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.secondView.mas_right).offset(itemSpace);
        make.centerY.mas_equalTo(self.firstView.mas_centerY);
        make.width.mas_equalTo(self.firstView.mas_width);
    }];

    [self.line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(kRealWidth(1)));
        make.left.mas_equalTo(self.firstView.mas_right).offset(kRealWidth(-25));
        make.right.mas_equalTo(self.secondView.mas_left).offset(kRealWidth(25));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(26));
    }];

    [self.line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(kRealWidth(1)));
        make.left.mas_equalTo(self.secondView.mas_right).offset(kRealWidth(-25));
        make.right.mas_equalTo(self.thirdView.mas_left).offset(kRealWidth(25));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(26));
    }];

    [super updateConstraints];
}

#pragma mark
- (PNStepItemView *)firstView {
    if (!_firstView) {
        _firstView = [[PNStepItemView alloc] init];
        PNStepItemModel *model = PNStepItemModel.new;
        model.numStr = @"1";
        model.tipsStr = PNLocalizedString(@"Confirm_information", @"确认实名信息");
        model.isHighlight = YES;
        _firstView.model = model;
    }
    return _firstView;
}

- (PNStepItemView *)secondView {
    if (!_secondView) {
        _secondView = [[PNStepItemView alloc] init];
        PNStepItemModel *model = PNStepItemModel.new;
        model.numStr = @"2";
        model.tipsStr = PNLocalizedString(@"Upload_information", @"上传证件信息");
        model.isHighlight = YES;
        _secondView.model = model;
    }
    return _secondView;
}

- (PNStepItemView *)thirdView {
    if (!_thirdView) {
        _thirdView = [[PNStepItemView alloc] init];
        PNStepItemModel *model = PNStepItemModel.new;
        model.numStr = @"3";
        model.tipsStr = PNLocalizedString(@"Submit_approval", @"提交人工审核");
        model.isHighlight = NO;
        _thirdView.model = model;
    }
    return _thirdView;
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = HDAppTheme.PayNowColor.cFD7127;
    }
    return _line1;
}

- (UIView *)line2 {
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = HDAppTheme.PayNowColor.lineColor;
    }
    return _line2;
}
@end
