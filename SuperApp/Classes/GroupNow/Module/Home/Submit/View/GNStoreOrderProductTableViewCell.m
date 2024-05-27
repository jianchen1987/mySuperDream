//
//  GNOrderProductTableViewCell.m
//  SuperApp
//
//  Created by wmz on 2021/6/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNStoreOrderProductTableViewCell.h"
#import "GNCouPonImageView.h"
#import "GNStringUntils.h"


@interface GNStoreOrderProductTableViewCell () <UITextFieldDelegate>
/// +
@property (nonatomic, strong) HDUIButton *plusBtn;
/// -
@property (nonatomic, strong) HDUIButton *lessBtn;
/// 数量
@property (nonatomic, strong) UITextField *numLB;
/// 产品
@property (nonatomic, strong) HDLabel *productLB;
/// 状态
@property (nonatomic, strong) HDLabel *statusLB;
/// 价格
@property (nonatomic, strong) HDLabel *priceLB;
/// 原价
@property (nonatomic, strong) HDLabel *normalLB;
/// 图片
@property (nonatomic, strong) GNCouPonImageView *iconIV;
/// 左边图标
@property (nonatomic, strong) UIImageView *leftIV;
/// 门店
@property (nonatomic, strong) HDLabel *storeLB;

@end


@implementation GNStoreOrderProductTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.leftIV];
    [self.contentView addSubview:self.storeLB];
    [self.contentView addSubview:self.normalLB];
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.productLB];
    [self.contentView addSubview:self.statusLB];
    [self.contentView addSubview:self.priceLB];
    [self.contentView addSubview:self.plusBtn];
    [self.contentView addSubview:self.lessBtn];
    [self.contentView addSubview:self.numLB];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.leftIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.top.mas_equalTo(kRealWidth(16));
    }];

    [self.storeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftIV.mas_right).offset(kRealWidth(8));
        make.right.mas_offset(-kRealWidth(12));
        make.centerY.equalTo(self.leftIV);
    }];

    [self.plusBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-kRealWidth(12));
        make.centerY.equalTo(self.priceLB);
    }];

    [self.numLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.plusBtn);
        make.right.equalTo(self.plusBtn.mas_left).offset(-kRealWidth(6));
    }];

    [self.lessBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.centerY.equalTo(self.plusBtn);
        make.right.equalTo(self.numLB.mas_left).offset(-kRealWidth(6));
    }];

    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealHeight(56), kRealHeight(56)));
        make.left.equalTo(self.leftIV);
        make.top.equalTo(self.leftIV.mas_bottom).offset(kRealWidth(16));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
    }];

    [self.productLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(8));
        make.top.equalTo(self.iconIV.mas_top);
        make.height.mas_equalTo(kRealWidth(20));
        make.right.mas_offset(-kRealWidth(12));
    }];

    [self.statusLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productLB);
        make.height.mas_equalTo(kRealWidth(18));
        make.top.equalTo(self.productLB.mas_bottom).offset(kRealWidth(4));
        make.right.mas_offset(-kRealWidth(12));
    }];

    [self.priceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productLB);
        make.top.equalTo(self.statusLB.mas_bottom).offset(kRealWidth(4));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
    }];

    [self.normalLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLB.mas_right).offset(kRealWidth(12));
        make.centerY.equalTo(self.priceLB);
    }];

    [self.numLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.numLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [self.leftIV setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.leftIV setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setGNModel:(GNOrderRushBuyModel *)data {
    self.model = data;
    self.storeLB.text = GNFillEmpty(data.storeName.desc);
    self.productLB.text = data.name.desc;
    self.statusLB.text = (data.whetherHomePurchaseRestrictions == GNHomePurchaseRestrictionsTypeCan) ?
                             [NSString stringWithFormat:GNLocalizedString(@"gn_store_limited", @"每单限购%ld份"), data.homePurchaseRestrictions] :
                             @"";
    NSMutableAttributedString *beforeStr = [[NSMutableAttributedString alloc] initWithString:GNFillMonEmpty(data.price)];
    NSMutableAttributedString *afterStr = [[NSMutableAttributedString alloc] initWithString:GNFillMonEmpty(data.originalPrice)];
    [GNStringUntils attributedString:afterStr color:HDAppTheme.color.gn_999Color colorRange:afterStr.string font:[HDAppTheme.WMFont wm_ForSize:12 fontName:@"DIN-Light"] fontRange:afterStr.string];
    [GNStringUntils attributedString:beforeStr color:HDAppTheme.color.gn_mainColor colorRange:beforeStr.string font:[HDAppTheme.WMFont wm_ForSize:14 fontName:@"DIN-Medium"]
                           fontRange:beforeStr.string];
    [GNStringUntils attributedString:afterStr center:YES colorRange:afterStr.string];
    self.priceLB.attributedText = beforeStr;
    self.normalLB.attributedText = afterStr;
    self.normalLB.hidden = (!data.originalPrice || [data.originalPrice isKindOfClass:NSNull.class] || data.originalPrice.doubleValue == data.price.doubleValue);
    if ([data.type.codeId isEqualToString:GNProductTypeP2]) {
        self.iconIV.image = [UIImage imageNamed:@"gn_storeinfo_coupon"];
    } else {
        [self.iconIV sd_setImageWithURL:[NSURL URLWithString:data.imagePath] placeholderImage:HDHelper.placeholderImage];
    }
    self.numLB.text = [NSString stringWithFormat:@"%ld", data.customAmount];
    self.numLB.enabled = self.lessBtn.enabled = self.plusBtn.enabled = !data.promoCodeRspModel;
    @HDWeakify(self);
    @HDWeakify(data);
    data.block = ^(NSInteger index) {
        @HDStrongify(self);
        @HDStrongify(data);
        data.first = YES;
        [self changeNum:index];
    };
    [self setNeedsUpdateConstraints];
}

- (HDUIButton *)plusBtn {
    if (!_plusBtn) {
        @HDWeakify(self);
        _plusBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _plusBtn.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(3), 0, kRealWidth(3));
        [_plusBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            self.model.customAmount += 1;
            [self changeNum:self.model.customAmount];
        }];
    }
    return _plusBtn;
}

