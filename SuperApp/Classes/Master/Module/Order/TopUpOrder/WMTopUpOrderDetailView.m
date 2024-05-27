//
//  WMTopUpOrderDetailView.m
//  SuperApp
//
//  Created by Chaos on 2020/6/24.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInfoView.h"
#import "SATopUpOrderDetailModel.h"
#import "SATopUpOrderDetailView.h"


@interface SATopUpOrderDetailView ()

/// 顶部背景
@property (nonatomic, strong) UIView *topBgView;
/// 充值标题
@property (nonatomic, strong) SALabel *titleLabel;
/// 充值状态
@property (nonatomic, strong) SALabel *stautsLabel;
/// 充值金额
@property (nonatomic, strong) SALabel *topUpLabel;
/// 订单金额
@property (nonatomic, strong) SAInfoView *orderMoneyInfoView;

/// 底部背景
@property (nonatomic, strong) UIView *bottomBgView;
/// infoView 数组
@property (nonatomic, strong) NSArray<SAInfoView *> *infoViewArray;
/// 付款账号
@property (nonatomic, strong) SAInfoView *payAccountInfoView;
/// 收款方
@property (nonatomic, strong) SAInfoView *receiveAccountInfoView;
/// 账单分类
@property (nonatomic, strong) SAInfoView *orderClassifyInfoView;
/// 订单
@property (nonatomic, strong) SAInfoView *goodInstructionInfoView;
/// 创建时间
@property (nonatomic, strong) SAInfoView *createTimeView;
/// 订单号
@property (nonatomic, strong) SAInfoView *orderNoInfoView;

@end


@implementation SATopUpOrderDetailView

- (void)hd_setupViews {
    [self addSubview:self.topBgView];

    [self.topBgView addSubview:self.titleLabel];
    [self.topBgView addSubview:self.stautsLabel];
    [self.topBgView addSubview:self.topUpLabel];
    [self.topBgView addSubview:self.orderMoneyInfoView];

    [self addSubview:self.bottomBgView];
    [self.bottomBgView addSubview:self.payAccountInfoView];
    [self.bottomBgView addSubview:self.receiveAccountInfoView];
    [self.bottomBgView addSubview:self.orderClassifyInfoView];
    [self.bottomBgView addSubview:self.goodInstructionInfoView];
    [self.bottomBgView addSubview:self.createTimeView];
    [self.bottomBgView addSubview:self.orderNoInfoView];

    self.infoViewArray = @[self.payAccountInfoView, self.receiveAccountInfoView, self.orderClassifyInfoView, self.goodInstructionInfoView, self.createTimeView, self.orderNoInfoView];
}

- (void)updateConstraints {
    [self.topBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBgView.mas_top).offset(kRealWidth(30));
        make.left.equalTo(self.topBgView.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.topBgView.mas_right).offset(-HDAppTheme.value.padding.right);
    }];

    [self.stautsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(5));
        make.left.right.equalTo(self.titleLabel);
    }];

    [self.topUpLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stautsLabel.mas_bottom).offset(kRealWidth(10));
        make.left.right.equalTo(self.stautsLabel);
    }];

    [self.orderMoneyInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topUpLabel.mas_bottom).offset(kRealWidth(30));
        make.left.equalTo(self.topBgView.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.topBgView.mas_right).offset(-HDAppTheme.value.padding.right);
        make.bottom.equalTo(self.topBgView.mas_bottom);
    }];

    [self.bottomBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBgView.mas_bottom).offset(kRealWidth(14));
        make.left.right.equalTo(self);
    }];

    NSArray<SAInfoView *> *infoViewArray = [self.infoViewArray hd_filterWithBlock:^BOOL(SAInfoView *_Nonnull item) {
        return !item.isHidden;
    }];

    UIView *lastView = nil;
    for (SAInfoView *infoView in infoViewArray) {
        [infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomBgView.mas_left).offset(HDAppTheme.value.padding.left);
            make.right.greaterThanOrEqualTo(self.bottomBgView.mas_right).offset(-HDAppTheme.value.padding.right);
            if (!lastView) {
                make.top.equalTo(self.bottomBgView.mas_top);
            } else {
                make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(10));
            }
            if (infoView == infoViewArray.lastObject) {
                make.bottom.equalTo(self.bottomBgView.mas_bottom);
            }
        }];
        lastView = infoView;
    }

    [super updateConstraints];
}

