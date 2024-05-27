//
//  WMProductPackingFeeTableViewCell.m
//  SuperApp
//
//  Created by VanJay on 2020/6/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMProductPackingFeeTableViewCell.h"
#import "GNEvent.h"


@interface WMProductPackingFeeTableViewCell ()
/// 名称
@property (nonatomic, strong) SALabel *nameLB;
/// 描述
@property (nonatomic, strong) SALabel *descLB;
/// 售价
@property (nonatomic, strong) SALabel *salePriceLB;
/// 数量显示
@property (nonatomic, strong) SALabel *countLB;
/// 线
@property (nonatomic, strong) UIView *bottomLine;
@end


@implementation WMProductPackingFeeTableViewCell
#pragma mark - SATableViewCellProtocol
- (void)hd_setupViews {
    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.countLB];
    [self.contentView addSubview:self.salePriceLB];
    [self.contentView addSubview:self.descLB];
    [self.contentView addSubview:self.bottomLine];

    [self.nameLB setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.descLB setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)hd_bindViewModel {
}

#pragma mark - setter
- (void)setGNModel:(WMShoppingCartPayFeeCalProductModel *)data {
    _model = data;
    self.nameLB.text = data.name.desc;

    if (SAMultiLanguageManager.isCurrentLanguageCN) {
        self.descLB.text = [NSString stringWithFormat:WMLocalizedString(@"wm_each_money", @"每%d收%@"), data.packageShare, data.packageFee.thousandSeparatorAmount];
    } else {
        self.descLB.text = [NSString stringWithFormat:WMLocalizedString(@"wm_each_money", @"每%d收%@"), data.packageFee.thousandSeparatorAmount, data.packageShare];
    }

    self.salePriceLB.text = data.totalPackageFee.thousandSeparatorAmount;
    self.countLB.text = [NSString stringWithFormat:@"x%zd", data.count];

    [self setNeedsUpdateConstraints];
}

#pragma mark - event response

#pragma mark - public methods

#pragma mark - private methods

#pragma mark - layout
- (void)updateConstraints {
    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kRealWidth(15));
        make.left.equalTo(self.contentView).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.countLB.mas_left).offset(-kRealWidth(10));
    }];
    [self.salePriceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
        make.centerY.equalTo(self.descLB);
    }];
    [self.countLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.salePriceLB);
        make.centerY.equalTo(self.nameLB);
    }];
    [self.descLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLB);
        make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
        make.top.equalTo(self.nameLB.mas_bottom).offset(kRealWidth(7));
    }];

    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.bottomLine.isHidden) {
            make.left.equalTo(self.contentView).offset(HDAppTheme.value.padding.left);
            make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
            make.height.mas_equalTo(PixelOne);
            make.top.equalTo(self.descLB.mas_bottom).offset(kRealWidth(15));
            make.bottom.equalTo(self.contentView);
        }
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
        _nameLB = label;
    }
    return _nameLB;
}

- (SALabel *)countLB {
    if (!_countLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 1;
        _countLB = label;
    }
    return _countLB;
}

- (SALabel *)descLB {
    if (!_descLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard4;
        label.textColor = HDAppTheme.color.G3;
        label.numberOfLines = 0;
        _descLB = label;
    }
    return _descLB;
}

- (SALabel *)salePriceLB {
    if (!_salePriceLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.WMFont wm_ForMoneyDinSize:14];
        label.textColor = HDAppTheme.WMColor.mainRed;
        label.numberOfLines = 1;
        _salePriceLB = label;
    }
    return _salePriceLB;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = UIView.new;
        _bottomLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _bottomLine;
}
@end
