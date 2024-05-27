//
//  SAOrderListFilterCollectionViewCell.m
//  SuperApp
//
//  Created by Tia on 2023/2/8.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAOrderListFilterCollectionViewCell.h"


@interface SAOrderListFilterCollectionViewCell ()

@property (nonatomic, strong) HDUIGhostButton *button;

@end


@implementation SAOrderListFilterCollectionViewCell

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
    } else {
        self.button.ghostColor = HDAppTheme.color.sa_C333;
        self.button.borderWidth = 0;
    }
}

#pragma mark lazy
- (HDUIGhostButton *)button {
    if (!_button) {
        HDUIGhostButton *button = [[HDUIGhostButton alloc] initWithGhostType:HDUIGhostButtonColorWhite];
        button.titleLabel.font = HDAppTheme.font.sa_standard12M;
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 16, 5, 16);
        button.backgroundColor = UIColor.whiteColor;
        button.ghostColor = HDAppTheme.color.sa_C333;
        button.userInteractionEnabled = NO;
        _button = button;
    }
    return _button;
}

@end
