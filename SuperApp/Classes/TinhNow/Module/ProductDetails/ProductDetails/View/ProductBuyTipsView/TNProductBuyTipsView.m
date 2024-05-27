//
//  TNProductBuyTipsView.m
//  SuperApp
//
//  Created by 张杰 on 2021/6/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNProductBuyTipsView.h"
#import <Masonry.h>
#import "SAOperationButton.h"
#import "TNMultiLanguageManager.h"
#import "HDAppTheme+TinhNow.h"
#import <HDKitCore.h>
#import "TNIMManger.h"
#import <MessageUI/MessageUI.h>
#import "NSString+extend.h"


@interface TNProductBuyTipsView () <MFMessageComposeViewControllerDelegate>
/// 标题
@property (strong, nonatomic) HDLabel *titleLabel;
/// 关闭按钮
@property (nonatomic, strong) HDUIButton *closeBTN;
/// 文本展示
@property (strong, nonatomic) UITextView *tipsTextView;
/// 联系商家
@property (strong, nonatomic) HDLabel *contactLabel;
/// 添加购物车按钮
@property (nonatomic, strong) SAOperationButton *doneBtn;
/// 客服
@property (nonatomic, strong) HDUIButton *customerServiceBtn;
/// 电话
@property (nonatomic, strong) HDUIButton *phoneBtn;
/// SMS
@property (nonatomic, strong) HDUIButton *smsBtn;
/// 购买类型   0立即购买   1加入购物车
@property (nonatomic, assign) TNProductBuyType buyType;
/// 店铺id
@property (nonatomic, copy) NSString *storeNo;
/// 提示文案
@property (nonatomic, copy) NSString *tips;
/// 店铺电话
@property (nonatomic, copy) NSString *storePhone;
/// 客服卡片标题
@property (nonatomic, copy) NSString *title;
/// 客服卡片内容
@property (nonatomic, copy) NSString *content;
/// 客服卡片图片
@property (nonatomic, copy) NSString *image;

@end


@implementation TNProductBuyTipsView
- (instancetype)initTipsType:(TNProductBuyType)buyType
                     storeNo:(NSString *)storeNo
                  storePhone:(NSString *)storePhone
                        tips:(nonnull NSString *)tips
                       title:(nonnull NSString *)title
                     content:(nonnull NSString *)content
                       image:(nonnull NSString *)image {
    if (self = [super init]) {
        self.buyType = buyType;
        self.storeNo = storeNo;
        self.tips = tips;
        self.storePhone = storePhone;
        self.title = title;
        self.content = content;
        self.image = image;
        self.transitionStyle = HDActionAlertViewTransitionStyleSlideFromBottom;
    }
    return self;
}
#pragma mark - HDActionAlertViewOverridable
- (void)layoutContainerView {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
    }];
}
- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.layer.masksToBounds = YES;
    self.allowTapBackgroundDismiss = YES;
}

- (void)setupContainerSubViews {
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.closeBTN];
    [self.containerView addSubview:self.tipsTextView];
    [self.containerView addSubview:self.contactLabel];
    [self.containerView addSubview:self.customerServiceBtn];
    [self.containerView addSubview:self.phoneBtn];
    [self.containerView addSubview:self.smsBtn];
    [self.containerView addSubview:self.doneBtn];
}

