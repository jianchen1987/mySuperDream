//
//  WMProductBoxFeeTableViewCell.m
//  SuperApp
//
//  Created by wmz on 2022/6/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMProductBoxFeeTableViewCell.h"
#import "SAMoneyModel.h"


@interface WMProductBoxFeeTableViewCell ()
/// 名称
@property (nonatomic, strong) SALabel *nameLB;
/// 售价
@property (nonatomic, strong) SALabel *salePriceLB;

@end


@implementation WMProductBoxFeeTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.salePriceLB];
    [self.nameLB setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setGNModel:(SAMoneyModel *)data {
    if ([data isKindOfClass:SAMoneyModel.class]) {
        self.salePriceLB.text = data.thousandSeparatorAmount;
    }
}

- (void)updateConstraints {
    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kRealWidth(15));
        make.left.equalTo(self.contentView).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.salePriceLB.mas_left).offset(-kRealWidth(10));
        make.bottom.equalTo(self.contentView).offset(-kRealWidth(15));
    }];
    [self.salePriceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
        make.centerY.equalTo(self.nameLB);
    }];
    [super updateConstraints];
}

#pragma mark - lazy load
- (SALabel *)nameLB {
    if (!_nameLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3Bold;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 0;
        label.text = WMLocalizedString(@"wm_packing_fee", @"打包费");
        _nameLB = label;
    }
    return _nameLB;
}

- (SALabel *)salePriceLB {
    if (!_salePriceLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3Bold;
        label.textColor = HexColor(0xF83E00);
        label.numberOfLines = 1;
        _salePriceLB = label;
    }
    return _salePriceLB;
}

@end
