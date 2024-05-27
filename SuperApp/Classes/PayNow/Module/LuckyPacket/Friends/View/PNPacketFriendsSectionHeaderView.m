//
//  PNPacketFriendsSectionHeaderView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketFriendsSectionHeaderView.h"
#import "HDAppTheme+PayNow.h"
#import "HDMediator+PayNow.h"
#import "PNMultiLanguageManager.h"
#import "SALabel.h"


@interface PNPacketFriendsSectionHeaderView ()
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) UIView *line;
@end


@implementation PNPacketFriendsSectionHeaderView

- (void)hd_setupViews {
    self.contentView.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.line];

    self.contentView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:kRealWidth(10)];
    };
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.contentView.mas_top).offset(kRealWidth(16));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-kRealWidth(13));
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-1);
        make.height.equalTo(@(PixelOne));
    }];

    [super updateConstraints];
}

#pragma mark
- (void)setSectionTitle:(NSString *)sectionTitle {
    _sectionTitle = sectionTitle;

    self.titleLabel.text = self.sectionTitle;

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard16B;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIView *)line {
    if (!_line) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.lineColor;

        _line = view;
    }
    return _line;
}

@end
