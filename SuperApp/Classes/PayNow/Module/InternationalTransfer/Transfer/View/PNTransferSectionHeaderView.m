//
//  PNTransferSectionHeaderView.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNTransferSectionHeaderView.h"
#import "PNView.h"


@interface PNTransferSectionHeaderView ()
///
@property (strong, nonatomic) UILabel *titleLabel;
@property (nonatomic, strong) HDUIButton *rightBtn;
@end


@implementation PNTransferSectionHeaderView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.rightBtn];
}

- (void)setTitle:(NSString *)title rightImage:(UIImage *)rightBtnImage {
    //    _title = title;

    self.titleLabel.text = title;
    if (!WJIsObjectNil(rightBtnImage)) {
        [self.rightBtn setImage:rightBtnImage forState:UIControlStateNormal];
        self.rightBtn.hidden = NO;
    } else {
        self.rightBtn.hidden = YES;
    }

    [self setNeedsUpdateConstraints];
}


- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        if (self.rightBtn.hidden) {
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        } else {
            make.right.lessThanOrEqualTo(self.rightBtn.mas_left).offset(-kRealWidth(12));
        }
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(15));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(5));
    }];

    if (!self.rightBtn.hidden) {
        [self.rightBtn sizeToFit];
        [self.rightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(kRealWidth(-12));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    }

    [super updateConstraints];
}

/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [HDAppTheme.PayNowFont fontBold:16];
        _titleLabel.textColor = HDAppTheme.PayNowColor.mainThemeColor;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (HDUIButton *)rightBtn {
    if (!_rightBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.hidden = YES;

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.rightBtnClickBlock ?: self.rightBtnClickBlock();
        }];

        _rightBtn = button;
    }
    return _rightBtn;
}
@end
