//
//  PNBillOrderDetailsHeaderView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/4/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNBillOrderDetailsHeaderView.h"
#import "PNCommonUtils.h"
#import "PNWaterBillModel.h"


@interface PNBillOrderDetailsHeaderView ()
@property (nonatomic, strong) UIView *bgColorView;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) SALabel *stateLabel;
@end


@implementation PNBillOrderDetailsHeaderView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
    [self addSubview:self.bgColorView];
    [self addSubview:self.iconImgView];
    [self addSubview:self.stateLabel];
}

- (void)updateConstraints {
    [self.bgColorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@(kRealWidth(65)));
    }];

    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(27), kRealWidth(27)));
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.centerY.mas_equalTo(self.bgColorView.mas_centerY);
    }];

    [self.stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(kRealWidth(10));
        make.centerY.mas_equalTo(self.bgColorView.mas_centerY);
    }];

    [super updateConstraints];
}

#pragma mark
- (void)setModel:(PNWaterBillModel *)model {
    _model = model;

    PNBalancesInfoModel *balancesInfoModel = self.model.balances.firstObject;

    self.iconImgView.image = [UIImage imageNamed:[PNCommonUtils getBillOrderDetailsStattesIconName:balancesInfoModel.billState]];
    self.stateLabel.text = [PNCommonUtils getBillPayStatusName:balancesInfoModel.billState];

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (UIView *)bgColorView {
    if (!_bgColorView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setGradualChangingColorFromColor:HDAppTheme.PayNowColor.cFD7127 toColor:[UIColor hd_colorWithHexString:@"#FFAA4F"]];
        };
        _bgColorView = view;
    }
    return _bgColorView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (SALabel *)stateLabel {
    if (!_stateLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.cFFFFFF;
        label.font = HDAppTheme.PayNowFont.standard17B;
        _stateLabel = label;
    }
    return _stateLabel;
}
@end
