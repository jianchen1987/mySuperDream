//
//  SAHomeMenuNavView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAHomeMenuNavView.h"
#import "LKDataRecord.h"
//#import "SAHomeMenuLanguageView.h"


@interface SAHomeMenuNavView ()
/// logo
@property (nonatomic, strong) HDUIButton *logoBTN;
/// 扫一扫按钮
@property (nonatomic, strong) HDUIButton *scanBTN;
/// 切换语言view
//@property (nonatomic, strong) SAHomeMenuLanguageView *languageView;
@end


@implementation SAHomeMenuNavView

- (void)hd_setupViews {
    [self addSubview:self.logoBTN];
    [self addSubview:self.scanBTN];
    //    [self addSubview:self.languageView];
}

- (void)updateConstraints {
    [self.logoBTN sizeToFit];
    [self.logoBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.logoBTN.width);
        make.height.mas_equalTo(44);
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(HDAppTheme.value.padding.left);
        make.top.bottom.equalTo(self);
    }];

    [self.scanBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.logoBTN.mas_right).offset(kRealWidth(15));
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-HDAppTheme.value.padding.right);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];

    //    [self.languageView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.left.greaterThanOrEqualTo(self.logoBTN.mas_right).offset(kRealWidth(15));
    //        make.centerY.equalTo(self);
    //        make.right.equalTo(self).offset(-HDAppTheme.value.padding.right);
    //    }];
    [super updateConstraints];
}

#pragma mark - lazy load
- (HDUIButton *)logoBTN {
    if (!_logoBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.color.sa_C1 forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.userInteractionEnabled = false;
        button.titleLabel.font = HDAppTheme.font.standard2Bold;
        [button setImage:[UIImage imageNamed:@"home_logo_have_slogan"] forState:UIControlStateNormal];
        _logoBTN = button;
    }
    return _logoBTN;
}

- (HDUIButton *)scanBTN {
    if (!_scanBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setImage:[UIImage imageNamed:@"icon_scan"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToScanViewController:nil];
            [LKDataRecord.shared traceClickEvent:@"wownow_home_scan" parameters:@{} SPM:[LKSPM SPMWithPage:@"SANewHomeViewController" area:@"" node:@""]];
        }];
        _scanBTN = button;
    }
    return _scanBTN;
}

//- (SAHomeMenuLanguageView *)languageView {
//    if (!_languageView) {
//        _languageView = SAHomeMenuLanguageView.new;
//        [_languageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//    }
//    return _languageView;
//}

@end
