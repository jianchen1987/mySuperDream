//
//  WMOrderModifyAddressTableViewCell.m
//  SuperApp
//
//  Created by wmz on 2022/10/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMOrderModifyAddressTableViewCell.h"
#import "WMModifyFeeModel.h"


@interface WMOrderModifyAddressTableViewCell ()
/// bg
@property (nonatomic, strong) UIView *bgView;
///地址
@property (nonatomic, strong) HDLabel *addressLB;
///用户
@property (nonatomic, strong) YYLabel *userLB;
///标签
@property (nonatomic, strong) YYLabel *tagLB;
///编辑
@property (nonatomic, strong) HDUIButton *editBTN;
///选择
@property (nonatomic, strong) HDUIButton *checkBTN;
///配送费
@property (nonatomic, strong) HDLabel *shippingIncreasLB;
///配送时间
@property (nonatomic, strong) HDLabel *timeLB;
///线条
@property (nonatomic, strong) UIView *bottomLine;
@end


@implementation WMOrderModifyAddressTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.addressLB];
    [self.bgView addSubview:self.userLB];
    [self.bgView addSubview:self.tagLB];
    [self.bgView addSubview:self.editBTN];
    [self.bgView addSubview:self.checkBTN];
    [self.bgView addSubview:self.shippingIncreasLB];
    [self.bgView addSubview:self.timeLB];
    [self.bgView addSubview:self.bottomLine];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    [self.checkBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.checkBTN.isHidden) {
            make.height.width.mas_equalTo(kRealWidth(44));
            make.left.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
        }
    }];

    [self.addressLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(16));
        if (self.checkBTN.isHidden) {
            make.left.mas_equalTo(kRealWidth(12));
        } else {
            make.left.equalTo(self.checkBTN.mas_right);
        }
        if (self.editBTN.isHidden) {
            make.right.mas_equalTo(-kRealWidth(12));
        } else {
            make.right.equalTo(self.editBTN.mas_left);
        }
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
    }];
    [self.addressLB layoutIfNeeded];

    __block UIView *view = self.userLB;
    self.userLB.preferredMaxLayoutWidth = self.addressLB.hd_width;
    [self.userLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLB.mas_bottom).offset(kRealWidth(8));
        make.left.right.equalTo(self.addressLB);
        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
    }];

    [self.editBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.editBTN.isHidden) {
            make.height.width.mas_equalTo(kRealWidth(44));
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
        }
    }];

    [self.shippingIncreasLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.shippingIncreasLB.isHidden) {
            make.left.right.equalTo(self.addressLB);
            make.top.equalTo(view.mas_bottom).offset(kRealWidth(8));
            make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
            ;
            view = self.shippingIncreasLB;
        }
    }];

    [self.timeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.timeLB.isHidden) {
            make.left.right.equalTo(self.addressLB);
            make.top.equalTo(view.mas_bottom).offset(kRealWidth(4));
            make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
            view = self.timeLB;
        }
    }];

    self.tagLB.preferredMaxLayoutWidth = self.addressLB.hd_width;
    [self.tagLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.tagLB.isHidden) {
            make.top.equalTo(view.mas_bottom).offset(kRealWidth(8));
            make.left.right.equalTo(self.addressLB);
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
            make.height.mas_greaterThanOrEqualTo(kRealWidth(16));
        }
    }];

    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressLB);
        make.height.mas_equalTo(HDAppTheme.WMValue.line);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [super updateConstraints];
}

- (void)setGNCellModel:(GNCellModel *)data {
    self.cellModel = data;
}

