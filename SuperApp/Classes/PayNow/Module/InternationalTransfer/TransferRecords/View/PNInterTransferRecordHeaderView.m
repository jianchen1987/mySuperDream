//
//  PNInterTransferRecordHeaderView.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferRecordHeaderView.h"
#import "PNView.h"


@interface PNInterTransferRecordHeaderView ()
///
@property (strong, nonatomic) UILabel *titleLabel;
@end


@implementation PNInterTransferRecordHeaderView

- (void)hd_setupViews {
    self.contentView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.contentView addSubview:self.titleLabel];
}
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}
- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(10));
    }];
    [super updateConstraints];
}
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [HDAppTheme.PayNowFont fontRegular:14];
        _titleLabel.textColor = HDAppTheme.PayNowColor.c333333;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

@end
