//
//  TNFreightDetailAlertView.m
//  SuperApp
//
//  Created by 张杰 on 2022/8/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNFreightDetailAlertView.h"
#import "SAInfoView.h"
//#import <Masonry/Masonry.h>
//#import <HDKitCore/HDKitCore.h>
#import "HDAppTheme+TinhNow.h"
#import "SAMoneyModel.h"
#import "SAMoneyTools.h"
#import "TNMultiLanguageManager.h"


@interface TNFreightDetailAlertView ()
/// 标题
@property (strong, nonatomic) UILabel *titleLabel;
/// 基础运费
@property (strong, nonatomic) SAInfoView *baseFreightInfoView;
/// 额外运费
@property (strong, nonatomic) SAInfoView *additionalFreightInfoView;
/// 分割线
@property (strong, nonatomic) UIView *lineView;
/// 合计总运费
@property (strong, nonatomic) SAInfoView *totalFreightInfoView;
/// 关闭按钮
@property (strong, nonatomic) HDUIButton *confirBtn;
/// 基础运费
@property (strong, nonatomic) SAMoneyModel *baseFreight;
/// 额外运费
@property (strong, nonatomic) SAMoneyModel *additionalFreight;
@end


@implementation TNFreightDetailAlertView
- (instancetype)initWithBaseFreight:(SAMoneyModel *)baseFreight additionalFreight:(SAMoneyModel *)additionalFreight {
    if (self = [super init]) {
        self.baseFreight = baseFreight;
        self.additionalFreight = additionalFreight;
        self.backgroundStyle = HDActionAlertViewBackgroundStyleSolid;
        self.transitionStyle = HDActionAlertViewTransitionStyleBounce;
        self.allowTapBackgroundDismiss = YES;
    }
    return self;
}

