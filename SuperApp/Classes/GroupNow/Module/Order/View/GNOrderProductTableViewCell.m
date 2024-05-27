//
//  GNOrderProductTableViewCell.m
//  SuperApp
//
//  Created by wmz on 2021/6/4.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNOrderProductTableViewCell.h"
#import "GNCouPonImageView.h"
#import "SAGeneralUtil.h"


@interface GNOrderProductTableViewCell ()
/// 箭头
@property (nonatomic, strong) HDUIButton *rightBtn;
/// 产品
@property (nonatomic, strong) HDLabel *productLB;
/// 状态
@property (nonatomic, strong) HDLabel *statusLB;
/// 价格
@property (nonatomic, strong) HDLabel *priceLB;
/// 图片
@property (nonatomic, strong) GNCouPonImageView *iconIV;
/// 二维码
@property (nonatomic, strong) UIImageView *codeIV;
/// 操作
@property (nonatomic, strong) HDUIButton *statusBtn;
/// 信息
@property (nonatomic, strong) HDLabel *infotmationLB;
/// 到期
@property (nonatomic, strong) HDLabel *timeLB;

@end


@implementation GNOrderProductTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.rightBtn];
    [self.contentView addSubview:self.productLB];
    [self.contentView addSubview:self.statusLB];
    [self.contentView addSubview:self.priceLB];
    [self.contentView addSubview:self.codeIV];
    [self.contentView addSubview:self.statusBtn];
    [self.contentView addSubview:self.infotmationLB];
    [self.contentView addSubview:self.timeLB];
}

- (void)updateConstraints {
    [self.rightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconIV);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(24), kRealWidth(24)));
        make.right.mas_offset(-kRealWidth(12));
    }];

    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(80), kRealWidth(80)));
        make.left.mas_equalTo(kRealWidth(12));
        make.top.mas_equalTo(kRealWidth(16));
    }];

    [self.productLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(8));
        make.top.equalTo(self.iconIV);
        make.right.mas_offset(-kRealWidth(12));
        make.height.mas_equalTo(kRealWidth(24));
    }];

    [self.statusLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productLB);
        make.top.equalTo(self.productLB.mas_bottom).offset(kRealWidth(4));
        make.right.equalTo(self.rightBtn.mas_left).offset(-kRealWidth(5));
        make.height.mas_equalTo(kRealWidth(18));
    }];

    [self.priceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.statusLB);
        make.top.equalTo(self.statusLB.mas_bottom).offset(kRealWidth(4));
        make.height.mas_equalTo(kRealWidth(20));
    }];

    [self.codeIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.codeIV.isHidden) {
            make.size.mas_equalTo(CGSizeMake(kRealWidth(160), kRealWidth(160)));
            make.top.equalTo(self.iconIV.mas_bottom).offset(kRealWidth(20));
            make.centerX.mas_equalTo(0);
        }
    }];

    [self.infotmationLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.statusBtn.mas_left).offset(-HDAppTheme.value.gn_marginL / 2);
        make.left.mas_equalTo(HDAppTheme.value.gn_marginL);
        if (self.codeIV.isHidden) {
            make.top.equalTo(self.iconIV.mas_bottom).offset(kRealWidth(20));
        } else {
            make.top.equalTo(self.codeIV.mas_bottom).offset(kRealWidth(20));
        }
        make.height.mas_equalTo(kRealWidth(24));
        if (![self.model.bizState.codeId isEqualToString:GNOrderStatusUse]) {
            make.bottom.mas_equalTo(-kRealWidth(12));
        }
    }];

    [self.timeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.timeLB.isHidden) {
            make.left.equalTo(self.infotmationLB);
            make.top.equalTo(self.infotmationLB.mas_bottom).offset(kRealWidth(4));
            make.right.equalTo(self.statusBtn.mas_left).offset(-HDAppTheme.value.gn_marginL / 2);
            make.bottom.mas_equalTo(-kRealWidth(12));
        }
    }];

    [self.statusBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kRealWidth(24));
        make.right.mas_offset(-HDAppTheme.value.gn_marginL);
        make.centerY.equalTo(self.infotmationLB);
    }];

    [self.statusBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.statusBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [super updateConstraints];
}

