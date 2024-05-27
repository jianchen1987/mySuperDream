//
//  WMOrderBoxView.m
//  SuperApp
//
//  Created by wmz on 2022/6/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMOrderBoxView.h"
#import "SAInfoView.h"


@interface WMOrderBoxView ()

@property (nonatomic, strong) SAInfoView *nameLB;
///打包费
@property (nonatomic, strong) SAInfoView *packLB;
///餐盒费
@property (nonatomic, strong) SAInfoView *boxLB;
///包装费
@property (nonatomic, strong) SAInfoView *allLB;

@end


@implementation WMOrderBoxView

- (void)hd_setupViews {
    SAInfoViewModel *model = SAInfoViewModel.new;
    model.keyText = WMLocalizedString(@"wm_total_packaging_fee_num", @"包装费 = 打包费 + 餐盒费");
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(4), kRealWidth(12), kRealWidth(18), kRealWidth(12));
    model.lineWidth = 0;
    model.keyColor = HDAppTheme.WMColor.B6;
    model.keyFont = [HDAppTheme.WMFont wm_ForSize:14];
    self.nameLB = [SAInfoView infoViewWithModel:model];
    [self addSubview:self.nameLB];

    model = SAInfoViewModel.new;
    model.keyText = WMLocalizedString(@"wm_packing_fee", @"打包费");
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(6), kRealWidth(12), kRealWidth(6), kRealWidth(12));
    ;
    model.lineWidth = 0;
    model.keyColor = HDAppTheme.WMColor.B3;
    model.keyFont = [HDAppTheme.WMFont wm_ForSize:14 weight:UIFontWeightMedium];
    model.valueColor = HDAppTheme.WMColor.B3;
    model.valueFont = [HDAppTheme.WMFont wm_ForSize:14 fontName:@"DINPro-Bold"];
    self.packLB = [SAInfoView infoViewWithModel:model];
    [self addSubview:self.packLB];

    model = SAInfoViewModel.new;
    model.keyText = WMLocalizedString(@"wm_packaging_fee", @"餐盒费");
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(6), kRealWidth(12), kRealWidth(16), kRealWidth(12));
    model.keyColor = HDAppTheme.WMColor.B3;
    model.keyFont = [HDAppTheme.WMFont wm_ForSize:14 weight:UIFontWeightMedium];
    model.lineColor = HDAppTheme.WMColor.lineColorE9;
    model.lineWidth = HDAppTheme.WMValue.line;
    model.valueColor = HDAppTheme.WMColor.B3;
    model.valueFont = [HDAppTheme.WMFont wm_ForSize:14 fontName:@"DINPro-Bold"];
    self.boxLB = [SAInfoView infoViewWithModel:model];
    [self addSubview:self.boxLB];

    model = SAInfoViewModel.new;
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(12), kRealWidth(16), kRealWidth(12));
    model.keyText = WMLocalizedString(@"packing_fee", @"包装费");
    model.lineWidth = 0;
    model.keyColor = HDAppTheme.WMColor.B3;
    model.keyFont = [HDAppTheme.WMFont wm_ForSize:14 weight:UIFontWeightBold];
    model.valueColor = HDAppTheme.WMColor.mainRed;
    model.valueFont = [HDAppTheme.WMFont wm_ForSize:18 fontName:@"DINPro-Bold"];
    self.allLB = [SAInfoView infoViewWithModel:model];
    [self addSubview:self.allLB];
}

- (void)configureWithOrderDetailRspModel:(WMOrderDetailCommodityModel *)payFeeTrialCalRspModel {
    self.packLB.model.valueText = payFeeTrialCalRspModel.packingFee.thousandSeparatorAmount;
    self.boxLB.model.valueText = payFeeTrialCalRspModel.boxFee.thousandSeparatorAmount;
    self.allLB.model.valueText = payFeeTrialCalRspModel.totalPackageFee.thousandSeparatorAmount;
    [self.packLB setNeedsUpdateContent];
    [self.boxLB setNeedsUpdateContent];
    [self.allLB setNeedsUpdateContent];
}

- (void)configureWithSubmitRspModel:(WMShoppingItemsPayFeeTrialCalRspModel *)payFeeTrialCalRspModel {
    self.packLB.model.valueText = payFeeTrialCalRspModel.packingFee.thousandSeparatorAmount;
    self.boxLB.model.valueText = payFeeTrialCalRspModel.boxFee.thousandSeparatorAmount;
    self.allLB.model.valueText = payFeeTrialCalRspModel.packageFee.thousandSeparatorAmount;
    [self.packLB setNeedsUpdateContent];
    [self.boxLB setNeedsUpdateContent];
    [self.allLB setNeedsUpdateContent];
}

- (void)updateConstraints {
    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
    }];

    [self.packLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLB);
        make.top.equalTo(self.nameLB.mas_bottom);
    }];

    [self.boxLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLB);
        make.top.equalTo(self.packLB.mas_bottom);
    }];

    [self.allLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLB);
        make.top.equalTo(self.boxLB.mas_bottom);
    }];
    [super updateConstraints];
}

- (void)layoutyImmediately {
    [self layoutIfNeeded];
    self.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.allLB.frame));
}

@end
