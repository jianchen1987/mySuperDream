//
//  GNOrderCoupunNumTableViewCell.m
//  SuperApp
//
//  Created by wmz on 2021/6/4.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNOrderCoupunNumTableViewCell.h"
#import "GNStringUntils.h"


@interface GNOrderCoupunNumTableViewCell ()
/// 原点
@property (nonatomic, strong) UIView *bgView;
/// 编号
@property (nonatomic, strong) HDUIButton *pointView;
/// 信息
@property (nonatomic, strong) HDLabel *numberLB;
/// 状态
@property (nonatomic, strong) HDLabel *statusLB;

@end


@implementation GNOrderCoupunNumTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.pointView];
    [self.bgView addSubview:self.numberLB];
    [self.bgView addSubview:self.statusLB];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-kRealWidth(8));
        make.right.mas_equalTo(-kRealWidth(12));
        make.left.mas_equalTo(kRealWidth(12));
        make.height.mas_equalTo(36);
    }];

    [self.statusLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-kRealWidth(12));
    }];

    [self.pointView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kRealWidth(40));
        make.top.bottom.mas_equalTo(0);
    }];

    [self.numberLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pointView.mas_right).offset(kRealWidth(12));
        make.right.equalTo(self.statusLB.mas_left).offset(-kRealWidth(5));
        make.centerY.mas_equalTo(0);
    }];

    [self.statusLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.statusLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [super updateConstraints];
}

- (void)setGNModel:(GNQrCodeInfo *)data {
    [self.pointView setTitle:@(data.index).stringValue forState:UIControlStateNormal];
    NSString *str = [GNStringUntils componentNum:4 string:data.codeNo];
    self.statusLB.text = data.codeStateStr;
    if ([data.codeState.codeId isEqualToString:GNOrderStatusUse] || [data.codeState.codeId isEqualToString:GNOrderStatusUnPay]) {
        NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:str];
        [GNStringUntils attributedString:mStr color:HDAppTheme.color.gn_333Color colorRange:mStr.string];
        [GNStringUntils attributedString:mStr font:[HDAppTheme.font gn_boldForSize:14] fontRange:mStr.string];
        self.numberLB.attributedText = mStr;
        self.statusLB.textColor = HDAppTheme.color.gn_333Color;
    } else {
        NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:str];
        [GNStringUntils attributedString:mStr color:HDAppTheme.color.gn_cccccc colorRange:mStr.string];
        [GNStringUntils attributedString:mStr center:YES colorRange:mStr.string];
        [GNStringUntils attributedString:mStr font:[HDAppTheme.font gn_boldForSize:14] fontRange:mStr.string];
        self.numberLB.attributedText = mStr;
        self.statusLB.textColor = HDAppTheme.color.gn_cccccc;
    }
}

- (HDLabel *)numberLB {
    if (!_numberLB) {
        _numberLB = HDLabel.new;
        _numberLB.font = [HDAppTheme.font gn_boldForSize:14];
    }
    return _numberLB;
}

- (HDLabel *)statusLB {
    if (!_statusLB) {
        _statusLB = HDLabel.new;
        _statusLB.font = [HDAppTheme.font gn_boldForSize:14];
        _statusLB.textAlignment = NSTextAlignmentRight;
    }
    return _statusLB;
}

- (HDUIButton *)pointView {
    if (!_pointView) {
        _pointView = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_pointView setBackgroundImage:[UIImage imageNamed:@"gn_order_numbg"] forState:UIControlStateNormal];
        _pointView.titleLabel.font = [HDAppTheme.font gn_boldForSize:16];
        [_pointView setTitleColor:HDAppTheme.color.gn_mainColor forState:UIControlStateNormal];
    }
    return _pointView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
        _bgView.layer.cornerRadius = kRealWidth(4);
        _bgView.layer.borderWidth = 1;
        _bgView.layer.borderColor = HDAppTheme.color.gn_mainColor.CGColor;
    }
    return _bgView;
}
@end