- (void)setGNModel:(SAShoppingAddressModel *)data {
    self.model = data;
    self.addressLB.text = [NSString stringWithFormat:@"%@%@", data.address, data.consigneeAddress ?: @""];
    NSMutableAttributedString *addressStr = [[NSMutableAttributedString alloc] initWithString:self.addressLB.text];
    addressStr.yy_lineSpacing = kRealWidth(4);
    addressStr.yy_color = [data.inRange isEqualToString:SABoolValueTrue] ? HDAppTheme.WMColor.B3 : HDAppTheme.WMColor.CCCCCC;
    self.addressLB.attributedText = addressStr;

    NSString *key = [NSString stringWithFormat:@"wm_gender_%@", data.gender];
    NSMutableAttributedString *userStr = NSMutableAttributedString.new;
    [userStr yy_appendString:data.consigneeName];
    [userStr appendAttributedString:[self emptySpace:kRealWidth(16)]];
    [userStr yy_appendString:WMLocalizedString(key, key)];
    [userStr appendAttributedString:[self emptySpace:kRealWidth(16)]];
    [userStr yy_appendString:data.mobile];
    userStr.yy_lineSpacing = kRealWidth(4);
    userStr.yy_color = [data.inRange isEqualToString:SABoolValueTrue] ? HDAppTheme.WMColor.B9 : HDAppTheme.WMColor.CCCCCC;
    userStr.yy_font = [HDAppTheme.WMFont wm_ForSize:12];
    self.userLB.attributedText = userStr;

    NSMutableArray *tags = NSMutableArray.new;
    if ([data.isDefault isEqualToString:SABoolValueTrue]) {
        [tags addObject:WMLocalizedString(@"default", @"默认")];
    }
    if (!HDIsArrayEmpty(data.tags)) {
        [tags addObjectsFromArray:data.tags];
    }
    NSMutableAttributedString *tagStr = NSMutableAttributedString.new;
    tagStr.yy_lineSpacing = 8;
    for (NSString *string in tags) {
        [tagStr appendAttributedString:[self emptySpace:kRealWidth(4)]];
        NSMutableAttributedString *st = [[NSMutableAttributedString alloc] initWithString:SALocalizedString([string lowercaseString], string)];
        st.yy_font = [HDAppTheme.WMFont wm_ForSize:10];
        st.yy_color = UIColor.whiteColor;
        YYTextBorder *boder = YYTextBorder.new;
        if ([string isEqualToString:@"OFFICE"] || [string isEqualToString:@"HOME"] || [string isEqualToString:@"SCHOOL"]) {
            boder.fillColor = HexColor(0x3789FF);
        } else if ([string isEqualToString:@"OTHER"]) {
            boder.fillColor = HexColor(0x9ED24B);
        } else {
            boder.fillColor = HDAppTheme.WMColor.mainRed;
        }
        boder.cornerRadius = kRealWidth(2);
        boder.insets = UIEdgeInsetsMake(-2, -kRealWidth(4), -2, -kRealWidth(4));
        [st setYy_textBackgroundBorder:boder];
        [tagStr appendAttributedString:st];
        [tagStr appendAttributedString:[self emptySpace:kRealWidth(10)]];
    }
    self.tagLB.hidden = HDIsArrayEmpty(data.tags);
    self.tagLB.attributedText = tagStr;

    self.editBTN.hidden = self.timeLB.hidden = self.shippingIncreasLB.hidden = YES;
    self.checkBTN.hidden = NO;
    WMModifyFeeModel *feeModel = self.cellModel.object;
    if ([feeModel isKindOfClass:WMModifyFeeModel.class]) {
        self.timeLB.hidden = feeModel.inTime <= 0;
        self.shippingIncreasLB.hidden = feeModel.deliveryFee.cent.integerValue <= 0;
        NSMutableAttributedString *shipStr = [[NSMutableAttributedString alloc]
            initWithString:[NSString stringWithFormat:@"%@: %@", WMLocalizedString(@"wm_modify_address_increase_fee", @"Shipping fee increas"), feeModel.deliveryFee.thousandSeparatorAmount]];
        shipStr.yy_color = [data.inRange isEqualToString:SABoolValueTrue] ? HDAppTheme.WMColor.B9 : HDAppTheme.WMColor.CCCCCC;
        shipStr.yy_font = [HDAppTheme.WMFont wm_ForSize:12];
        [shipStr yy_setFont:[HDAppTheme.WMFont wm_ForSize:12 fontName:@"DIN-Medium"] range:[shipStr.string rangeOfString:feeModel.deliveryFee.thousandSeparatorAmount]];
        [shipStr yy_setColor:HDAppTheme.WMColor.mainRed range:[shipStr.string rangeOfString:feeModel.deliveryFee.thousandSeparatorAmount]];
        self.shippingIncreasLB.attributedText = shipStr;

        NSString *time = [NSString stringWithFormat:@"%zdmin", feeModel.inTime];
        NSMutableAttributedString *timeStr =
            [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: %@", WMLocalizedString(@"wm_modify_address_increase_time", @"Delivery time increa"), time]];
        timeStr.yy_color = [data.inRange isEqualToString:SABoolValueTrue] ? HDAppTheme.WMColor.B9 : HDAppTheme.WMColor.CCCCCC;
        timeStr.yy_font = [HDAppTheme.WMFont wm_ForSize:12];
        [timeStr yy_setFont:[HDAppTheme.WMFont wm_ForSize:12 fontName:@"DIN-Medium"] range:[timeStr.string rangeOfString:time]];
        [timeStr yy_setColor:HDAppTheme.WMColor.mainRed range:[timeStr.string rangeOfString:time]];
        self.timeLB.attributedText = timeStr;
    }
    self.checkBTN.enabled = [data.inRange isEqualToString:SABoolValueTrue];
    self.editBTN.hidden = ![data.inRange isEqualToString:SABoolValueTrue];
    self.checkBTN.selected = self.cellModel.isSelected;
    BOOL current = [self.cellModel.tag isEqualToString:@"current"];
    if (current) {
        self.editBTN.hidden = self.checkBTN.hidden = YES;
        self.timeLB.hidden = self.shippingIncreasLB.hidden = YES;
    }
    self.bottomLine.hidden = self.cellModel.last;
    [self setNeedsUpdateConstraints];
}

- (NSMutableAttributedString *)emptySpace:(CGFloat)space {
    return [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill attachmentSize:CGSizeMake(space, 1)
                                                         alignToFont:[UIFont systemFontOfSize:0]
                                                           alignment:YYTextVerticalAlignmentCenter];
}

- (HDLabel *)addressLB {
    if (!_addressLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B3;
        label.numberOfLines = 0;
        label.font = [HDAppTheme.WMFont wm_ForSize:14 weight:UIFontWeightMedium];
        _addressLB = label;
    }
    return _addressLB;
}

- (YYLabel *)userLB {
    if (!_userLB) {
        _userLB = YYLabel.new;
        _userLB.textColor = HDAppTheme.WMColor.B9;
        _userLB.numberOfLines = 0;
        _userLB.font = [HDAppTheme.WMFont wm_ForSize:12];
    }
    return _userLB;
}

- (YYLabel *)tagLB {
    if (!_tagLB) {
        _tagLB = YYLabel.new;
        _tagLB.numberOfLines = 0;
    }
    return _tagLB;
}

- (HDLabel *)shippingIncreasLB {
    if (!_shippingIncreasLB) {
        HDLabel *label = HDLabel.new;
        _shippingIncreasLB = label;
    }
    return _shippingIncreasLB;
}

- (HDLabel *)timeLB {
    if (!_timeLB) {
        HDLabel *label = HDLabel.new;
        _timeLB = label;
    }
    return _timeLB;
}

- (HDUIButton *)editBTN {
    if (!_editBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        btn.highlighted = NO;
        [btn setImage:[UIImage imageNamed:@"yn_address_edit"] forState:UIControlStateNormal];
        @HDWeakify(self)[btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[HDMediator.sharedInstance navigaveToAddOrModifyAddressViewController:@{@"model": self.model}];
        }];
        _editBTN = btn;
    }
    return _editBTN;
}

- (HDUIButton *)checkBTN {
    if (!_checkBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        btn.highlighted = NO;
        [btn setImage:[UIImage imageNamed:@"yn_car_select_nor"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"yn_car_select_sel"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"yn_car_select_disable"] forState:UIControlStateDisabled];
        @HDWeakify(self)[btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[GNEvent eventResponder:self target:btn key:@"selectAction" indexPath:self.cellModel.indexPath info:@{@"model": self.self.cellModel}];
        }];
        _checkBTN = btn;
    }
    return _checkBTN;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
    }
    return _bgView;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = UIView.new;
        _bottomLine.backgroundColor = HDAppTheme.WMColor.lineColorE9;
    }
    return _bottomLine;
}

@end
