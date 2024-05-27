//
//  TNBargainSuccessAlertView.m
//  SuperApp
//
//  Created by 张杰 on 2021/3/1.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNBargainSuccessAlertView.h"
#import "HDAppTheme+TinhNow.h"
#import "TNCouponView.h"
#import "TNMultiLanguageManager.h"
#import <HDKitCore/HDKitCore.h>


@interface TNBargainSuccessAlertView ()
/// 图片
@property (strong, nonatomic) UIImageView *imageView;
/// 圆角背景
@property (strong, nonatomic) UIView *contentView;
/// 标题
@property (strong, nonatomic) HDLabel *titleLabel;
/// 文案
@property (strong, nonatomic) HDLabel *detailLabel;
/// 价格
@property (strong, nonatomic) HDLabel *priceLabel;
/// 按钮
@property (strong, nonatomic) HDUIButton *oprateBtn;
/// 关闭按钮
@property (strong, nonatomic) HDUIButton *closeBtn;
/// 优惠券view[item, item,...]
@property (nonatomic, strong) TNCouponView *couponView;
/// 金额
@property (nonatomic, copy) NSString *price;
/// 显示文案
@property (nonatomic, copy) NSString *showTips;
/// 优惠券数据源
@property (nonatomic, strong) NSArray<TNCouponModel *> *couponDataArray;

@end


@implementation TNBargainSuccessAlertView

+ (instancetype)alertViewWithBargainPrice:(NSString *)price showTips:(NSString *)showTips coupon:(NSArray *)couponArray {
    return [[TNBargainSuccessAlertView alloc] initWithPrice:price showTips:showTips coupon:couponArray];
}

- (instancetype)initWithPrice:(NSString *)price showTips:(NSString *)showTips coupon:(NSArray *)couponArray {
    self = [super init];
    if (self) {
        self.price = price;
        self.showTips = showTips;
        self.couponDataArray = couponArray;
        self.backgroundStyle = HDActionAlertViewBackgroundStyleSolid;
        self.transitionStyle = HDActionAlertViewTransitionStyleBounce;
    }
    return self;
}

