//
//  PNMSOpenSectionHeaderView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/5/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSOpenSectionHeaderView.h"
#import "HDAppTheme+PayNow.h"
#import "HDTableHeaderFootViewModel.h"
#import "PNUtilMacro.h"
#import "SALabel.h"


@interface PNMSOpenSectionHeaderView ()
@property (nonatomic, strong) SALabel *sectionTitleLabel;
@end


@implementation PNMSOpenSectionHeaderView

- (void)hd_setupViews {
    [self.contentView addSubview:self.sectionTitleLabel];
}

- (void)updateConstraints {
    [self.sectionTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.contentView.mas_right).offset(kRealWidth(-12));
        make.top.mas_equalTo(self.contentView.mas_top).offset(kRealWidth(15));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(kRealWidth(-4));
    }];
    [super updateConstraints];
}

- (void)setModel:(HDTableHeaderFootViewModel *)model {
    _model = model;
    self.sectionTitleLabel.text = self.model.title;
}

#pragma mark
- (SALabel *)sectionTitleLabel {
    if (!_sectionTitleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.mainThemeColor;
        label.font = HDAppTheme.PayNowFont.standard16B;
        _sectionTitleLabel = label;
    }
    return _sectionTitleLabel;
}

@end
