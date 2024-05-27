//
//  GNCancelListTableVIewCell.m
//  SuperApp
//
//  Created by wmz on 2022/7/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNCancelListTableVIewCell.h"


@interface GNCancelListTableVIewCell ()
///选中按钮
@property (nonatomic, strong) HDUIButton *selectBTN;
/// title
@property (nonatomic, strong) HDLabel *titleLB;

@end


@implementation GNCancelListTableVIewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.selectBTN];
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.lineView];
}

- (void)updateConstraints {
    [self.selectBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.top.mas_equalTo(kRealWidth(16));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
        make.left.equalTo(self.selectBTN.mas_right).offset(kRealWidth(4));
        make.right.mas_equalTo(-kRealWidth(12));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(18));
        make.top.equalTo(self.selectBTN.mas_top).offset(kRealWidth(2));
    }];
    [super updateConstraints];
}

- (void)setGNModel:(GNOrderCancelRspModel *)data {
    self.model = data;
    self.titleLB.text = data.name.desc;
    self.selectBTN.selected = data.isSelect;
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B3;
        label.font = [HDAppTheme.WMFont wm_ForSize:14];
        label.numberOfLines = 0;
        _titleLB = label;
    }
    return _titleLB;
}

- (HDUIButton *)selectBTN {
    if (!_selectBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"yn_coupon_select_nor"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"yn_coupon_select_sel"] forState:UIControlStateSelected];
        btn.adjustsButtonWhenHighlighted = NO;
        btn.userInteractionEnabled = NO;
        _selectBTN = btn;
    }
    return _selectBTN;
}

@end
