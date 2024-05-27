//
//  TNOrderSubmitTipCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/4/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//  提示文本

#import "TNOrderTipCell.h"
#import "HDAppTheme+TinhNow.h"
#import "SAOperationButton.h"


@implementation TNOrderTipCellModel

@end


@interface TNOrderTipCell ()
/// 提示图片
@property (strong, nonatomic) UIImageView *tipIV;
/// 文案
@property (strong, nonatomic) HDLabel *contentLB;
/// 刷新审核状态按钮
@property (strong, nonatomic) SAOperationButton *refrenshReviewingButton;
@end


@implementation TNOrderTipCell
- (void)hd_setupViews {
    //
    [self.contentView addSubview:self.tipIV];
    [self.contentView addSubview:self.contentLB];
    [self.contentView addSubview:self.refrenshReviewingButton];
}
- (void)updateConstraints {
    if (!self.tipIV.isHidden) {
        [self.tipIV sizeToFit];
        [self.tipIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
            make.size.mas_equalTo(self.tipIV.image.size);
        }];
    }
    [self.contentLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.tipIV.isHidden) {
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        } else {
            make.left.equalTo(self.tipIV.mas_right).offset(kRealWidth(9));
        }
        make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(9));
        if (self.refrenshReviewingButton.isHidden) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(9));
        }
    }];
    if (!self.refrenshReviewingButton.isHidden) {
        [self.refrenshReviewingButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(50));
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(50));
            make.top.equalTo(self.contentLB.mas_bottom).offset(kRealWidth(15));
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(10));
        }];
    }
    [super updateConstraints];
}
- (void)setModel:(TNOrderTipCellModel *)model {
    _model = model;
    self.contentLB.text = model.tipText;
    self.refrenshReviewingButton.hidden = !model.isNeedShowRefreshBtn;
    if (model.isNeedShowRefreshBtn) {
        self.contentView.backgroundColor = [UIColor colorWithRed:253 / 255.0 green:136 / 255.0 blue:36 / 255.0 alpha:0.1];
        self.tipIV.hidden = YES;
        self.contentLB.textColor = HDAppTheme.TinhNowColor.C1;
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    [self setNeedsUpdateConstraints];
}
/** @lazy tipIV */
- (UIImageView *)tipIV {
    if (!_tipIV) {
        _tipIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_tips_icon"]];
    }
    return _tipIV;
}
/** @lazy contentLB */
- (HDLabel *)contentLB {
    if (!_contentLB) {
        _contentLB = [[HDLabel alloc] init];
        _contentLB.font = HDAppTheme.TinhNowFont.standard12M;
        _contentLB.textColor = HDAppTheme.TinhNowColor.G1;
        _contentLB.numberOfLines = 0;
        _contentLB.hd_lineSpace = 3;
    }
    return _contentLB;
}
- (SAOperationButton *)refrenshReviewingButton {
    if (!_refrenshReviewingButton) {
        _refrenshReviewingButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        _refrenshReviewingButton.tag = 15;
        [_refrenshReviewingButton applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.C1];
        _refrenshReviewingButton.borderWidth = 0;
        _refrenshReviewingButton.borderColor = HDAppTheme.TinhNowColor.C1;
        [_refrenshReviewingButton setTitle:TNLocalizedString(@"8Je39TOV", @"刷新审核状态") forState:UIControlStateNormal];
        _refrenshReviewingButton.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        [_refrenshReviewingButton setTitleEdgeInsets:UIEdgeInsetsMake(6, 15, 6, 15)];
        @HDWeakify(self);
        [_refrenshReviewingButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.refreshClickCallBack) {
                self.refreshClickCallBack();
            }
        }];
    }
    return _refrenshReviewingButton;
}
@end
