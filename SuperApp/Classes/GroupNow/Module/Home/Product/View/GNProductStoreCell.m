//
//  GNProductStoreCell.m
//  SuperApp
//
//  Created by wmz on 2021/9/16.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNProductStoreCell.h"
#import "GNProductModel.h"
#import "SACaculateNumberTool.h"


@interface GNProductStoreCell ()
/// addressView
@property (nonatomic, strong) UIView *addressView;
/// callView
@property (nonatomic, strong) UIView *callView;
/// line1
@property (nonatomic, strong) UIView *line1;
/// addressBTN
@property (nonatomic, strong) HDUIButton *addressBTN;
/// callBTN
@property (nonatomic, strong) HDUIButton *callBTN;
///地址
@property (nonatomic, strong) HDLabel *addressLB;
///电话
@property (nonatomic, strong) HDLabel *callLB;

@end


@implementation GNProductStoreCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.addressView];
    [self.contentView addSubview:self.callView];
    [self.addressView addSubview:self.addressBTN];
    [self.addressView addSubview:self.addressLB];
    [self.callView addSubview:self.callBTN];
    [self.callView addSubview:self.callLB];
    [self.contentView addSubview:self.line1];
}

- (void)updateConstraints {
    [self.addressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];

    [self.addressLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kRealWidth(12));
        make.right.equalTo(self.addressBTN.mas_left).offset(-kRealWidth(8));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
        make.top.mas_greaterThanOrEqualTo(kRealWidth(8));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(8));
        make.centerY.mas_equalTo(0);
    }];

    [self.addressBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(14));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(28), kRealWidth(28)));
        make.top.mas_greaterThanOrEqualTo(kRealWidth(14));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(14));
    }];

    [self.line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(0);
        make.top.equalTo(self.addressView.mas_bottom);
        make.height.mas_equalTo(HDAppTheme.value.gn_line);
    }];

    [self.callView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.line1.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];

    [self.callBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(14));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(28), kRealWidth(28)));
        make.top.mas_equalTo(kRealWidth(14));
        make.bottom.mas_equalTo(-kRealWidth(14));
    }];

    [self.callLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.right.equalTo(self.callBTN.mas_left).offset(-kRealWidth(8));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
        make.centerY.equalTo(self.callBTN);
    }];

    [super updateConstraints];
}

- (void)setGNModel:(GNProductModel *)data {
    NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:GNLocalizedString(@"gn_reverve_phone", @"Call")];
    [GNStringUntils attributedString:mstr color:HDAppTheme.color.gn_333Color colorRange:mstr.string font:[HDAppTheme.font gn_boldForSize:14] fontRange:mstr.string];
    [GNStringUntils attributedString:mstr lineSpacing:kRealWidth(4) colorRange:mstr.string];
    self.callLB.attributedText = mstr;
    NSString *addressStr = GNFillEmpty(data.address);
    if (HDLocationManager.shared.isCurrentCoordinate2DValid) {
        addressStr =
            [NSString stringWithFormat:@"%@\t%@", [SACaculateNumberTool gnDistanceStringFromNumber:data.distance toFixedCount:1 roundingMode:SANumRoundingModeUpAndDown], GNFillEmpty(data.address)];
    }
    NSMutableAttributedString *addressMstr = [[NSMutableAttributedString alloc] initWithString:addressStr];
    [GNStringUntils attributedString:addressMstr color:HDAppTheme.color.gn_333Color colorRange:addressMstr.string font:[HDAppTheme.font gn_boldForSize:14] fontRange:addressMstr.string];
    [GNStringUntils attributedString:addressMstr lineSpacing:kRealWidth(4) colorRange:addressMstr.string];
    self.addressLB.attributedText = addressMstr;
    self.addressLB.lineBreakMode = NSLineBreakByTruncatingTail;
    [self setNeedsUpdateConstraints];
}

///跳转地图
- (void)mapAction {
    [GNEvent eventResponder:self target:self.addressView key:@"mapAction" indexPath:nil];
}

- (UIView *)addressView {
    if (!_addressView) {
        _addressView = UIView.new;
        UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapAction)];
        [_addressView addGestureRecognizer:ta];
    }
    return _addressView;
}

- (UIView *)callView {
    if (!_callView) {
        _callView = UIView.new;
    }
    return _callView;
}

- (HDUIButton *)addressBTN {
    if (!_addressBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"gn_storeinfo_daohang"] forState:UIControlStateNormal];
        @HDWeakify(self)[btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[GNEvent eventResponder:self target:btn key:@"navigationAction"];
        }];
        _addressBTN = btn;
    }
    return _addressBTN;
}

- (HDUIButton *)callBTN {
    if (!_callBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"gn_storeinfo_call"] forState:UIControlStateNormal];
        @HDWeakify(self)[btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[GNEvent eventResponder:self target:btn key:@"callAction"];
        }];
        _callBTN = btn;
    }
    return _callBTN;
}

- (UIView *)line1 {
    if (!_line1) {
        UIView *line = UIView.new;
        line.backgroundColor = HDAppTheme.color.gn_lineColor;
        _line1 = line;
    }
    return _line1;
}

- (HDLabel *)addressLB {
    if (!_addressLB) {
        HDLabel *la = HDLabel.new;
        la.textColor = HDAppTheme.color.gn_333Color;
        la.numberOfLines = 2;
        la.font = [HDAppTheme.font gn_boldForSize:16];
        _addressLB = la;
    }
    return _addressLB;
}

- (HDLabel *)callLB {
    if (!_callLB) {
        HDLabel *la = HDLabel.new;
        la.textColor = HDAppTheme.color.gn_333Color;
        la.numberOfLines = 2;
        la.font = [HDAppTheme.font gn_boldForSize:16];
        _callLB = la;
    }
    return _callLB;
}

@end
