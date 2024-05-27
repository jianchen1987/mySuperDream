//
//  TNBargainMoreReusableView.m
//  SuperApp
//
//  Created by 张杰 on 2021/3/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNBargainMoreReusableView.h"
#import <Masonry.h>
#import "HDAppTheme+TinhNow.h"
#import "TNMultiLanguageManager.h"
#import "SAWindowManager.h"
#import "HDMediator+SuperApp.h"


@interface TNBargainMoreReusableView ()
/// 更多按钮
@property (strong, nonatomic) HDUIButton *moreBtn;
@end


@implementation TNBargainMoreReusableView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self hd_setupView];
    }
    return self;
}
- (void)hd_setupView {
    [self addSubview:self.moreBtn];
}
- (void)updateConstraints {
    [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}
/** @lazy moreBtn */
- (HDUIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [[HDUIButton alloc] init];
        _moreBtn.backgroundColor = HDAppTheme.TinhNowColor.C1;
        _moreBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:17];
        [_moreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_moreBtn setTitle:TNLocalizedString(@"tn_bargain_recommend_more", @"更多") forState:UIControlStateNormal];
        [_moreBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [[HDMediator sharedInstance] navigaveToTinhNowController:nil];
        }];
    }
    return _moreBtn;
}
@end