#pragma mark - setter
- (void)setModel:(SATopUpOrderDetailModel *)model {
    _model = model;

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (UIView *)topBgView {
    if (!_topBgView) {
        _topBgView = [[UIView alloc] init];
    }
    return _topBgView;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[SALabel alloc] init];
        _titleLabel.textColor = HDAppTheme.color.G1;
        _titleLabel.font = HDAppTheme.font.standard2;
    }
    return _titleLabel;
}

- (SALabel *)stautsLabel {
    if (!_stautsLabel) {
        _stautsLabel = [[SALabel alloc] init];
        _stautsLabel.textColor = HDAppTheme.color.G3;
        _stautsLabel.font = HDAppTheme.font.standard4;
    }
    return _stautsLabel;
}

- (SALabel *)topUpLabel {
    if (!_topUpLabel) {
        _topUpLabel = [[SALabel alloc] init];
        _topUpLabel.textColor = HDAppTheme.color.G1;
        _topUpLabel.font = HDAppTheme.font.amountOnly;
    }
    return _topUpLabel;
}

- (SAInfoView *)orderMoneyInfoView {
    if (!_orderMoneyInfoView) {
        _orderMoneyInfoView = [[SAInfoView alloc] init];

        SAInfoViewModel *model = [[SAInfoViewModel alloc] init];
        model.keyText = WMLocalizedString(@"Ki8ZBMsK", @"订单金额");
        model.valueTextAlignment = NSTextAlignmentLeft;
        _orderMoneyInfoView.model = model;
    }
    return _orderMoneyInfoView;
}

- (UIView *)bottomBgView {
    if (!_bottomBgView) {
        _bottomBgView = [[UIView alloc] init];
    }
    return _bottomBgView;
}

- (SAInfoView *)payAccountInfoView {
    if (!_payAccountInfoView) {
        _payAccountInfoView = [[SAInfoView alloc] init];

        SAInfoViewModel *model = [[SAInfoViewModel alloc] init];
        model.keyText = WMLocalizedString(@"KA8ZBMsK", @"付款账号");
        model.valueTextAlignment = NSTextAlignmentLeft;
        _payAccountInfoView.model = model;
    }
    return _payAccountInfoView;
}

- (SAInfoView *)receiveAccountInfoView {
    if (!_receiveAccountInfoView) {
        _receiveAccountInfoView = [[SAInfoView alloc] init];

        SAInfoViewModel *model = [[SAInfoViewModel alloc] init];
        model.keyText = WMLocalizedString(@"Ks8ZBMsK", @"收款方");
        model.valueTextAlignment = NSTextAlignmentLeft;
        _receiveAccountInfoView.model = model;
    }
    return _receiveAccountInfoView;
}

- (SAInfoView *)orderClassifyInfoView {
    if (!_orderClassifyInfoView) {
        _orderClassifyInfoView = [[SAInfoView alloc] init];

        SAInfoViewModel *model = [[SAInfoViewModel alloc] init];
        model.keyText = WMLocalizedString(@"Km8ZBMsK", @"账单分类");
        model.valueTextAlignment = NSTextAlignmentLeft;
        _orderClassifyInfoView.model = model;
    }
    return _orderClassifyInfoView;
}

- (SAInfoView *)goodInstructionInfoView {
    if (!_goodInstructionInfoView) {
        _goodInstructionInfoView = [[SAInfoView alloc] init];

        SAInfoViewModel *model = [[SAInfoViewModel alloc] init];
        model.keyText = WMLocalizedString(@"KM8ZBMsK", @"商品说明");
        model.valueTextAlignment = NSTextAlignmentLeft;
        _goodInstructionInfoView.model = model;
    }
    return _goodInstructionInfoView;
}

- (SAInfoView *)createTimeView {
    if (!_createTimeView) {
        _createTimeView = [[SAInfoView alloc] init];

        SAInfoViewModel *model = [[SAInfoViewModel alloc] init];
        model.keyText = WMLocalizedString(@"K08ZBMsK", @"创建时间");
        model.valueTextAlignment = NSTextAlignmentLeft;
        _createTimeView.model = model;
    }
    return _createTimeView;
}

- (SAInfoView *)orderNoInfoView {
    if (!_orderNoInfoView) {
        _orderNoInfoView = [[SAInfoView alloc] init];

        SAInfoViewModel *model = [[SAInfoViewModel alloc] init];
        model.keyText = WMLocalizedString(@"order_number", @"订单号");
        model.valueTextAlignment = NSTextAlignmentLeft;
        _orderNoInfoView.model = model;
    }
    return _orderNoInfoView;
}

@end
