//
//  TNOrderSubmitTermsCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/4/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//  声明条款

#import "TNOrderSubmitTermsCell.h"
#import "HDAppTheme+TinhNow.h"
#import "TNTermsAlertView.h"


@implementation TNOrderSubmitTermsCellModel

@end


@interface TNOrderSubmitTermsCell ()
/// 同意条款按钮
@property (strong, nonatomic) HDUIButton *agreeBtn;
/// 文本
@property (strong, nonatomic) HDLabel *contentLB;
/// 更多按钮
@property (strong, nonatomic) HDUIButton *moreBtn;
@end


@implementation TNOrderSubmitTermsCell
- (void)hd_setupViews {
    self.contentView.backgroundColor = HDAppTheme.TinhNowColor.G5;
    [self.contentView addSubview:self.agreeBtn];
    [self.contentView addSubview:self.contentLB];
    [self.contentView addSubview:self.moreBtn];
    // 取出是否有存储过同意过条款
    BOOL hasAgreeTerms = [[NSUserDefaults standardUserDefaults] boolForKey:@"overseaTerms"];
    self.agreeBtn.selected = hasAgreeTerms;
}
- (void)updateConstraints {
    [self.agreeBtn sizeToFit];
    [self.agreeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(5));
    }];
    [self.contentLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.agreeBtn.mas_bottom).offset(kRealWidth(7));
        if (self.moreBtn.isHidden) {
            make.bottom.equalTo(self.contentView.mas_bottom);
        }
    }];
    if (!self.moreBtn.isHidden) {
        [self.moreBtn sizeToFit];
        [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
            make.top.equalTo(self.contentLB.mas_bottom).offset(kRealWidth(7));
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
    }

    [super updateConstraints];
}
- (void)setModel:(TNOrderSubmitTermsCellModel *)model {
    _model = model;
    if (HDIsStringNotEmpty(self.contentLB.text) && HDIsStringNotEmpty(model.contentTxt) && [self.contentLB.text isEqualToString:model.contentTxt]) {
        return;
    }
    self.contentLB.text = model.contentTxt;
    //是否显示查看更多按钮  最多显示5行
    CGFloat maxHeight = [self getTextHeightWithText:@"a \n b \n c \n d \n e"];
    CGFloat realHeight = [self getTextHeightWithText:model.contentTxt];
    self.moreBtn.hidden = realHeight < maxHeight;
    [self setNeedsUpdateConstraints];
}
//获取文本高度
- (CGFloat)getTextHeightWithText:(NSString *)text {
    CGFloat height = [text boundingAllRectWithSize:CGSizeMake(kScreenWidth - kRealWidth(30), MAXFLOAT) font:HDAppTheme.TinhNowFont.standard12 lineSpacing:5].height;
    return height;
}

/** @lazy agreeBtn */
- (HDUIButton *)agreeBtn {
    if (!_agreeBtn) {
        _agreeBtn = [[HDUIButton alloc] init];
        [_agreeBtn setImage:[UIImage imageNamed:@"tinhnow-unselect_agree_k"] forState:UIControlStateNormal];
        [_agreeBtn setImage:[UIImage imageNamed:@"tinhnow-selected_agree_k"] forState:UIControlStateSelected];
        [_agreeBtn setTitle:TNLocalizedString(@"0JqLdpAK", @"同意以下条款") forState:UIControlStateNormal];
        [_agreeBtn setTitleColor:HDAppTheme.TinhNowColor.C1 forState:UIControlStateNormal];
        _agreeBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:14];
        _agreeBtn.spacingBetweenImageAndTitle = 5;
        @HDWeakify(self);
        [_agreeBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            btn.selected = !btn.selected;
            [[NSUserDefaults standardUserDefaults] setBool:btn.selected forKey:@"overseaTerms"];
            if (self.clickAgreeTermsCallBack) {
                self.clickAgreeTermsCallBack(btn.selected);
            }
        }];
    }
    return _agreeBtn;
}
/** @lazy contentLB */
- (HDLabel *)contentLB {
    if (!_contentLB) {
        _contentLB = [[HDLabel alloc] init];
        _contentLB.font = HDAppTheme.TinhNowFont.standard12;
        _contentLB.textColor = HDAppTheme.TinhNowColor.G2;
        _contentLB.numberOfLines = 5;
        _contentLB.hd_lineSpace = 5;
    }
    return _contentLB;
}
/** @lazy moreBtn */
- (HDUIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [[HDUIButton alloc] init];
        [_moreBtn setTitle:TNLocalizedString(@"sKPxGR1K", @"查看更多 >") forState:UIControlStateNormal];
        [_moreBtn setTitleColor:HDAppTheme.TinhNowColor.C1 forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:12];
        @HDWeakify(self);
        [_moreBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            TNTermsAlertView *alertView = [TNTermsAlertView alertViewWithContentText:self.model.contentTxt];
            [alertView show];
        }];
    }
    return _moreBtn;
}
@end