- (void)layoutContainerView {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(kRealWidth(35));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(35));
    }];
}
/// 设置containerview的属性,比如切边啥的
- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.layer.masksToBounds = YES;
    self.allowTapBackgroundDismiss = YES;
    self.containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:8];
    };
}
/// 给containerview添加子视图
- (void)setupContainerSubViews {
    [self.containerView addSubview:self.titleLabel];
    //合计
    NSInteger totol = 0;
    SACurrencyType cy;
    if (!HDIsObjectNil(self.baseFreight) && self.baseFreight.cent.integerValue > 0) {
        SAInfoViewModel *infoModel = [self getBaseInfoModel];
        infoModel.keyText = TNLocalizedString(@"tn_order_basefreight", @"订单基础运费");
        infoModel.valueText = [NSString stringWithFormat:@"+%@", self.baseFreight.thousandSeparatorAmount];
        self.baseFreightInfoView.hidden = NO;
        self.baseFreightInfoView.model = infoModel;
        [self.containerView addSubview:self.baseFreightInfoView];

        totol += [self.baseFreight.cent integerValue];
        cy = self.baseFreight.cy;
    } else {
        self.baseFreightInfoView.hidden = YES;
    }

    if (!HDIsObjectNil(self.additionalFreight) && self.additionalFreight.cent.integerValue > 0) {
        SAInfoViewModel *infoModel = [self getBaseInfoModel];
        infoModel.keyText = TNLocalizedString(@"tn_order_additionalfreight", @"预约额外运费");
        infoModel.valueText = [NSString stringWithFormat:@"+%@", self.additionalFreight.thousandSeparatorAmount];
        self.additionalFreightInfoView.hidden = NO;
        self.additionalFreightInfoView.model = infoModel;
        [self.containerView addSubview:self.additionalFreightInfoView];

        totol += [self.additionalFreight.cent integerValue];
        cy = self.additionalFreight.cy;
    } else {
        self.additionalFreightInfoView.hidden = YES;
    }

    [self.containerView addSubview:self.lineView];
    SAInfoViewModel *infoModel = [self getBaseInfoModel];
    infoModel.keyText = TNLocalizedString(@"tn_total_k", @"合计");
    NSString *totolStr = [SAMoneyTools thousandSeparatorAmountYuan:[SAMoneyTools fenToyuan:[NSString stringWithFormat:@"%zd", totol]] currencyCode:cy];
    infoModel.valueText = [NSString stringWithFormat:@"+%@", totolStr];
    infoModel.valueColor = HDAppTheme.TinhNowColor.cFF2323;
    infoModel.valueFont = [HDAppTheme.TinhNowFont fontMedium:17];
    self.totalFreightInfoView.model = infoModel;
    [self.containerView addSubview:self.totalFreightInfoView];

    [self.containerView addSubview:self.confirBtn];
}
- (SAInfoViewModel *)getBaseInfoModel {
    SAInfoViewModel *infoModel = [[SAInfoViewModel alloc] init];
    infoModel.keyColor = HDAppTheme.TinhNowColor.G1;
    infoModel.keyFont = HDAppTheme.TinhNowFont.standard14;
    infoModel.valueFont = HDAppTheme.TinhNowFont.standard14;
    infoModel.valueColor = HDAppTheme.TinhNowColor.G1;
    infoModel.lineWidth = 0;
    return infoModel;
}
/// 子视图布局
- (void)layoutContainerViewSubViews {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).offset(kRealWidth(12));
        make.centerX.equalTo(self.containerView.mas_centerX);
    }];
    UIView *topView = self.titleLabel;
    if (!self.baseFreightInfoView.isHidden) {
        [self.baseFreightInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.containerView);
            make.top.equalTo(topView.mas_bottom).offset(24);
            make.height.mas_equalTo(kRealWidth(45));
        }];
        topView = self.baseFreightInfoView;
    }
    if (!self.additionalFreightInfoView.isHidden) {
        [self.additionalFreightInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.containerView);
            make.top.equalTo(topView.mas_bottom).offset(!self.baseFreightInfoView.isHidden ? 0 : 24);
            make.height.mas_equalTo(kRealWidth(45));
        }];
        topView = self.additionalFreightInfoView;
    }
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(topView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];

    [self.totalFreightInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.top.equalTo(self.lineView.mas_bottom);
        make.height.mas_equalTo(kRealWidth(45));
    }];

    [self.confirBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.containerView);
        make.top.equalTo(self.totalFreightInfoView.mas_bottom);
        make.height.mas_equalTo(kRealWidth(45));
    }];
}
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:15];
        _titleLabel.text = TNLocalizedString(@"m7q6Rfk6", @"运费明细");
    }
    return _titleLabel;
}
/** @lazy baseFreightInfoView */
- (SAInfoView *)baseFreightInfoView {
    if (!_baseFreightInfoView) {
        _baseFreightInfoView = [[SAInfoView alloc] init];
    }
    return _baseFreightInfoView;
}
/** @lazy additionalFreightInfoView */
- (SAInfoView *)additionalFreightInfoView {
    if (!_additionalFreightInfoView) {
        _additionalFreightInfoView = [[SAInfoView alloc] init];
    }
    return _additionalFreightInfoView;
}
/** @lazy totalFreightInfoView */
- (SAInfoView *)totalFreightInfoView {
    if (!_totalFreightInfoView) {
        _totalFreightInfoView = [[SAInfoView alloc] init];
    }
    return _totalFreightInfoView;
}
/** @lazy lineView */
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HDAppTheme.TinhNowColor.G4;
    }
    return _lineView;
}
/** @lazy confirBtn */
- (HDUIButton *)confirBtn {
    if (!_confirBtn) {
        _confirBtn = [[HDUIButton alloc] init];
        _confirBtn.backgroundColor = HDAppTheme.TinhNowColor.cF5F7FA;
        _confirBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        [_confirBtn setTitle:TNLocalizedString(@"1GuBJmHn", @"我知道了") forState:UIControlStateNormal];
        [_confirBtn setTitleColor:HDAppTheme.TinhNowColor.cFF2323 forState:UIControlStateNormal];
        @HDWeakify(self);
        [_confirBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
        }];
    }
    return _confirBtn;
}
@end
