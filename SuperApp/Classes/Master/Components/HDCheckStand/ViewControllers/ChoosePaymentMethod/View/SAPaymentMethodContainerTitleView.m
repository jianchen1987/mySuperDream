//
//  SAPaymentMethodContainerView.m
//  SuperApp
//
//  Created by seeu on 2022/5/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAPaymentMethodContainerTitleView.h"


@interface SAPaymentMethodContainerTitleView ()
///< 标题
@property (nonatomic, strong) SALabel *titleLabel;
@end


@implementation SAPaymentMethodContainerTitleView

- (void)hd_setupViews {
    [self addSubview:self.titleLabel];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kRealHeight(15), kRealWidth(10), kRealHeight(15), 0));
    }];

    [super updateConstraints];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
/** @lazy titlelabel */
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[SALabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightBold];
        _titleLabel.textColor = [UIColor hd_colorWithHexString:@"#ADB6C8"];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

@end
