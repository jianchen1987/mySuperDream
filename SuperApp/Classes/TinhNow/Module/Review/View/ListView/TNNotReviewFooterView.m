//
//  TNNotReviewFooterView.m
//  SuperApp
//
//  Created by 张杰 on 2021/3/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNNotReviewFooterView.h"
#import "SAOperationButton.h"
#import "TNMultiLanguageManager.h"
#import <Masonry.h>
#import "HDAppTheme+TinhNow.h"


@interface TNNotReviewFooterView ()
/// 背景
@property (strong, nonatomic) UIView *bgView;
/// 写评论
@property (nonatomic, strong) SAOperationButton *reviewButton;
@end


@implementation TNNotReviewFooterView

- (void)hd_setupViews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.reviewButton];
}
- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(kRealWidth(50));
    }];
    [self.reviewButton sizeToFit];
    [self.reviewButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(15));
    }];
    [super updateConstraints];
}
/** @lazy review */
- (SAOperationButton *)reviewButton {
    if (!_reviewButton) {
        _reviewButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        _reviewButton.titleLabel.font = HDAppTheme.TinhNowFont.standard15;
        [_reviewButton applyHollowPropertiesWithTintColor:HDAppTheme.TinhNowColor.C1];
        [_reviewButton setTitle:TNLocalizedString(@"tn_write_review_k", @"写评价") forState:UIControlStateNormal];
        [_reviewButton setTitleEdgeInsets:UIEdgeInsetsMake(6, 10, 6, 10)];
        @HDWeakify(self);
        [_reviewButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.reviewClickCallBack) {
                self.reviewClickCallBack();
            }
        }];
    }
    return _reviewButton;
}
/** @lazy bgView */
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
@end
