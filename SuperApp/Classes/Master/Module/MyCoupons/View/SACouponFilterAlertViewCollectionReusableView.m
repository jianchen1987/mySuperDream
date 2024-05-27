//
//  SACouponFilterAlertViewCollectionReusableView.m
//  SuperApp
//
//  Created by Tia on 2022/7/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACouponFilterAlertViewCollectionReusableView.h"
#import "UIColor+HDKitCore.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDUIKit/HDUIKit.h>
#import <Masonry.h>


@interface SACouponFilterAlertViewCollectionReusableView ()

@property (nonatomic, strong) UILabel *sectionTitleLabel;

@end


@implementation SACouponFilterAlertViewCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self hd_setupViews];
    }
    return self;
}

- (void)hd_setupViews {
    [self addSubview:self.sectionTitleLabel];
}

- (void)updateConstraints {
    [self.sectionTitleLabel sizeToFit];
    [self.sectionTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.mas_equalTo(kRealWidth(12));
    }];
    [super updateConstraints];
}

#pragma mark setter
- (void)setText:(NSString *)text {
    _text = text;
    self.sectionTitleLabel.text = text;
    [self setNeedsUpdateConstraints];
}

#pragma mark lazy
- (UILabel *)sectionTitleLabel {
    if (!_sectionTitleLabel) {
        _sectionTitleLabel = UILabel.new;
        _sectionTitleLabel.font = [HDAppTheme.font boldForSize:14];
        _sectionTitleLabel.textColor = [UIColor hd_colorWithHexString:@"333333"];
    }
    return _sectionTitleLabel;
}

@end
