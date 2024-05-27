//
//  TNQuestionAndContactView.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/17.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNQuestionAndContactView.h"
#import "TNCustomerServiceView.h"
#import "TNPhoneActionAlertView.h"


@interface TNQuestionAndContactView ()
@property (strong, nonatomic) UILabel *doubtLabel;    ///<  疑问文本
@property (strong, nonatomic) HDUIButton *contactBtn; ///< 联系平台
@end


@implementation TNQuestionAndContactView
- (void)hd_setupViews {
    [self addSubview:self.doubtLabel];
    [self addSubview:self.contactBtn];
}
- (void)updateConstraints {
    [self.doubtLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.mas_top);
    }];
    [self.contactBtn sizeToFit];
    [self.contactBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.doubtLabel.mas_bottom).offset(kRealWidth(5));
        make.bottom.equalTo(self.mas_bottom);
    }];
    [super updateConstraints];
}
/** @lazy doubtLabel */
- (UILabel *)doubtLabel {
    if (!_doubtLabel) {
        _doubtLabel = [[UILabel alloc] init];
        _doubtLabel.font = HDAppTheme.TinhNowFont.standard12;
        _doubtLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _doubtLabel.text = TNLocalizedString(@"b2Fxt1Ci", @"如有疑问，请联系");
        _doubtLabel.textAlignment = NSTextAlignmentCenter;
        _doubtLabel.numberOfLines = 2;
    }
    return _doubtLabel;
}
/** @lazy contactBtn */
- (HDUIButton *)contactBtn {
    if (!_contactBtn) {
        _contactBtn = [[HDUIButton alloc] init];
        [_contactBtn setTitleColor:HDAppTheme.TinhNowColor.C1 forState:UIControlStateNormal];
        _contactBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:10];
        [_contactBtn setTitle:TNLocalizedString(@"tn_platform_service", @"平台客服") forState:UIControlStateNormal];
        [_contactBtn setImage:[UIImage imageNamed:@"icon_kfdh_small"] forState:UIControlStateNormal];
        _contactBtn.spacingBetweenImageAndTitle = 5;
        _contactBtn.titleEdgeInsets = UIEdgeInsetsMake(3, 0, 3, 5);
        _contactBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 5, 3, 0);
        _contactBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4 borderWidth:0.5 borderColor:HDAppTheme.TinhNowColor.C1];
        };
        [_contactBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            TNCustomerServiceView *view = [[TNCustomerServiceView alloc] init];
            view.dataSource = [view getTinhnowDefaultPlatform];
            [view layoutyImmediately];
            TNPhoneActionAlertView *actionView = [[TNPhoneActionAlertView alloc] initWithContentView:view];
            [actionView show];
        }];
    }
    return _contactBtn;
}
@end