- (void)setGNModel:(GNOrderCellModel *)data {
    if ([data isKindOfClass:GNOrderCellModel.class]) {
        self.model = data;
        self.productLB.text = data.productInfo.name.desc;
        self.statusLB.text = data.productInfo.whetherRefund == 1 ? GNLocalizedString(@"gn_product_refund", @"过期自动退") : GNLocalizedString(@"gn_expire_not_refund", @"过期不退款");
        self.priceLB.text = GNFillMonEmpty(data.productInfo.price);
        if ([data.productInfo.type.codeId isEqualToString:GNProductTypeP2]) {
            self.iconIV.image = [UIImage imageNamed:@"gn_storeinfo_coupon"];
        } else {
            [self.iconIV sd_setImageWithURL:[NSURL URLWithString:data.productInfo.imagePath] placeholderImage:HDHelper.placeholderImage];
        }

        self.codeIV.hidden = !data.firstUnUseCode;
        if (!self.codeIV.hidden) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImage *qrCodeImage = [HDCodeGenerator qrCodeImageForStr:data.firstUnUseCode.codeNo size:CGSizeMake(kRealWidth(160), kRealWidth(160)) level:HDInputCorrectionLevelQ];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.codeIV.image = qrCodeImage ?: [UIImage imageNamed:@""];
                });
            });
        }

        if ([data.bizState.codeId isEqualToString:GNOrderStatusUse]) {
            [self.statusBtn setTitle:GNLocalizedString(@"gn_order_cancel", @"取消订单") forState:UIControlStateNormal];
            self.timeLB.hidden = NO;
            self.statusBtn.layer.backgroundColor = HDAppTheme.color.gn_whiteColor.CGColor;
            [self.statusBtn setTitleColor:HDAppTheme.color.gn_666Color forState:UIControlStateNormal];
            self.statusBtn.layer.borderWidth = 1;
        } else if ([data.bizState.codeId isEqualToString:GNOrderStatusUnPay]) {
            [self.statusBtn setTitle:GNLocalizedString(@"gn_to_pay", @"去付款") forState:UIControlStateNormal];
            self.timeLB.hidden = NO;
            self.statusBtn.layer.backgroundColor = HDAppTheme.color.gn_mainColor.CGColor;
            [self.statusBtn setTitleColor:HDAppTheme.color.gn_whiteColor forState:UIControlStateNormal];
            self.statusBtn.layer.borderWidth = 0;
        } else {
            [self.statusBtn setTitle:GNLocalizedString(@"gn_order_again", @"再来一单") forState:UIControlStateNormal];
            self.timeLB.hidden = YES;
            self.statusBtn.layer.backgroundColor = HDAppTheme.color.gn_mainColor.CGColor;
            [self.statusBtn setTitleColor:HDAppTheme.color.gn_whiteColor forState:UIControlStateNormal];
            self.statusBtn.layer.borderWidth = 0;
        }
        if (data.unuseCount) {
            self.infotmationLB.text = [NSString stringWithFormat:GNLocalizedString(@"gn_order_coupon_detail_all", @"券码信息（%ld张可用）"), data.unuseCount];
        } else {
            self.infotmationLB.text = GNLocalizedString(@"gn_order_coupon_detail", @"券码信息");
        }
        self.timeLB.text =
            [NSString stringWithFormat:@"%@ %@", [SAGeneralUtil getDateStrWithTimeInterval:data.effectiveTime / 1000 format:@"dd/MM/yyyy HH:mm:ss"], GNLocalizedString(@"gn_order_expired", @"到期")];
        self.timeLB.hidden = ![data.bizState.codeId isEqualToString:GNOrderStatusUse];
        [self setNeedsUpdateConstraints];
    }
}

- (HDUIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.userInteractionEnabled = NO;
        [_rightBtn setImage:[UIImage imageNamed:@"gn_storeinfo_gengd"] forState:UIControlStateNormal];
    }
    return _rightBtn;
}

- (HDLabel *)productLB {
    if (!_productLB) {
        _productLB = HDLabel.new;
        _productLB.numberOfLines = 1;
        _productLB.textColor = HDAppTheme.color.gn_333Color;
        _productLB.font = [HDAppTheme.font gn_boldForSize:16];
    }
    return _productLB;
}

- (HDLabel *)statusLB {
    if (!_statusLB) {
        _statusLB = HDLabel.new;
        _statusLB.textColor = HDAppTheme.color.gn_999Color;
        _statusLB.font = HDAppTheme.font.gn_12;
    }
    return _statusLB;
}

- (HDLabel *)priceLB {
    if (!_priceLB) {
        _priceLB = HDLabel.new;
        _priceLB.font = [HDAppTheme.font gn_ForSize:13 weight:UIFontWeightHeavy];
        _priceLB.textColor = HDAppTheme.color.gn_mainColor;
    }
    return _priceLB;
}

- (GNCouPonImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = GNCouPonImageView.new;
        _iconIV.layer.cornerRadius = kRealWidth(4);
        _iconIV.couponLB.hidden = YES;
    }
    return _iconIV;
}

- (UIImageView *)codeIV {
    if (!_codeIV) {
        _codeIV = UIImageView.new;
        _codeIV.image = HDHelper.placeholderImage;
    }
    return _codeIV;
}

- (HDUIButton *)statusBtn {
    if (!_statusBtn) {
        _statusBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _statusBtn.layer.cornerRadius = kRealWidth(12);
        _statusBtn.titleLabel.font = [HDAppTheme.font gn_ForSize:12];
        _statusBtn.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(12), 0, kRealWidth(12));
        _statusBtn.layer.borderColor = HDAppTheme.color.gn_999Color.CGColor;
        @HDWeakify(self)[_statusBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self) if (GNStringNotEmpty(self.model.bizState.codeId)) {
                if ([self.model.bizState.codeId isEqualToString:GNOrderStatusUse]) {
                    [GNEvent eventResponder:self target:btn key:@"cancelOrder"];
                } else if ([self.model.bizState.codeId isEqualToString:GNOrderStatusUnPay]) {
                    [GNEvent eventResponder:self target:btn key:@"onlinePayAction" indexPath:self.model.indexPath info:@{@"model": self.model}];
                } else {
                    [GNEvent eventResponder:self target:btn key:@"bugAgain"];
                }
            }
        }];
    }
    return _statusBtn;
}

- (HDLabel *)infotmationLB {
    if (!_infotmationLB) {
        _infotmationLB = HDLabel.new;
        _infotmationLB.font = [HDAppTheme.font gn_boldForSize:13];
        _infotmationLB.numberOfLines = 0;
    }
    return _infotmationLB;
}

- (HDLabel *)timeLB {
    if (!_timeLB) {
        _timeLB = HDLabel.new;
        _timeLB.textColor = HDAppTheme.color.gn_999Color;
        _timeLB.font = HDAppTheme.font.gn_12;
    }
    return _timeLB;
}

@end
