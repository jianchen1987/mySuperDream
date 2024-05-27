//
//  TNNotReviewHeaderView.m
//  SuperApp
//
//  Created by 张杰 on 2021/3/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNNotReviewHeaderView.h"
#import <HDUIKit/HDUIKit.h>
#import "HDAppTheme+TinhNow.h"
#import "TNMultiLanguageManager.h"
#import <Masonry.h>
#import "TNMyNotReviewModel.h"
#import "HDMediator+TinhNow.h"


@interface TNNotReviewHeaderView ()
/// 背景
@property (strong, nonatomic) UIView *bgView;
/// 店铺名字
@property (strong, nonatomic) HDLabel *nameLabel;
/// 标签
@property (strong, nonatomic) HDLabel *tagLabel;
/// 右边按钮
@property (strong, nonatomic) UIImageView *rightImageView;
/// 底部线条
@property (strong, nonatomic) UIView *lineView;
@end


@implementation TNNotReviewHeaderView

- (void)hd_setupViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.nameLabel];
    [self.bgView addSubview:self.tagLabel];
    [self.bgView addSubview:self.rightImageView];
    [self.bgView addSubview:self.lineView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClick:)];
    [self addGestureRecognizer:tap];
}
- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(kRealWidth(40));
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.left.equalTo(self.bgView.mas_left).offset(kRealWidth(15));
    }];
    [self.tagLabel sizeToFit];
    [self.tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.left.equalTo(self.nameLabel.mas_right).offset(kRealWidth(12));
        make.right.lessThanOrEqualTo(self.rightImageView.mas_left).offset(-10);
    }];
    [self.rightImageView sizeToFit];
    [self.rightImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(15));
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(15));
        make.bottom.equalTo(self.bgView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [super updateConstraints];
}
- (void)setStoreInfo:(TNMyNotReviewStoreInfo *)storeInfo {
    _storeInfo = storeInfo;
    self.nameLabel.text = storeInfo.name;
    if (HDIsStringNotEmpty(storeInfo.type) && [storeInfo.type isEqualToString:@"SELF"]) {
        self.tagLabel.hidden = NO;
    } else {
        self.tagLabel.hidden = YES;
    }
    [self setNeedsUpdateConstraints];
}
- (void)itemClick:(UITapGestureRecognizer *)tap {
    [HDMediator.sharedInstance navigaveToTinhNowStoreInfoViewController:@{@"storeNo": self.storeInfo.storeNo}];
}
/** @lazy nameLabel */
- (HDLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[HDLabel alloc] init];
        _nameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _nameLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    return _nameLabel;
}

/** @lazy tagLabel */
- (HDLabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[HDLabel alloc] init];
        _tagLabel.textColor = [UIColor whiteColor];
        _tagLabel.font = HDAppTheme.TinhNowFont.standard12;
        _tagLabel.hd_edgeInsets = UIEdgeInsetsMake(2, 6, 2, 6);
        _tagLabel.backgroundColor = HDAppTheme.TinhNowColor.C1;
        _tagLabel.text = TNLocalizedString(@"tn_merchant_tyle_self", @"自营");
        _tagLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _tagLabel;
}
/** @lazy rightImageView */
- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_gray_small"]];
    }
    return _rightImageView;
}
/** @lazy lineView */
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HexColor(0xE1E1E1);
    }
    return _lineView;
}
/** @lazy bgView */
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }
    return _bgView;
}
@end
