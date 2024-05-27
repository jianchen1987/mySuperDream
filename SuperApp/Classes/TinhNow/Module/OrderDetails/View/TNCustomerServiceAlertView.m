//
//  TNCustomerServiceAlertView.m
//  SuperApp
//
//  Created by 张杰 on 2021/4/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCustomerServiceAlertView.h"
#import "HDAppTheme+TinhNow.h"
#import <Masonry/Masonry.h>
#import <HDKitCore/HDKitCore.h>
#import "TNMultiLanguageManager.h"
#import "TNIMManger.h"


@interface TNCustomerServiceAlertView ()
/// 圆角背景
@property (strong, nonatomic) UIView *contentView;
/// 关闭按钮
@property (strong, nonatomic) HDUIButton *closeBtn;
/// 标题
@property (strong, nonatomic) HDLabel *contentLB;
/// 联系商家
@property (nonatomic, strong) HDUIButton *customerServiceBtn;
/// 文本内容
@property (nonatomic, copy) NSString *contentText;
/// 订单id
@property (nonatomic, copy) NSString *orderNo;
/// 店铺id
@property (nonatomic, copy) NSString *storeNo;
@end


@implementation TNCustomerServiceAlertView
+ (instancetype)alertViewWithContentText:(NSString *)content storeNo:(NSString *)storeNo orderNo:(NSString *)orderNo {
    return [[TNCustomerServiceAlertView alloc] initWithContentText:content storeNo:storeNo orderNo:orderNo];
}

- (instancetype)initWithContentText:(NSString *)content storeNo:(NSString *)storeNo orderNo:(NSString *)orderNo {
    self = [super init];
    if (self) {
        self.contentText = content;
        self.orderNo = orderNo;
        self.storeNo = storeNo;
        self.backgroundStyle = HDActionAlertViewBackgroundStyleSolid;
        self.transitionStyle = HDActionAlertViewTransitionStyleBounce;
        self.allowTapBackgroundDismiss = YES;
    }
    return self;
}
- (void)layoutContainerView {
    self.containerView.frame = [UIScreen mainScreen].bounds;
}
/// 设置containerview的属性,比如切边啥的
- (void)setupContainerViewAttributes {
    self.containerView.backgroundColor = [UIColor clearColor];
    self.containerView.layer.masksToBounds = YES;
}
/// 给containerview添加子视图
- (void)setupContainerSubViews {
    [self.containerView addSubview:self.contentView];
    [self.contentView addSubview:self.contentLB];
    [self.containerView addSubview:self.closeBtn];
    [self.contentView addSubview:self.customerServiceBtn];
    self.contentLB.text = self.contentText;
}
/// 子视图布局
- (void)layoutContainerViewSubViews {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.containerView.mas_centerX);
        make.centerY.mas_equalTo(self.containerView.mas_centerY).offset(-kRealWidth(30));
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(35));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(35));
    }];
    [self.contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(30));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(35));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(35));
    }];
    [self.customerServiceBtn sizeToFit];
    [self.customerServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentLB.mas_bottom).offset(kRealWidth(30));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(30));
    }];

    [self.closeBtn sizeToFit];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.top.equalTo(self.contentView.mas_bottom).offset(kRealWidth(20));
    }];
}

/** @lazy contentLB */
- (HDLabel *)contentLB {
    if (!_contentLB) {
        _contentLB = [[HDLabel alloc] init];
        _contentLB.font = HDAppTheme.TinhNowFont.standard14;
        _contentLB.textColor = HDAppTheme.TinhNowColor.G1;
        _contentLB.textAlignment = NSTextAlignmentCenter;
        _contentLB.numberOfLines = 0;
        _contentLB.hd_lineSpace = 3;
    }
    return _contentLB;
}
/** @lazy closeBtn */
- (HDUIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"tinhnow_bargain_close"] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_closeBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
        }];
    }
    return _closeBtn;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor hd_colorWithHexString:@"#FFFFFF"];
        _contentView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:10];
        };
    }
    return _contentView;
}
- (HDUIButton *)customerServiceBtn {
    if (!_customerServiceBtn) {
        _customerServiceBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_customerServiceBtn setTitleColor:HDAppTheme.TinhNowColor.cFF8824 forState:UIControlStateNormal];
        [_customerServiceBtn setImage:[UIImage imageNamed:@"tn_orderdetail_customer"] forState:0];
        _customerServiceBtn.adjustsButtonWhenHighlighted = false;
        _customerServiceBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        [_customerServiceBtn setTitle:TNLocalizedString(@"tn_order_details_cusomter", @"商家客服") forState:0];
        [_customerServiceBtn setImagePosition:HDUIButtonImagePositionLeft];
        _customerServiceBtn.spacingBetweenImageAndTitle = 5;
        _customerServiceBtn.layer.borderWidth = PixelOne;
        _customerServiceBtn.layer.borderColor = HDAppTheme.TinhNowColor.cFF8824.CGColor;
        _customerServiceBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 10, 8, 0);
        _customerServiceBtn.titleEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 12);
        @HDWeakify(self);
        [_customerServiceBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismissCompletion:^{
                [[TNIMManger shared] openCustomerServiceChatWithStoreNo:self.storeNo orderNo:self.orderNo];
            }];
        }];
        _customerServiceBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = precedingFrame.size.height * 0.5f;
        };
    }
    return _customerServiceBtn;
}
@end
