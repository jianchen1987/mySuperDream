//
//  SAOrderListFilterAlertViewCollectionReusableView.m
//  SuperApp
//
//  Created by Tia on 2023/2/8.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAOrderListFilterCollectionReusableView.h"
#import "UIColor+HDKitCore.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDUIKit/HDUIKit.h>
#import <Masonry.h>


@interface SAOrderListFilterCollectionReusableView ()

@property (nonatomic, strong) UILabel *sectionTitleLabel;

@end


@implementation SAOrderListFilterCollectionReusableView

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
