//
//  SAWalletBillTableHeaderView.m
//  SuperApp
//
//  Created by VanJay on 2020/8/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAWalletBillTableHeaderView.h"
#import "SALabel.h"
#import <HDKitCore/HDKitCore.h>
#import <HDUIKit/HDUIKit.h>
#import <Masonry.h>


@interface SAWalletBillTableHeaderView ()
/// 按钮
@property (nonatomic, strong) HDUIGhostButton *dateBTN;
/// 描述
@property (nonatomic, strong) SALabel *descLB;
@end


@implementation SAWalletBillTableHeaderView

- (void)hd_setupViews {
    [self.contentView addSubview:self.dateBTN];
    [self.contentView addSubview:self.descLB];

    self.contentView.backgroundColor = HDAppTheme.color.G5;
}

#pragma mark - setter
- (void)setModel:(SAWalletBillTableHeaderViewModel *)model {
    _model = model;

    [self.dateBTN setTitle:model.btnTitle forState:UIControlStateNormal];

    if (model.attrDesc) {
        self.descLB.attributedText = model.attrDesc;
    } else {
        self.descLB.text = model.desc;
        self.descLB.textColor = model.descColor;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - layout
- (void)updateConstraints {
    [self.dateBTN sizeToFit];
    [self.dateBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.dateBTN.bounds.size);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(HDAppTheme.value.padding.left);
    }];

    [self.descLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.dateBTN.mas_right).offset(5);
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (HDUIGhostButton *)dateBTN {
    if (!_dateBTN) {
        _dateBTN = [HDUIGhostButton buttonWithType:UIButtonTypeCustom];
        _dateBTN.titleEdgeInsets = UIEdgeInsetsMake(5, 20, 5, 20);
        [_dateBTN setTitleColor:HDAppTheme.color.G2 forState:UIControlStateNormal];
        [_dateBTN setBackgroundColor:UIColor.whiteColor];
        _dateBTN.titleLabel.font = HDAppTheme.font.standard3;
        _dateBTN.layer.borderColor = HDAppTheme.color.G4.CGColor;
        _dateBTN.borderWidth = 1;
    }
    return _dateBTN;
}

- (SALabel *)descLB {
    if (!_descLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G3;
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentRight;
        label.adjustsFontSizeToFitWidth = true;
        label.minimumScaleFactor = 0.5;
        _descLB = label;
    }
    return _descLB;
}

@end
