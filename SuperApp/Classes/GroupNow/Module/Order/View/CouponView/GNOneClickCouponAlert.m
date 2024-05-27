//
//  GNOneClickCouponAlert.m
//  SuperApp
//
//  Created by wmz on 2022/8/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNOneClickCouponAlert.h"


@interface GNOneClickCouponAlert ()
///提示文本
@property (nonatomic, strong) YYLabel *tipLb;
///订单状态完成
@property (nonatomic, assign) BOOL finish;

@end


@implementation GNOneClickCouponAlert

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.contenView addSubview:self.tipLb];
}

- (void)configDataSource:(NSArray<GNCouponDetailModel *> *)dataSource finish:(BOOL)finish {
    self.finish = finish;
    [dataSource enumerateObjectsUsingBlock:^(GNCouponDetailModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.finish = finish;
    }];
    self.dataSource = [NSArray arrayWithArray:dataSource];
    self.tableView.scrollEnabled = (dataSource.count > 3);
    NSString *title = @"";
    if (self.finish) {
        title = GNLocalizedString(@"gn_congratulation_coupon", @"恭喜您获得优惠券");
        self.confirmBTN.hidden = NO;
    } else {
        title = GNLocalizedString(@"gn_verification_coupon", @"核销订单后可领取优惠券");
        self.confirmBTN.hidden = YES;
    }
    self.showAgainBTN.hidden = YES;
    [self.confirmBTN setTitleColor:HexColor(0xC10C0C) forState:UIControlStateNormal];
    [self.confirmBTN setTitle:GNLocalizedString(@"gn_order_go_use", @"去使用") forState:UIControlStateNormal];
    self.confirmBTN.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.confirmBTN.titleLabel.font = [HDAppTheme.font gn_ForSize:16 weight:UIFontWeightHeavy];
    [self.confirmBTN setBackgroundImage:[UIImage imageNamed:@"gn_coupon_confirm"] forState:UIControlStateNormal];
    [self.confirmBTN setImage:nil forState:UIControlStateNormal];
    self.confirmBTN.adjustsButtonWhenHighlighted = NO;
    @HDWeakify(self)[self.confirmBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
        @HDStrongify(self) if (!SAUser.hasSignedIn) {
            [SAWindowManager switchWindowToLoginViewController];
            return;
        }
        if (self.useBlock) {
            self.useBlock(dataSource.firstObject);
        }
    }];

    NSMutableAttributedString *mstar = [[NSMutableAttributedString alloc] initWithString:title];
    mstar.yy_lineSpacing = kRealWidth(4);
    mstar.yy_font = [HDAppTheme.WMFont wm_ForSize:20 weight:UIFontWeightHeavy];
    mstar.yy_color = HDAppTheme.color.gn_mainColor;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    mstar.yy_paragraphStyle = paragraph;
    self.titleLB.attributedText = mstar;

    mstar = [[NSMutableAttributedString alloc]
        initWithString:finish ? GNLocalizedString(@"gn_claimed_mycoupons", @"已领取的优惠券存放在“我的”-“优惠券”") : GNLocalizedString(@"gn_coupons_limited", @"提示：外卖优惠券数量有限，领完即止")];
    mstar.yy_lineSpacing = kRealWidth(4);
    mstar.yy_font = [HDAppTheme.WMFont wm_ForSize:12];
    mstar.yy_color = UIColor.whiteColor;
    mstar.yy_paragraphStyle = paragraph;
    self.tipLb.attributedText = mstar;

    [self updateConstraints];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.showAgainBTN mas_remakeConstraints:^(MASConstraintMaker *make){

    }];

    [self.closeBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgIV.mas_bottom).offset(kRealWidth(12));
        make.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
    }];

    [self.confirmBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.confirmBTN.isHidden) {
            make.left.mas_equalTo(kRealWidth(40));
            make.right.mas_equalTo(kRealWidth(-40));
            make.height.mas_equalTo(kRealWidth(48));
            make.bottom.equalTo(self.bgIV.mas_bottom).offset(-kRealWidth(17));
        }
    }];

    [self.tipLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(32));
        make.right.mas_equalTo(kRealWidth(-32));
        if (self.confirmBTN.isHidden) {
            make.bottom.equalTo(self.bgIV.mas_bottom).offset(-kRealWidth(40));
        } else {
            make.bottom.equalTo(self.confirmBTN.mas_top).offset(-kRealWidth(4));
        }
    }];
}

- (YYLabel *)tipLb {
    if (!_tipLb) {
        _tipLb = YYLabel.new;
        _tipLb.numberOfLines = 0;
        _tipLb.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(112);
    }
    return _tipLb;
}

@end
