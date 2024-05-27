//
//  WMCNStoreInfoView.m
//  SuperApp
//
//  Created by wmz on 2023/1/9.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMCNStoreInfoView.h"


@implementation WMCNStoreInfoView

- (void)hd_setupViews {
    [self addSubview:self.bgView];
    [self addNormalView];
}

- (void)addNormalView {
    [super addNormalView];
    self.promotionsTitleLabel.textColor = HDAppTheme.WMColor.B3;
    self.promotionsTitleLabel.font = [HDAppTheme.WMFont wm_boldForSize:14];

    self.businessTitleLabel.textColor = HDAppTheme.WMColor.B3;
    self.businessTitleLabel.font = [HDAppTheme.WMFont wm_boldForSize:14];

    self.businessScopesTitleLabel.textColor = HDAppTheme.WMColor.B3;
    self.businessScopesTitleLabel.font = [HDAppTheme.WMFont wm_boldForSize:14];

    self.payMethodTitleLabel.textColor = HDAppTheme.WMColor.B3;
    self.payMethodTitleLabel.font = [HDAppTheme.WMFont wm_boldForSize:14];

    self.noticeTitleLabel.textColor = HDAppTheme.WMColor.B3;
    self.noticeTitleLabel.font = [HDAppTheme.WMFont wm_boldForSize:14];

    self.businessLabel.textColor = HDAppTheme.WMColor.B6;
    self.businessLabel.font = [HDAppTheme.WMFont wm_ForSize:12];

    self.businessScopesLabel.textColor = HDAppTheme.WMColor.B6;
    self.businessScopesLabel.font = [HDAppTheme.WMFont wm_ForSize:12];

    self.payMethodLabel.textColor = HDAppTheme.WMColor.B6;
    self.payMethodLabel.font = [HDAppTheme.WMFont wm_ForSize:12];

    self.noticeLabel.textColor = HDAppTheme.WMColor.B6;
    self.noticeLabel.font = [HDAppTheme.WMFont wm_ForSize:12];
}

- (void)hd_reloadData {
    [super hd_reloadData];

    self.businessLabel.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(24);
    NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:@""];
    NSArray *dayArr = @[];
    NSString *daysStr = [self.viewModel transformDay];
    if (!HDIsStringEmpty(daysStr) && [daysStr containsString:@" "]) {
        dayArr = [daysStr componentsSeparatedByString:@" "];
    }
    int i = 0;
    for (NSString *str in dayArr) {
        NSMutableAttributedString *spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill
                                                                                          attachmentSize:CGSizeMake(kRealWidth(8), 1)
                                                                                             alignToFont:[HDAppTheme.WMFont wm_ForSize:12]
                                                                                               alignment:YYTextVerticalAlignmentCenter];
        [mstr appendAttributedString:spaceText];

        NSMutableAttributedString *st = [[NSMutableAttributedString alloc] initWithString:str];
        YYTextBorder *boder = YYTextBorder.new;
        boder.cornerRadius = kRealWidth(2);
        boder.fillColor = HDAppTheme.WMColor.bgGray;
        boder.insets = UIEdgeInsetsMake(-kRealWidth(4), -kRealWidth(8), -kRealWidth(4), -kRealWidth(8));
        st.yy_textBackgroundBorder = boder;
        [mstr appendAttributedString:st];

        spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill attachmentSize:CGSizeMake(kRealWidth(14), 1)
                                                                  alignToFont:[HDAppTheme.WMFont wm_ForSize:12]
                                                                    alignment:YYTextVerticalAlignmentCenter];
        [mstr appendAttributedString:spaceText];
        i++;
    }

    NSArray<NSString *> *arrayList = [self.viewModel.repModel.businessHours mapObjectsUsingBlock:^id _Nonnull(NSArray<NSString *> *_Nonnull obj, NSUInteger idx) {
        return [obj componentsJoinedByString:@"-"];
    }];
    NSString *hoursStr = [arrayList componentsJoinedByString:@"\n"];
    NSMutableAttributedString *st = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", hoursStr]];
    [mstr appendAttributedString:st];
    mstr.yy_maximumLineHeight = kRealWidth(22);
    mstr.yy_minimumLineHeight = kRealWidth(22);
    mstr.yy_lineSpacing = kRealWidth(4);
    mstr.yy_alignment = NSTextAlignmentLeft;
    mstr.yy_font = [HDAppTheme.WMFont wm_ForSize:12];
    mstr.yy_color = HDAppTheme.WMColor.B6;
    self.businessLabel.attributedText = mstr;
}

