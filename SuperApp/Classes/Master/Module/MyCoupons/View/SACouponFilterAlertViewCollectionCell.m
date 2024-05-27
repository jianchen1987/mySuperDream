//
//  SACouponFilterAlertViewCollectionCell.m
//  SuperApp
//
//  Created by Tia on 2022/7/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACouponFilterAlertViewCollectionCell.h"


@interface SACouponFilterAlertViewCollectionCell ()

@property (nonatomic, strong) HDUIGhostButton *button;

@end


@implementation SACouponFilterAlertViewCollectionCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.button];
}

- (void)updateConstraints {
    [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    [super updateConstraints];
}

#pragma mark setter
- (void)setText:(NSString *)text {
    _text = text;
    [self.button setTitle:text forState:UIControlStateNormal];
    [self setNeedsUpdateConstraints];
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (isSelected) {
        self.button.ghostColor = HDAppTheme.color.sa_C1;
        self.button.borderWidth = 1;
        self.button.backgroundColor = [HDAppTheme.color.sa_C1 colorWithAlphaComponent:0.06];
    } else {
        self.button.ghostColor = [UIColor hd_colorWithHexString:@"#999999"];
        ;
        self.button.borderWidth = 0;
        self.button.backgroundColor = [[UIColor hd_colorWithHexString:@"#999999"] colorWithAlphaComponent:0.1];
    }
}

#pragma mark lazy
- (HDUIGhostButton *)button {
    if (!_button) {
        HDUIGhostButton *button = [[HDUIGhostButton alloc] initWithGhostType:HDUIGhostButtonColorWhite];
        button.titleLabel.font = kSACouponFilterAlertViewCollectionCellFont;
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 16, 5, 16);
        button.backgroundColor = [[UIColor hd_colorWithHexString:@"#999999"] colorWithAlphaComponent:0.1];
        button.ghostColor = [UIColor hd_colorWithHexString:@"#999999"];
        button.userInteractionEnabled = NO;
        _button = button;
    }
    return _button;
}

@end
