//
//  PNRecentPacketRecordsHeaderView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNRecentPacketRecordsHeaderView.h"
#import "HDAppTheme+PayNow.h"
#import "HDMediator+PayNow.h"
#import "HDUIButton.h"
#import "PNMultiLanguageManager.h"
#import "SALabel.h"


@interface PNRecentPacketRecordsHeaderView ()
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) HDUIButton *moreBtn;
@end


@implementation PNRecentPacketRecordsHeaderView

- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.moreBtn];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.top.mas_equalTo(self.contentView.mas_top).offset(kRealWidth(8));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-kRealWidth(8));
    }];

    [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
    }];

    [super updateConstraints];
}

#pragma mark
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard16B;
        label.text = PNLocalizedString(@"pn_recent_red_packet", @"最近消息记录");
        _titleLabel = label;
    }
    return _titleLabel;
}

- (HDUIButton *)moreBtn {
    if (!_moreBtn) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"pn_arrow_gray_small"] forState:UIControlStateNormal];
        [btn setTitle:PNLocalizedString(@"more", @"更多") forState:UIControlStateNormal];
        [btn setTitleColor:HDAppTheme.PayNowColor.c999999 forState:UIControlStateNormal];
        btn.titleLabel.font = HDAppTheme.PayNowFont.standard12;
        [btn setImagePosition:HDUIButtonImagePositionRight];
        btn.titleEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"more");
            [HDMediator.sharedInstance navigaveToLuckPacketMessageVC:@{}];
        }];

        _moreBtn = btn;
    }
    return _moreBtn;
}
@end
