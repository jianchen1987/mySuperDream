//
//  SAUserBillListHeaderView.m
//  SuperApp
//
//  Created by seeu on 2022/4/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAUserBillListHeaderView.h"
#import "SALabel.h"


@interface SAUserBillListHeaderView ()

/// 按钮
@property (nonatomic, strong) HDUIGhostButton *dateBTN;
/// 描述
@property (nonatomic, strong) SALabel *descLB;

@end


@implementation SAUserBillListHeaderView

- (void)hd_setupViews {
    [self.contentView addSubview:self.dateBTN];
    [self.contentView addSubview:self.descLB];

    self.contentView.backgroundColor = HDAppTheme.color.G5;
}

#pragma mark - setter
- (void)setModel:(HDTableHeaderFootViewModel *)model {
    _model = model;

    [self.dateBTN setTitle:model.title forState:UIControlStateNormal];

    if (HDIsStringNotEmpty(model.rightButtonTitle)) {
        self.descLB.text = model.rightButtonTitle;
    } else {
        self.descLB.text = @"";
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - action
- (void)clickOnTitle:(HDUIGhostButton *)button {
    !self.titleClickedHander ?: self.titleClickedHander(self.model);
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
        [_dateBTN addTarget:self action:@selector(clickOnTitle:) forControlEvents:UIControlEventTouchUpInside];
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