#pragma mark - override
/// 设置containerView的布局
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
    [self.containerView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.oprateBtn];
    [self.containerView addSubview:self.closeBtn];
    self.detailLabel.text = self.showTips;

    if (HDIsStringNotEmpty(self.price)) {
        self.priceLabel.hidden = NO;
        self.priceLabel.text = [NSString stringWithFormat:@"- %@", self.price];
    } else {
        self.priceLabel.hidden = YES;
    }

    if (self.couponDataArray.count > 0) {
        [_oprateBtn setTitle:TNLocalizedString(@"tn_view_now", @"立即查看") forState:UIControlStateNormal];
        [self.contentView addSubview:self.couponView];
        self.couponView.couponArray = self.couponDataArray;
    } else {
        [_oprateBtn setTitle:TNLocalizedString(@"tn_initiate_my_help", @"发起我的助力") forState:UIControlStateNormal];
    }
}
/// 子视图布局
- (void)layoutContainerViewSubViews {
    [self.imageView sizeToFit];
    self.imageView.centerX = self.containerView.centerX;
    self.imageView.hd_top = kRealWidth(55);
    self.imageView.size = self.imageView.image.size;

    self.contentView.frame = [self getContentViewRect];

    self.titleLabel.frame = CGRectMake(10, kRealWidth(105), self.contentView.width - 20, [self getTitleLabelHeight]);
    self.detailLabel.frame = CGRectMake(10, self.titleLabel.hd_bottom + kRealWidth(10), self.contentView.width - 20, [self getDetailLabelHeight]);

    CGFloat oprateBtnY = 0;
    if (self.couponDataArray.count > 0) {
        self.priceLabel.frame = CGRectMake(10, self.detailLabel.hd_bottom + kRealWidth(5), self.contentView.width - 20, [self getPriceLabelHeight]);
        CGFloat couponViewY = self.priceLabel.text.length > 0 ? self.priceLabel.hd_bottom : self.detailLabel.hd_bottom;
        self.couponView.frame = CGRectMake(10.f, couponViewY + kRealWidth(10.f), self.contentView.width - 20, 0);
        [self.couponView setNeedsLayout];
        [self.couponView layoutIfNeeded];
        oprateBtnY = self.couponView.hd_bottom;
    } else {
        self.priceLabel.frame = CGRectMake(10, self.detailLabel.hd_bottom + kRealWidth(20), self.contentView.width - 20, [self getPriceLabelHeight]);
        oprateBtnY = self.priceLabel.hd_bottom;
    }

    self.oprateBtn.frame = CGRectMake(kRealWidth(27), oprateBtnY + kRealWidth(20), self.contentView.width - kRealWidth(27) * 2, kRealWidth(40));

    self.contentView.frame = [self getContentViewRect];

    [self.closeBtn sizeToFit];
    self.closeBtn.centerX = self.containerView.centerX;
    self.closeBtn.hd_top = self.contentView.hd_bottom + kRealWidth(30);
    self.closeBtn.size = self.closeBtn.imageView.image.size;
}
- (CGRect)getContentViewRect {
    CGFloat x = kRealWidth(35);
    CGFloat y = self.imageView.hd_bottom - kRealWidth(90);
    CGFloat contentWidth = self.containerView.width - kRealWidth(35) * 2;
    //
    CGFloat contentHeight = kRealWidth(90);
    //标题间距
    contentHeight += kRealWidth(15);
    //标题高度
    contentHeight += [self getTitleLabelHeight];
    //标题和详情文字间距
    contentHeight += kRealWidth(10);
    //详情文字
    contentHeight += [self getDetailLabelHeight];

    //优惠券
    if (self.couponDataArray.count > 0) {
        if (self.priceLabel.text.length > 0) {
            //详情文字到金额
            contentHeight += kRealWidth(5.f);
            //金额高度
            contentHeight += [self getPriceLabelHeight];
        }
        //到优惠券高度
        contentHeight += kRealWidth(10);
        //优惠券高度
        contentHeight += self.couponView.maxY;
    } else {
        //详情文字到金额
        contentHeight += kRealWidth(20);
        //金额高度
        contentHeight += [self getPriceLabelHeight];
    }
    //到按钮
    contentHeight += kRealWidth(20);
    //按钮
    contentHeight += kRealWidth(40);
    //底部
    contentHeight += kRealWidth(20);
    return CGRectMake(x, y, contentWidth, contentHeight);
}
- (CGFloat)getTitleLabelHeight {
    if (self.couponDataArray.count > 0) {
        self.titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15.f];
    } else {
        self.titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:20.f];
    }
    return [@"" boundingAllRectWithSize:CGSizeMake(self.contentView.width, MAXFLOAT) font:self.titleLabel.font].height;
}
- (CGFloat)getDetailLabelHeight {
    if (self.couponDataArray.count > 0) {
        self.detailLabel.font = [HDAppTheme.TinhNowFont fontRegular:12.f];
    } else {
        self.detailLabel.font = [HDAppTheme.TinhNowFont fontRegular:14.f];
    }
    return [TNLocalizedString(@"tn_thank_for_help", @"太感谢你了，帮我砍价") boundingAllRectWithSize:CGSizeMake(self.contentView.width, MAXFLOAT) font:self.detailLabel.font].height;
}
- (CGFloat)getPriceLabelHeight {
    if (self.couponDataArray.count > 0) {
        self.priceLabel.font = [HDAppTheme.TinhNowFont fontSemibold:14.f];
    } else {
        self.priceLabel.font = [HDAppTheme.TinhNowFont fontSemibold:20];
    }
    return [@"" boundingAllRectWithSize:CGSizeMake(self.contentView.width, MAXFLOAT) font:self.priceLabel.font].height;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor hd_colorWithHexString:@"#FFFBF0"];
        _contentView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:15];
        };
    }
    return _contentView;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tinhnow_bargain_success"]];
    }
    return _imageView;
}
/** @lazy titleLabel */
- (HDLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[HDLabel alloc] init];
        _titleLabel.font = HDAppTheme.TinhNowFont.standard20;
        _titleLabel.textColor = [UIColor hd_colorWithHexString:@"#454545"];
        _titleLabel.text = TNLocalizedString(@"tn_bargain_success", @"助力成功");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (HDLabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[HDLabel alloc] init];
        _detailLabel.font = HDAppTheme.TinhNowFont.standard16;
        _detailLabel.textColor = [UIColor hd_colorWithHexString:@"#454545"];

        _detailLabel.numberOfLines = 2;
        _detailLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _detailLabel;
}
- (HDLabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[HDLabel alloc] init];
        _priceLabel.font = [HDAppTheme.TinhNowFont fontSemibold:24];
        _priceLabel.textColor = [UIColor hd_colorWithHexString:@"#F24F4F"];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _priceLabel;
}
/** @lazy oprateBtn */
- (HDUIButton *)oprateBtn {
    if (!_oprateBtn) {
        _oprateBtn = [[HDUIButton alloc] init];
        [_oprateBtn setTitle:TNLocalizedString(@"tn_initiate_my_help", @"发起我的助力") forState:UIControlStateNormal];

        _oprateBtn.titleLabel.font = HDAppTheme.TinhNowFont.standard16;
        [_oprateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _oprateBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:23];
            [view setGradualChangingColorFromColor:[UIColor hd_colorWithHexString:@"#FD2C3A"] toColor:[UIColor hd_colorWithHexString:@"#FD8653"]];
        };
        @HDWeakify(self);
        [_oprateBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.couponDataArray.count > 0) {
                if (self.viewNowCouponListClick) {
                    self.viewNowCouponListClick();
                }
            } else {
                if (self.beginMyBargainClick) {
                    self.beginMyBargainClick();
                }
            }

            [self dismiss];
        }];
    }
    return _oprateBtn;
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

- (TNCouponView *)couponView {
    if (!_couponView) {
        _couponView = [[TNCouponView alloc] initWithFrame:CGRectZero];
    }
    return _couponView;
}
@end