- (void)layoutContainerViewSubViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.containerView.mas_top).offset(kRealWidth(20));
    }];
    [self.closeBTN sizeToFit];
    [self.closeBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(15));
    }];
    CGFloat height = [self.tipsTextView systemLayoutSizeFittingSize:CGSizeMake(kScreenWidth - kRealWidth(30), MAXFLOAT)].height;
    if (height > kScreenHeight * 0.5) {
        height = kScreenHeight * 0.5;
        self.tipsTextView.scrollEnabled = YES;
    }
    [self.tipsTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(15));
        make.height.mas_equalTo(height);
    }];
    [self.contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.tipsTextView.mas_bottom).offset(kRealWidth(30));
    }];

    [self.customerServiceBtn sizeToFit];
    [self.customerServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.contactLabel.mas_bottom).offset(kRealWidth(15));
    }];
    [self.phoneBtn sizeToFit];
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.customerServiceBtn.mas_right).offset(kRealWidth(55));
        make.centerY.equalTo(self.customerServiceBtn.mas_centerY);
    }];
    [self.smsBtn sizeToFit];
    [self.smsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneBtn.mas_right).offset(kRealWidth(55));
        make.centerY.equalTo(self.customerServiceBtn.mas_centerY);
    }];

    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.top.equalTo(self.customerServiceBtn.mas_bottom).offset(kRealWidth(20));
        make.bottom.mas_equalTo(self.containerView.mas_bottom).offset(-kiPhoneXSeriesSafeBottomHeight);
        make.height.mas_equalTo(50);
    }];
}
// MFMessageComposeViewController delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    if (result == MessageComposeResultCancelled) {
        HDLog(@"取消发送");
    } else if (result == MessageComposeResultSent) {
        HDLog(@"发送成功");
    } else if (result == MessageComposeResultFailed) {
        HDLog(@"发送失败");
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}
/** @lazy titleLabel */
- (HDLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[HDLabel alloc] init];
        _titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLabel.text = TNLocalizedString(@"WVn2QhqF", @"下单提示");
    }
    return _titleLabel;
}
/** @lazy tipsTextView */
- (UITextView *)tipsTextView {
    if (!_tipsTextView) {
        _tipsTextView = [[UITextView alloc] init];
        _tipsTextView.textColor = HDAppTheme.TinhNowColor.G1;
        _tipsTextView.font = HDAppTheme.TinhNowFont.standard12;
        _tipsTextView.editable = NO;
        _tipsTextView.scrollEnabled = NO;
        _tipsTextView.textContainerInset = UIEdgeInsetsMake(0, -4, 0, -4);
        NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
        style.lineSpacing = 2;
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.tips];
        [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, self.tips.length)];
        _tipsTextView.attributedText = attrString;
    }
    return _tipsTextView;
}
/** @lazy contactLabel */
- (HDLabel *)contactLabel {
    if (!_contactLabel) {
        _contactLabel = [[HDLabel alloc] init];
        _contactLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15];
        _contactLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _contactLabel.text = TNLocalizedString(@"tn_contact", @"联系商家");
    }
    return _contactLabel;
}
/** @lazy customerServiceBtn */
- (HDUIButton *)customerServiceBtn {
    if (!_customerServiceBtn) {
        _customerServiceBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_customerServiceBtn setImagePosition:HDUIButtonImagePositionTop];
        [_customerServiceBtn setImage:[UIImage imageNamed:@"tinhnow_product_customer"] forState:UIControlStateNormal];
        [_customerServiceBtn setTitle:TNLocalizedString(@"tn_product_customer", @"Customer") forState:UIControlStateNormal];
        _customerServiceBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontRegular:11.f];
        [_customerServiceBtn setTitleColor:HDAppTheme.TinhNowColor.G2 forState:UIControlStateNormal];
        @HDWeakify(self);
        [_customerServiceBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
            [[TNIMManger shared] openCustomerServiceChatWithStoreNo:self.storeNo title:self.title content:self.content image:self.image];
        }];
    }
    return _customerServiceBtn;
}

/** @lazy phoneBtn */
- (HDUIButton *)phoneBtn {
    if (!_phoneBtn) {
        _phoneBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_phoneBtn setImagePosition:HDUIButtonImagePositionTop];
        [_phoneBtn setImage:[UIImage imageNamed:@"tinhnow_product_phone"] forState:UIControlStateNormal];
        [_phoneBtn setTitle:TNLocalizedString(@"tn_product_phone", @"电话") forState:UIControlStateNormal];
        _phoneBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontRegular:11.f];
        [_phoneBtn setTitleColor:HDAppTheme.TinhNowColor.G2 forState:UIControlStateNormal];
        @HDWeakify(self);
        [_phoneBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [HDSystemCapabilityUtil makePhoneCall:self.storePhone];
        }];
    }
    return _phoneBtn;
}

/** @lazy smsBtn */
- (HDUIButton *)smsBtn {
    if (!_smsBtn) {
        _smsBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_smsBtn setImagePosition:HDUIButtonImagePositionTop];
        [_smsBtn setImage:[UIImage imageNamed:@"tinhnow_product_sms"] forState:UIControlStateNormal];
        [_smsBtn setTitle:TNLocalizedString(@"tn_product_sms", @"SMS") forState:UIControlStateNormal];
        _smsBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontRegular:11.f];
        [_smsBtn setTitleColor:HDAppTheme.TinhNowColor.G2 forState:UIControlStateNormal];
        @HDWeakify(self);
        [_smsBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if ([MFMessageComposeViewController canSendText]) {
                MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
                controller.recipients = @[[self.storePhone filterCambodiaPhoneNum]];
                controller.messageComposeDelegate = self;
                [self.viewController presentViewController:controller animated:YES completion:nil];
            } else {
                [NAT showToastWithTitle:nil content:TNLocalizedString(@"tn_no_authority", @"权限不足") type:HDTopToastTypeError];
            }
        }];
    }
    return _smsBtn;
}
- (SAOperationButton *)doneBtn {
    if (!_doneBtn) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        button.cornerRadius = 0;
        button.titleEdgeInsets = UIEdgeInsetsMake(10, 30, 10, 30);
        button.titleLabel.font = HDAppTheme.TinhNowFont.standard17B;
        [button applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.C1];
        if (self.buyType == TNProductBuyTypeBuyNow) {
            [button setTitle:TNLocalizedString(@"EWA9zDhA", @"知道了，继续购买") forState:UIControlStateNormal];
        } else if (self.buyType == TNProductBuyTypeAddCart) {
            [button setTitle:TNLocalizedString(@"71fwXO9v", @"知道了，加入购物车") forState:UIControlStateNormal];
        }
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.doneClickCallBack) {
                self.doneClickCallBack();
            }
            [self dismiss];
        }];
        _doneBtn = button;
    }
    return _doneBtn;
}
- (HDUIButton *)closeBTN {
    if (!_closeBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
        }];
        _closeBTN = button;
    }
    return _closeBTN;
}
@end
