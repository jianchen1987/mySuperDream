//
//  GNStoreDetailSectionView.m
//  SuperApp
//
//  Created by wmz on 2022/6/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNStoreDetailSectionView.h"
#import "GNImageTableViewCell.h"


@interface GNStoreDetailSectionView ()
@property (nonatomic, strong) HDLabel *label;
@property (nonatomic, strong) HDUIButton *rightBTN;
@end


@implementation GNStoreDetailSectionView

- (void)hd_setupViews {
    [self.contentView addSubview:self.label];
    [self.contentView addSubview:self.rightBTN];
}

- (void)updateConstraints {
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.bottom.mas_equalTo(-kRealWidth(8));
        make.top.mas_equalTo(kRealWidth(16));
        make.height.mas_equalTo(kRealWidth(30));
    }];

    [self.rightBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(12));
        make.centerY.equalTo(self.label);
    }];
    [super updateConstraints];
}

- (void)setGNModel:(GNCellModel *)data {
    self.model = data;
    self.label.text = data.title;
    self.rightBTN.hidden = !data.detail;
    [self.rightBTN setTitle:data.detail forState:UIControlStateNormal];
    self.contentView.backgroundColor = HDAppTheme.color.gn_whiteColor;
}

- (HDLabel *)label {
    if (!_label) {
        HDLabel *la = HDLabel.new;
        la.textColor = HDAppTheme.color.gn_333Color;
        la.font = [HDAppTheme.font gn_boldForSize:20];
        _label = la;
    }
    return _label;
}

- (HDUIButton *)rightBTN {
    if (!_rightBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"gn_storeinfo_gengd"] forState:UIControlStateNormal];
        [btn setTitle:@"View 15 Photos" forState:UIControlStateNormal];
        btn.titleLabel.font = [HDAppTheme.font gn_ForSize:12 weight:UIFontWeightMedium];
        btn.spacingBetweenImageAndTitle = kRealWidth(6);
        btn.imagePosition = HDUIButtonImagePositionRight;
        [btn setTitleColor:HDAppTheme.color.gn_333Color forState:UIControlStateNormal];
        @HDWeakify(self)[btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[GNEvent eventResponder:self target:btn key:@"sectionAction" indexPath:nil info:@{@"model": self.model}];
        }];
        _rightBTN = btn;
    }
    return _rightBTN;
}

@end
