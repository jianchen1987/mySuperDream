//
//  WMHomeGuideView.m
//  SuperApp
//
//  Created by wmz on 2021/11/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMHomeGuideView.h"
#import "WMFAQViewModel.h"


@interface WMHomeGuideView ()
/// normalRect
@property (nonatomic, assign) CGRect normalRect;
/// imageView
@property (nonatomic, strong) UIImageView *giudeIV;
/// DTO
@property (nonatomic, strong) WMFAQViewModel *viewModel;

@end


@implementation WMHomeGuideView

- (void)hd_setupViews {
    self.hidden = YES;
    self.show = YES;
    [self addSubview:self.giudeIV];

    [self updateStatus];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(linkAction)];
    [self addGestureRecognizer:tap];
}

///跳转
- (void)linkAction {
    [HDMediator.sharedInstance navigaveToFAQViewController:@{@"viewModel": self.viewModel}];
}

- (void)updateStatus {
    @HDWeakify(self)[self.viewModel yumNowQueryGuideLinkWithKey:@"index" block:^(WMFAQRspModel *_Nonnull rspModel) {
        @HDStrongify(self) self.hidden = (!rspModel || !rspModel.code);
        self.show = !self.hidden;
        [self layoutIfNeeded];
        self.normalRect = self.frame;
    }];
}

- (void)show {
    if (!self.isHidden && !self.show) {
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 1;
            CGRect rect = self.frame;
            rect.origin.x = self.normalRect.origin.x;
            self.frame = rect;
        } completion:^(BOOL finished) {
            self.show = YES;
        }];
    }
}

- (void)dissmiss {
    if (!self.isHidden && self.show) {
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0.5;
            CGRect rect = self.frame;
            rect.origin.x = kScreenWidth - self.normalRect.size.width / 2;
            self.frame = rect;
        } completion:^(BOOL finished) {
            self.show = NO;
        }];
    }
}

- (void)updateConstraints {
    [self.giudeIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(60), kRealWidth(57)));
    }];

    [super updateConstraints];
}

- (UIImageView *)giudeIV {
    if (!_giudeIV) {
        _giudeIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wm_home_guide"]];
        _giudeIV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _giudeIV;
}

- (WMFAQViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = WMFAQViewModel.new;
    }
    return _viewModel;
}

@end
