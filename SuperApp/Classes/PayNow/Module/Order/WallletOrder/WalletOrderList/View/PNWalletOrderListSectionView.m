//
//  PNWalletOrderListSectionView.m
//  SuperApp
//
//  Created by xixi_wen on 2023/2/8.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNWalletOrderListSectionView.h"
#import "HDAppTheme+PayNow.h"
#import "PNCommonUtils.h"
#import "SALabel.h"


@interface PNWalletOrderListSectionView ()
@property (nonatomic, strong) SALabel *dateLabel;
@end


@implementation PNWalletOrderListSectionView

- (void)hd_setupViews {
    [self.contentView addSubview:self.dateLabel];
}

- (void)updateConstraints {
    [self.dateLabel sizeToFit];
    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(kRealWidth(16));
        make.width.mas_equalTo(self.dateLabel.size.width + 20);
        make.height.mas_equalTo(self.dateLabel.size.height + 8);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-kRealWidth(8));
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    [super updateConstraints];
}

#pragma mark
- (void)setDateStr:(NSString *)dateStr {
    _dateStr = dateStr;

    self.dateLabel.text = [PNCommonUtils getDateStrByFormat:@"MM/yyyy" withDate:[NSDate dateWithTimeIntervalSince1970:dateStr.doubleValue / 1000]];

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (SALabel *)dateLabel {
    if (!_dateLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14B;
        label.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        label.textAlignment = NSTextAlignmentCenter;
        //        label.hd_edgeInsets = UIEdgeInsetsMake(0, kRealWidth(8), 0, kRealWidth(8));
        label.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(12)];
        };
        _dateLabel = label;
    }
    return _dateLabel;
}

@end
