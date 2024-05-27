//
//  GNStoreOrderFootView.m
//  SuperApp
//
//  Created by wmz on 2021/6/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNStoreOrderFootView.h"
#import "GNEnum.h"


@interface GNStoreOrderFootView ()
/// 总计
@property (nonatomic, strong) HDLabel *allLB;
/// 价格
@property (nonatomic, strong) HDLabel *priceLB;
/// 提交
@property (nonatomic, strong) HDUIButton *commitBtn;
/// 能够提交
@property (nonatomic, assign) BOOL canSubmit;

@end


@implementation GNStoreOrderFootView

- (void)hd_setupViews {
    [self addSubview:self.allLB];
    [self addSubview:self.priceLB];
    [self addSubview:self.commitBtn];
    self.backgroundColor = HDAppTheme.color.gn_whiteColor;
}

- (void)updateConstraints {
    [self.allLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(HDAppTheme.value.gn_marginL);
        make.height.mas_greaterThanOrEqualTo(kRealWidth(24));
    }];

    [self.commitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-(kiPhoneXSeriesSafeBottomHeight ? (kiPhoneXSeriesSafeBottomHeight + kRealWidth(8)) : kRealWidth(16)));
        make.top.equalTo(self.allLB.mas_bottom).offset(kRealWidth(16));
        make.left.mas_equalTo(HDAppTheme.value.gn_marginL);
        make.height.mas_equalTo(kRealWidth(44));
        make.right.mas_offset(-HDAppTheme.value.gn_marginL);
    }];

    [self.priceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-HDAppTheme.value.gn_marginL);
        make.centerY.equalTo(self.allLB);
        make.left.equalTo(self.allLB.mas_right).offset(kRealWidth(8));
    }];

    [self.priceLB setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.priceLB setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [super updateConstraints];
}

///下单
- (void)orderAction {
    [GNEvent eventResponder:self target:self.commitBtn key:@"orderAction"];
}

- (void)setGNModel:(GNOrderRushBuyModel *)data {
    self.allLB.text = GNLocalizedString(@"gn_order_total", @"总计");
    self.priceLB.text = [NSString stringWithFormat:@"%@", GNFillMonEmpty(data.allPrice)];
    if (data.whetherHomePurchaseRestrictions == GNHomePurchaseRestrictionsTypeCan) {
        self.canSubmit = (data.customAmount >= 1) && (data.customAmount <= data.homePurchaseRestrictions);
    } else {
        self.canSubmit = (data.customAmount >= 1);
    }
}

- (void)setCanSubmit:(BOOL)canSubmit {
    _canSubmit = canSubmit;
    self.commitBtn.layer.backgroundColor = canSubmit ? HDAppTheme.color.gn_mainColor.CGColor : [HDAppTheme.color.gn_mainColor colorWithAlphaComponent:0.3].CGColor;
    self.commitBtn.userInteractionEnabled = canSubmit;
}

- (HDLabel *)allLB {
    if (!_allLB) {
        _allLB = HDLabel.new;
        _allLB.font = [HDAppTheme.font gn_ForSize:16 weight:UIFontWeightMedium];
        _allLB.textColor = HDAppTheme.color.gn_333Color;
    }
    return _allLB;
}

- (HDLabel *)priceLB {
    if (!_priceLB) {
        _priceLB = HDLabel.new;
        _priceLB.font = [HDAppTheme.WMFont wm_ForSize:20 fontName:@"DIN-Bold"];
        _priceLB.textColor = HDAppTheme.color.gn_333Color;
        _priceLB.textAlignment = NSTextAlignmentRight;
    }
    return _priceLB;
}

- (HDUIButton *)commitBtn {
    if (!_commitBtn) {
        _commitBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _commitBtn.titleLabel.font = [HDAppTheme.font gn_boldForSize:16.0];
        [_commitBtn setTitleColor:HDAppTheme.color.gn_whiteColor forState:UIControlStateNormal];
        [_commitBtn setTitle:GNLocalizedString(@"gn_submit", @"提交") forState:UIControlStateNormal];
        _commitBtn.layer.cornerRadius = kRealHeight(22);
        [_commitBtn addTarget:self action:@selector(orderAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

@end
