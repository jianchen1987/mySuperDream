//
//  GNCommonCell.m
//  SuperApp
//
//  Created by wmz on 2021/6/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNCommonCell.h"


@interface GNCommonCell ()
/// 右侧图片
@property (nonatomic, strong) HDUIButton *rightBtn;
/// 左侧文字
@property (nonatomic, strong) HDLabel *leftLB;
/// 右侧文字
@property (nonatomic, strong) HDLabel *rightLB;
/// 右侧点击
@property (nonatomic, strong) UIControl *rightHot;
@end


@implementation GNCommonCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.rightBtn];
    [self.contentView addSubview:self.leftLB];
    [self.contentView addSubview:self.rightLB];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.rightHot];
}

- (void)updateConstraints {
    [self.leftLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(HDAppTheme.value.gn_marginL);
        make.top.mas_offset(self.model.offset);
        make.bottom.mas_lessThanOrEqualTo(-(self.model.bottomOffset ?: self.model.offset));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
    }];

    [self.rightLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(self.model.offset);
        make.bottom.mas_lessThanOrEqualTo(-(self.model.bottomOffset ?: self.model.offset));
        if (self.rightBtn.isHidden) {
            make.right.mas_offset(-HDAppTheme.value.gn_marginL);
        } else {
            make.right.equalTo(self.rightBtn.mas_left);
        }
        make.left.equalTo(self.leftLB.mas_right).offset(kRealWidth(8));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
    }];

    [self.rightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.rightBtn.isHidden) {
            make.centerY.equalTo(self.rightLB);
            make.right.mas_offset(-HDAppTheme.value.gn_marginL);
            make.size.mas_equalTo(CGSizeMake(kRealWidth(16), kRealWidth(16)));
        }
    }];

    [self.rightHot mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.rightHot.isHidden) {
            make.right.mas_equalTo(0);
            make.left.equalTo(self.rightLB.mas_right);
            make.top.mas_equalTo(0);
            make.height.equalTo(self.contentView);
        }
    }];

    [self.rightLB setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.rightLB setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];

    [super updateConstraints];
}

- (void)setGNModel:(GNCellModel *)data {
    self.model = data;
    self.leftLB.text = data.title;
    self.leftLB.font = data.titleFont;
    self.rightLB.font = data.detailFont;
    if (data.image) {
        [self.rightBtn setImage:data.image forState:UIControlStateNormal];
    }
    self.rightHot.hidden = self.rightBtn.hidden = data.imageHide;
    self.rightLB.text = GNFillEmpty(data.detail);
    self.rightLB.textColor = data.detailColor ?: HDAppTheme.color.gn_333Color;
    self.lineView.hidden = data.lineHidden;
    self.rightHot.userInteractionEnabled = data.rightClickEnable;
    [self setNeedsUpdateConstraints];
}

- (void)rightAction {
    if (self.model.block && self.model.rightClickEnable) {
        self.model.block(0);
    }
}

- (HDUIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:@"gn_order_more"] forState:UIControlStateNormal];
        _rightBtn.userInteractionEnabled = NO;
    }
    return _rightBtn;
}

- (HDLabel *)leftLB {
    if (!_leftLB) {
        _leftLB = HDLabel.new;
        _leftLB.numberOfLines = 0;
        _leftLB.font = HDAppTheme.font.gn_13;
    }
    return _leftLB;
}

- (HDLabel *)rightLB {
    if (!_rightLB) {
        _rightLB = HDLabel.new;
        _rightLB.textAlignment = NSTextAlignmentRight;
        _rightLB.font = HDAppTheme.font.gn_13;
        _rightLB.numberOfLines = 0;
    }
    return _rightLB;
}

- (UIControl *)rightHot {
    if (!_rightHot) {
        _rightHot = UIControl.new;
        [_rightHot addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightHot;
}

@end
