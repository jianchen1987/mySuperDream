//
//  SACancellationApplicationRemindView.m
//  SuperApp
//
//  Created by Tia on 2022/6/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACancellationApplicationRemindView.h"

/// 注销账号提醒文本控件
@interface SACancellationApplicationRemindItemView : SAView
/// 小灰点
@property (nonatomic, strong) UIView *point;
/// 文本
@property (nonatomic, strong) SALabel *label;

@end


@implementation SACancellationApplicationRemindItemView

- (void)hd_setupViews {
    [self addSubview:self.point];
    [self addSubview:self.label];
}

- (void)updateConstraints {
    [self.point mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(4, 4));
        make.left.mas_equalTo(kRealWidth(12));
        make.top.mas_equalTo(kRealWidth(5));
    }];

    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.point.mas_right).offset(kRealWidth(4));
        make.right.mas_equalTo(-kRealWidth(12));
        make.top.equalTo(self);
        make.bottom.mas_equalTo(-kRealWidth(10));
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (UIView *)point {
    if (!_point) {
        _point = UIView.new;
        _point.backgroundColor = [UIColor hd_colorWithHexString:@"#666666"];
        _point.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:2];
        };
    }
    return _point;
}

- (SALabel *)label {
    if (!_label) {
        _label = SALabel.new;
        _label.hd_lineSpace = 5;
        _label.numberOfLines = 0;
        _label.font = HDAppTheme.font.standard4;
        _label.textColor = [UIColor hd_colorWithHexString:@"#666666"];
    }
    return _label;
}

@end


@interface SACancellationApplicationRemindView ()
/// icon
@property (nonatomic, strong) UIImageView *bgIV;
/// 重要提示文言
@property (nonatomic, strong) SALabel *tipsLB;
/// 容器
@property (nonatomic, strong) UIView *tipsView;
/// 注销前提示文言
@property (nonatomic, strong) SALabel *subTipsLB;
/// 提醒文言数据数组
@property (nonatomic, strong) NSArray *tipsItemList;
/// 备注提醒文言
@property (nonatomic, strong) SALabel *remarkLB;
/// 下一步按钮
@property (nonatomic, strong) SAOperationButton *nextBtn;

@end


@implementation SACancellationApplicationRemindView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.color.normalBackground;

    [self addSubview:self.bgIV];
    [self addSubview:self.tipsLB];
    [self addSubview:self.tipsView];
    [self.tipsView addSubview:self.subTipsLB];
    [self addSubview:self.remarkLB];
    [self addSubview:self.nextBtn];
}

- (void)updateConstraints {
    CGFloat margin = kRealWidth(12);
    [self.bgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.right.equalTo(self);
    }];

    [self.tipsLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.top.equalTo(self);
        make.height.mas_equalTo(kRealWidth(94));
    }];

    [self.tipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        make.top.equalTo(self.tipsLB.mas_bottom);
    }];

    [self.subTipsLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        make.top.mas_equalTo(kRealWidth(kRealWidth(16)));
    }];

    UIView *lastView = nil;
    for (SACancellationApplicationRemindItemView *view in self.tipsItemList) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!lastView) {
                make.top.equalTo(self.subTipsLB.mas_bottom).offset(margin);
            } else {
                make.top.equalTo(lastView.mas_bottom);
            }
            make.left.right.equalTo(self.tipsView);
            if (view == self.tipsItemList.lastObject) {
                make.bottom.equalTo(self.tipsView).offset(-margin);
            }
        }];
        lastView = view;
    }

    [self.remarkLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.tipsView);
        make.top.equalTo(self.tipsView.mas_bottom).offset(margin);
    }];

    [self.nextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.height.mas_equalTo(HDAppTheme.value.buttonHeight);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-(kiPhoneXSeriesSafeBottomHeight + kRealWidth(20)));
    }];

    [super updateConstraints];
}

#pragma mark - event response
- (void)clickedNextBtnHandler {
    !self.nextBlock ?: self.nextBlock();
}

#pragma mark - lazy load
- (UIImageView *)bgIV {
    if (!_bgIV) {
        _bgIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ac_bg"]];
    }
    return _bgIV;
}

- (SALabel *)tipsLB {
    if (!_tipsLB) {
        SALabel *l = SALabel.new;
        l.text = SALocalizedString(@"ac_important_alert", @"重要提示");
        l.font = [HDAppTheme.font boldForSize:20];
        l.textColor = UIColor.whiteColor;
        _tipsLB = l;
    }
    return _tipsLB;
}

- (UIView *)tipsView {
    if (!_tipsView) {
        _tipsView = UIView.new;
        _tipsView.backgroundColor = UIColor.whiteColor;
        _tipsView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    return _tipsView;
}

- (SALabel *)subTipsLB {
    if (!_subTipsLB) {
        SALabel *l = SALabel.new;
        l.hd_lineSpace = 5;
        l.numberOfLines = 0;
        l.font = [HDAppTheme.font boldForSize:14];
        l.text = SALocalizedString(@"ac_tips3", @"注销前请认真阅读以下重要提醒。账号注销后，您将无法再使用该账号，包括但不限于：");
        _subTipsLB = l;
    }
    return _subTipsLB;
}

- (NSArray *)tipsItemList {
    if (!_tipsItemList) {
        NSArray *list = @[
            SALocalizedString(@"ac_tips11", @"您将无法登录及使用WOWNOW APP 账号，并移除该账号下所有登录方式"),
            SALocalizedString(@"ac_tips12", @"您的所有业务订单及交易信息将被清空"),
            SALocalizedString(@"ac_tips13", @"您的积分、成长值、各类优惠券等权益将被清空且无法恢复"),
            SALocalizedString(@"ac_tips14", @"您的个人资料、实名认证等身份信息将被清空，无法恢复"),
            SALocalizedString(@"ac_tips15", @"以及您在使用各产品/服务时留存的其他信息")
        ];
        NSMutableArray *tipsItemList = NSMutableArray.new;
        for (NSString *str in list) {
            SACancellationApplicationRemindItemView *v = SACancellationApplicationRemindItemView.new;
            v.label.text = str;
            [self.tipsView addSubview:v];
            [tipsItemList addObject:v];
        }
        _tipsItemList = tipsItemList;
    }
    return _tipsItemList;
}

- (SALabel *)remarkLB {
    if (!_remarkLB) {
        SALabel *l = SALabel.new;
        l.hd_lineSpace = 5;
        l.numberOfLines = 0;
        l.font = [HDAppTheme.font forSize:11];
        l.textColor = [UIColor hd_colorWithHexString:@"999999"];
        l.text = SALocalizedString(@"ac_tips21", @"请确保所有交易已完结且无纠纷，钱包金额全部提现完毕；账号注销后因历史交易可能产生的退换货、维权相关的资金退回等权益将视为自动放弃；");
        _remarkLB = l;
    }
    return _remarkLB;
}

- (SAOperationButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn addTarget:self action:@selector(clickedNextBtnHandler) forControlEvents:UIControlEventTouchUpInside];
        [_nextBtn setTitle:SALocalizedStringFromTable(@"next_step", @"下一步", @"Buttons") forState:UIControlStateNormal];
        [_nextBtn applyPropertiesWithBackgroundColor:HDAppTheme.color.sa_C1];
    }
    return _nextBtn;
}

@end