- (void)updateConstrainAction {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
    }];

    __block UIView *lastShowView = nil;
    [self.promotionsTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.promotionsTitleLabel.isHidden) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            lastShowView = self.promotionsTitleLabel;
        }
    }];

    NSMutableArray *tempArr = [NSMutableArray array];
    [self.promotionsBgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (!obj.isHidden) {
            [tempArr addObject:obj];
        }
    }];

    UIView *lastView = nil;
    for (UIView *view in tempArr) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!lastView) {
                make.top.equalTo(self.promotionsBgView.mas_top);
            } else {
                make.top.equalTo(lastView.mas_bottom);
            }
            make.right.lessThanOrEqualTo(self.promotionsBgView);
            make.left.equalTo(self.promotionsBgView);
            if (view == tempArr.lastObject) {
                make.bottom.equalTo(self.promotionsBgView.mas_bottom);
            }
        }];
        lastView = view;
    }

    self.promotionsBgView.hidden = HDIsArrayEmpty(tempArr);
    [self.promotionsBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.promotionsBgView.isHidden) {
            if (lastShowView) {
                make.top.equalTo(lastShowView.mas_bottom).offset(kRealWidth(8));
            } else {
                make.top.mas_equalTo(0);
            }
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            lastShowView = self.promotionsBgView;
        }
    }];

    [self.noticeTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.noticeTitleLabel.isHidden) {
            make.left.right.mas_equalTo(0);
            if (lastShowView) {
                make.top.equalTo(lastShowView.mas_bottom).offset(kRealWidth(16));
            } else {
                make.top.mas_equalTo(0);
            }
            lastShowView = self.noticeTitleLabel;
        }
    }];

    [self.noticeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.noticeLabel.isHidden) {
            make.top.equalTo(lastShowView.mas_bottom).offset(kRealWidth(8));
            make.left.right.mas_equalTo(0);
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(20));
            lastShowView = self.noticeLabel;
        }
    }];

    [self.businessTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (lastShowView) {
            make.top.equalTo(lastShowView.mas_bottom).offset(kRealWidth(16));
        } else {
            make.top.mas_equalTo(0);
        }
        make.left.right.mas_equalTo(0);
        lastShowView = self.businessTitleLabel;
    }];

    [self.businessLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.businessLabel.isHidden) {
            make.top.equalTo(lastShowView.mas_bottom).offset(kRealWidth(8));
            make.left.right.equalTo(self.businessLabel);
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(20));
            lastShowView = self.businessLabel;
        }
    }];

    [self.businessScopesTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.businessScopesTitleLabel.isHidden) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(lastShowView.mas_bottom).offset(kRealHeight(16));
            lastShowView = self.businessScopesTitleLabel;
        }
    }];

    [self.businessScopesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.businessScopesLabel.isHidden) {
            make.top.equalTo(lastShowView.mas_bottom).offset(kRealWidth(8));
            make.left.right.mas_equalTo(0);
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(20));
            lastShowView = self.businessScopesLabel;
        }
    }];

    [self.payMethodTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.payMethodTitleLabel.isHidden) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(lastShowView.mas_bottom).offset(kRealHeight(16));
            lastShowView = self.payMethodTitleLabel;
        }
    }];

    [self.payMethodLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.payMethodLabel.isHidden) {
            make.top.equalTo(lastShowView.mas_bottom).offset(kRealWidth(8));
            make.left.right.mas_equalTo(0);
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(20));
            lastShowView = self.payMethodLabel;
        }
    }];
}

@end