- (HDUIButton *)lessBtn {
    if (!_lessBtn) {
        @HDWeakify(self);
        _lessBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _lessBtn.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(3), 0, kRealWidth(3));
        [_lessBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            self.model.customAmount -= 1;
            [self changeNum:self.model.customAmount];
        }];
    }
    return _lessBtn;
}

- (void)changeNum:(NSInteger)num {
    NSInteger compareNum = (self.model.whetherHomePurchaseRestrictions == GNHomePurchaseRestrictionsTypeCan) ? self.model.homePurchaseRestrictions : 99;
    NSInteger max = self.model.inventory ? MIN([self.model.inventory intValue], compareNum) : compareNum;
    num = MIN(MAX(1, num), max);
    if (self.model.inventory && num >= max && max == [self.model.inventory intValue]) {
        if (!self.model.first) {
            [HDTips showInfo:GNLocalizedString(@"gn_stock_empty", @"库存不足")];
        }
        [self setPlussEnable:NO];
    } else {
        [self setPlussEnable:(num >= max)];
    }
    [self setLessEnable:(num <= 1)];
    self.model.customAmount = num;
    self.numLB.text = [NSString stringWithFormat:@"%ld", self.model.customAmount];
    [GNEvent eventResponder:self target:self key:@"numChange" indexPath:self.model.indexPath info:@{@"data": self.model}];
    self.model.first = NO;
}

- (void)setPlussEnable:(BOOL)enable {
    [self.plusBtn setImage:[UIImage imageNamed:enable ? @"gn_reserve_add_un" : @"gn_reserve_add"] forState:UIControlStateNormal];
    self.plusBtn.userInteractionEnabled = !enable;
}

- (void)setLessEnable:(BOOL)enable {
    [self.lessBtn setImage:[UIImage imageNamed:enable ? @"gn_reserve_del_un" : @"gn_reserve_del"] forState:UIControlStateNormal];
    self.lessBtn.userInteractionEnabled = !enable;
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField.text.length) {
        self.model.customAmount = [textField.text intValue];
        [self changeNum:self.model.customAmount];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (!textField.text.length) {
        self.model.customAmount = 1;
        [self changeNum:self.model.customAmount];
    } else {
        [self changeNum:self.model.customAmount];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""])
        return YES;
    NSString *regex = @"^[0-9]+([.]{0,1}[0-9]+){0,1}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}

- (UIImageView *)leftIV {
    if (!_leftIV) {
        _leftIV = UIImageView.new;
        _leftIV.image = [UIImage imageNamed:@"gn_order_shop"];
    }
    return _leftIV;
}

- (HDLabel *)storeLB {
    if (!_storeLB) {
        _storeLB = HDLabel.new;
        _storeLB.font = [HDAppTheme.font gn_boldForSize:16];
        _storeLB.textColor = HDAppTheme.color.gn_333Color;
    }
    return _storeLB;
}

- (HDLabel *)productLB {
    if (!_productLB) {
        _productLB = HDLabel.new;
        _productLB.numberOfLines = 1;
        _productLB.font = [HDAppTheme.font gn_boldForSize:14];
        _productLB.textColor = HDAppTheme.color.gn_333Color;
    }
    return _productLB;
}

- (HDLabel *)statusLB {
    if (!_statusLB) {
        _statusLB = HDLabel.new;
        _statusLB.font = HDAppTheme.font.gn_13;
    }
    return _statusLB;
}

- (HDLabel *)priceLB {
    if (!_priceLB) {
        _priceLB = HDLabel.new;
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

- (HDLabel *)normalLB {
    if (!_normalLB) {
        _normalLB = HDLabel.new;
    }
    return _normalLB;
}

- (UITextField *)numLB {
    if (!_numLB) {
        _numLB = UITextField.new;
        _numLB.textAlignment = NSTextAlignmentCenter;
        _numLB.borderStyle = UITextBorderStyleNone;
        _numLB.keyboardType = UIKeyboardTypeNumberPad;
        _numLB.tintColor = HDAppTheme.WMColor.mainRed;
        [_numLB addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _numLB.delegate = self;
    }
    return _numLB;
}

@end
