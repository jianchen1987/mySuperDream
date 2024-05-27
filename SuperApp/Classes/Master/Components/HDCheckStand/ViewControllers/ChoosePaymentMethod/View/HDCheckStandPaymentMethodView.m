//
//  HDCheckStandPaymentMethodView.m
//  SuperApp
//
//  Created by seeu on 2022/5/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "HDCheckStandPaymentMethodView.h"
#import "HDOnlinePaymentToolsModel.h"
#import "SAPaymentActivityModel.h"
#import "SAPaymentToolsActivityModel.h"
#import <HDUIKit/HDFloatLayoutView.h>


@interface HDCheckStandPaymentMethodView ()
///< 容器
@property (nonatomic, strong) UIView *container;
/// logo
@property (nonatomic, strong) UIImageView *iconIV;
/// 标题
@property (nonatomic, strong) SALabel *titleLB;
///< 营销按钮
@property (nonatomic, strong) SAOperationButton *activityInfoBtn;
/// 子标题
@property (nonatomic, strong) SALabel *subTitleLB;
/// 子子标题
@property (nonatomic, strong) SALabel *subSubTitleLB;
/// 所有的描述图片
@property (nonatomic, strong) NSMutableArray *subImageViewArray;
/// 上次使用
@property (nonatomic, strong) SALabel *recentlyUsedLB;
@property (nonatomic, strong) HDFloatLayoutView *couponsContainer;  ///< 营销标签容器
@property (nonatomic, strong) NSMutableArray<UIView *> *couponTags; ///< 营销标签
////// 打勾
@property (nonatomic, strong) UIImageView *tickIV;
/// 底部线
@property (nonatomic, strong) UIView *bottomLine;
/// 白色遮罩，isShow=NO的时候展示
@property (nonatomic, strong) UIView *whiteCoverView;

@end


@implementation HDCheckStandPaymentMethodView
- (void)hd_setupViews {
    self.couponTags = [[NSMutableArray alloc] initWithCapacity:2];
    [self addSubview:self.container];
    [self.container addSubview:self.iconIV];
    [self.container addSubview:self.titleLB];
    [self.container addSubview:self.activityInfoBtn];
    [self.container addSubview:self.subTitleLB];
    [self.container addSubview:self.subSubTitleLB];
    [self.container addSubview:self.tickIV];
    [self.container addSubview:self.bottomLine];
    [self.container addSubview:self.recentlyUsedLB];
    [self.container addSubview:self.couponsContainer];
    [self.container addSubview:self.whiteCoverView];
    [self.subTitleLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.subSubTitleLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnView)];
    [self addGestureRecognizer:tap];
}

- (void)updateUI {
    if (self.model.attrText) {
        self.titleLB.attributedText = self.model.attrText;
    } else {
        self.titleLB.text = self.model.text;
        self.titleLB.textColor = self.model.textColor;
        self.titleLB.font = self.model.textFont;
    }

    @HDWeakify(self);

    if (self.model.icon) {
        [self.iconIV sd_setImageWithURL:[NSURL URLWithString:self.model.icon] placeholderImage:self.model.image
                              completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                                  if (!error) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          @HDStrongify(self);
                                          [self setNeedsUpdateConstraints];
                                      });
                                  }
                              }];
    } else {
        self.iconIV.image = self.model.image;
    }


    [self.subImageViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.subImageViewArray removeAllObjects];


    self.tickIV.hidden = NO;
    self.whiteCoverView.hidden = YES;

    if (!self.model.isShow) {
        self.tickIV.hidden = YES;
        self.recentlyUsedLB.hidden = YES;
        self.activityInfoBtn.hidden = YES;
        self.subSubTitleLB.hidden = YES;

        self.whiteCoverView.hidden = NO;

        self.subTitleLB.hidden = NO;
        self.subTitleLB.text = SALocalizedString(@"pay_tip88", @"支付通道维护中");
        if (self.model.paymentMethod == SAOrderPaymentTypeCashOnDeliveryForbidden || self.model.paymentMethod == SAOrderPaymentTypeCashOnDeliveryForbiddenByToStore) {
            self.subTitleLB.text = self.model.subTitle;
            self.tickIV.hidden = NO;
            self.tickIV.image = self.model.unselectedImage;
        }
    } else {
        //是否为钱包
        BOOL isBalance = [self.model.toolCode isEqualToString:HDCheckStandPaymentToolsBalance];
        if (isBalance) {
            self.subTitleLB.hidden = HDIsStringEmpty(self.model.subTitle) || !HDIsArrayEmpty(self.model.subImageNames);
            if (!self.subTitleLB.isHidden) {
                self.subTitleLB.text = self.model.subTitle;
                self.subTitleLB.font = self.model.subTitleFont;
            }
        } else {
            self.subTitleLB.hidden
                = (HDIsStringEmpty(self.model.subTitle) && HDIsStringEmpty(self.model.subToolName)) || !HDIsArrayEmpty(self.model.subImageNames) || HDIsStringNotEmpty(self.model.subIcon);
            if (!self.subTitleLB.isHidden) {
                if (self.model.subToolName) {
                    self.subTitleLB.text = self.model.subToolName;
                } else {
                    self.subTitleLB.text = self.model.subTitle;
                }
                self.subTitleLB.font = self.model.subTitleFont;
            }
        }

        self.subSubTitleLB.hidden = HDIsStringEmpty(self.model.subSubTitle);
        if (!self.subSubTitleLB.isHidden) {
            self.subSubTitleLB.text = self.model.subSubTitle;
            self.subSubTitleLB.font = self.model.subTitleFont;
        }

        self.tickIV.image = self.model.isSelected ? self.model.selectedImage : self.model.unselectedImage;

        if (isBalance) {
            for (NSString *imageName in self.model.subImageNames) {
                UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
                [self addSubview:imageV];
                [self.subImageViewArray addObject:imageV];
            }
        } else {
            if (self.model.subIcon) {
                UIImageView *imageV = UIImageView.new;
                [imageV sd_setImageWithURL:[NSURL URLWithString:self.model.subIcon] placeholderImage:nil
                                 completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         @HDStrongify(self);
                                         [self setNeedsUpdateConstraints];
                                     });
                                 }];
                [self addSubview:imageV];
                [self.subImageViewArray addObject:imageV];
            } else {
                for (NSString *imageName in self.model.subImageNames) {
                    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
                    [self addSubview:imageV];
                    [self.subImageViewArray addObject:imageV];
                }
            }
        }

        self.recentlyUsedLB.hidden = !self.model.isRecentlyUsed;

        self.alpha = self.model.isUsable ? 1 : 0.46;
        self.subSubTitleLB.textColor = self.subTitleLB.textColor = self.model.isUsable ? HDAppTheme.color.G3 : HDAppTheme.color.G2;

        [self.couponTags makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.couponTags removeAllObjects];

        if (!HDIsArrayEmpty(self.model.marketing)) {
            for (NSString *tag in self.model.marketing) {
                HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
                button.titleLabel.font = [UIFont systemFontOfSize:10];
                [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
                [button setTitle:tag forState:UIControlStateNormal];
                [button setTitleEdgeInsets:UIEdgeInsetsMake(kRealWidth(4), kRealWidth(5), kRealWidth(4), kRealWidth(5))];
                [button sizeToFit];
                [button setRoundedCorners:UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft radius:button.frame.size.height / 2.0];
                [button setGradualChangingColorFromColor:[UIColor hd_colorWithHexString:@"#FF8914"] toColor:[UIColor hd_colorWithHexString:@"#FD5D27"]];
                [self.couponTags addObject:button];
                [self.couponsContainer addSubview:button];
            }
        }

        if (self.model.paymentActivitys.rule.count && self.model.currentActivity) {
            // 有选中支付营销
            [self.activityInfoBtn setTitle:[NSString stringWithFormat:SALocalizedString(@"checksd_activity_full_minus", @"满%@减%@"),
                                                                      self.model.currentActivity.thresholdAmt.thousandSeparatorAmount,
                                                                      self.model.currentActivity.discountAmt.thousandSeparatorAmount]
                                  forState:UIControlStateNormal];
            if (self.model.currentActivity.fulfill == HDPaymentActivityStateAvailable) {
                [self.activityInfoBtn applyPropertiesWithBackgroundColor:HDAppTheme.color.sa_C1];
            } else {
                [self.activityInfoBtn applyPropertiesWithBackgroundColor:[UIColor hd_colorWithHexString:@"ADB6C8"]];
            }

            self.activityInfoBtn.hidden = NO;
        } else if (self.model.paymentActivitys.rule.count && !self.model.currentActivity) {
            NSArray<SAPaymentActivityModel *> *availableActivity = [self.model.paymentActivitys.rule hd_filterWithBlock:^BOOL(SAPaymentActivityModel *_Nonnull item) {
                return item.fulfill == HDPaymentActivityStateAvailable;
            }];
            if (availableActivity.count) {
                // 有活动，没有选
                [self.activityInfoBtn setTitle:SALocalizedString(@"coupon_match_DiscountUnavailable", @"不使用优惠") forState:UIControlStateNormal];
            } else {
                // 没活动
                [self.activityInfoBtn setTitle:SALocalizedString(@"coupon_match_OfferNotEligible", @"不符合优惠") forState:UIControlStateNormal];
            }

            [self.activityInfoBtn applyPropertiesWithBackgroundColor:[UIColor hd_colorWithHexString:@"#ADB6C8"]];
            self.activityInfoBtn.hidden = NO;
        } else {
            self.activityInfoBtn.hidden = YES;
        }
    }


    [self setNeedsUpdateConstraints];
}

#pragma mark - setter
- (void)setModel:(HDCheckStandPaymentMethodCellModel *)model {
    _model = model;

    [self updateUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    self.model.isSelected = selected;
    //    self.tickIV.image = self.model.isSelected ? self.model.selectedImage : self.model.unselectedImage;
    [self updateUI];
}

#pragma mark - action
- (void)clickOnView {
    !self.clickedHandler ?: self.clickedHandler(self, self.model);
}

- (void)clickOnActivityButton:(SAOperationButton *)button {
    !self.clickedActivityHandler ?: self.clickedActivityHandler(self, self.model);
}

#pragma mark - layout
- (void)updateConstraints {
    [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.mas_greaterThanOrEqualTo(kRealHeight(65));
    }];

    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.model.icon) {
            make.size.mas_equalTo(CGSizeMake(40, 40 * self.iconIV.image.size.height / self.iconIV.image.size.width));
        } else if (CGSizeEqualToSize(CGSizeZero, self.model.imageSize)) {
            make.size.mas_equalTo(self.iconIV.image.size);
        } else {
            make.size.mas_equalTo(self.model.imageSize);
        }
        make.left.equalTo(self.container.mas_left).offset(kRealWidth(10));
        if (HDIsArrayEmpty(self.couponTags)) {
            make.centerY.equalTo(self.container);
        } else {
            make.centerY.equalTo(self.titleLB.mas_bottom).offset(kRealHeight(5));
        }

        make.top.greaterThanOrEqualTo(self.container.mas_top).offset(kRealHeight(15));
        make.bottom.lessThanOrEqualTo(self.container.mas_bottom).offset(-kRealHeight(15));
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(10));
        if (self.subTitleLB.isHidden && HDIsArrayEmpty(self.subImageViewArray) && HDIsArrayEmpty(self.couponTags) && self.recentlyUsedLB.isHidden) {
            make.centerY.equalTo(self.container);
        } else {
            make.top.equalTo(self.container).offset(kRealHeight(18));
        }
    }];

    if (!self.activityInfoBtn.isHidden) {
        [self.activityInfoBtn sizeToFit];
        [self.activityInfoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLB.mas_centerY);
            make.right.equalTo(self.tickIV.mas_left).offset(-kRealWidth(HDAppTheme.value.padding.right));
        }];
    }
    if (!self.subTitleLB.isHidden) {
        //        [self.subTitleLB sizeToFit];
        [self.subTitleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLB.mas_bottom).offset(kRealHeight(6));
            make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(10));
            if (self.recentlyUsedLB.isHidden) {
                make.right.equalTo(self.container).offset(-HDAppTheme.value.padding.right);
            }
            if (HDIsArrayEmpty(self.subImageViewArray) && HDIsArrayEmpty(self.couponTags)) {
                make.bottom.lessThanOrEqualTo(self.container.mas_bottom).offset(-kRealHeight(15));
            }
        }];
    }

    if (!self.subSubTitleLB.isHidden) {
        [self.subSubTitleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.subTitleLB.mas_bottom).offset(kRealHeight(5));
            make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(10));
            if (self.recentlyUsedLB.isHidden) {
                make.right.equalTo(self.container).offset(-HDAppTheme.value.padding.right);
            }
            if (HDIsArrayEmpty(self.subImageViewArray) && HDIsArrayEmpty(self.couponTags)) {
                make.bottom.lessThanOrEqualTo(self.container.mas_bottom).offset(-kRealHeight(15));
            }
        }];
    }

    UIImageView *lastView;
    UIView *refView = self.subTitleLB.isHidden ? self.titleLB : self.subTitleLB;
    for (UIImageView *imageV in self.subImageViewArray) {
        [imageV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(refView.mas_bottom).offset(kRealHeight(5));
            if (!lastView) {
                make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(10));
            } else {
                make.left.equalTo(lastView.mas_right).offset(kRealWidth(7));
                make.centerY.equalTo(lastView);
            }
            if (imageV.image.size.height > 0) {
                make.size.mas_equalTo(CGSizeMake(15 * imageV.image.size.width / imageV.image.size.height, 15));
            } else {
                make.size.mas_equalTo(imageV.image.size);
            }
            if (HDIsArrayEmpty(self.couponTags)) {
                make.bottom.lessThanOrEqualTo(self.container.mas_bottom).offset(-kRealHeight(15));
            }
        }];
        lastView = imageV;
    }
    if (!HDIsArrayEmpty(self.couponTags)) {
        refView
            = self.subImageViewArray.count ? self.subImageViewArray.firstObject : (!self.subTitleLB.isHidden ? self.subTitleLB : (!self.recentlyUsedLB.isHidden ? self.recentlyUsedLB : self.titleLB));
        [self.couponsContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(15));
            make.bottom.lessThanOrEqualTo(self.container.mas_bottom).offset(-kRealHeight(15));
            make.top.equalTo(refView.mas_bottom).offset(kRealHeight(10));

            CGFloat placeHolderWidth = CGSizeEqualToSize(CGSizeZero, self.model.imageSize) ? self.iconIV.image.size.width : self.model.imageSize.width;
            placeHolderWidth += kRealWidth(30);
            placeHolderWidth += 5 + HDAppTheme.value.padding.right;
            make.size.mas_equalTo([self.couponsContainer sizeThatFits:CGSizeMake(self.frame.size.width - placeHolderWidth, CGFLOAT_MAX)]);
        }];
    }

    [self.tickIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.tickIV.image.size);
        make.right.equalTo(self.container).offset(-kRealWidth(10));
        make.centerY.equalTo(self.container);
    }];
    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.container);
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(15));
        make.right.equalTo(self.tickIV.mas_right);
        make.height.mas_equalTo(0.5);
    }];
    if (!self.recentlyUsedLB.isHidden) {
        UIView *leftView = !self.subTitleLB.isHidden ? self.subTitleLB : (!HDIsArrayEmpty(self.subImageViewArray) ? self.subImageViewArray.lastObject : self.iconIV);
        [self.recentlyUsedLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            if ([leftView isEqual:self.iconIV]) {
                make.top.equalTo(self.titleLB.mas_bottom).offset(kRealHeight(10));
            } else {
                make.centerY.equalTo(leftView.mas_centerY);
            }
            make.left.equalTo(leftView.mas_right).offset(kRealWidth(10));
            if (HDIsArrayEmpty(self.couponTags)) {
                make.bottom.lessThanOrEqualTo(self.container.mas_bottom).offset(-kRealHeight(15));
            }
        }];
    }

    if (!self.whiteCoverView.isHidden) {
        [self.whiteCoverView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0).insets(UIEdgeInsetsMake(0, 0, 2, 0));
        }];
    }

    [super updateConstraints];
}

#pragma mark - lazy load
/** @lazy container */
- (UIView *)container {
    if (!_container) {
        _container = [[UIView alloc] init];
    }
    return _container;
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = [UIFont systemFontOfSize:13 weight:UIFontWeightBold];
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 0;
        _titleLB = label;
    }
    return _titleLB;
}

- (SALabel *)subTitleLB {
    if (!_subTitleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard4;
        label.textColor = HDAppTheme.color.G3;
        label.numberOfLines = 0;
        _subTitleLB = label;
    }
    return _subTitleLB;
}

- (SALabel *)subSubTitleLB {
    if (!_subSubTitleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard4;
        label.textColor = HDAppTheme.color.G3;
        label.numberOfLines = 0;
        _subSubTitleLB = label;
    }
    return _subSubTitleLB;
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        UIImageView *imageView = UIImageView.new;
        _iconIV = imageView;
    }
    return _iconIV;
}

- (UIImageView *)tickIV {
    if (!_tickIV) {
        UIImageView *imageView = UIImageView.new;
        _tickIV = imageView;
    }
    return _tickIV;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = UIView.new;
        _bottomLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _bottomLine;
}

- (NSMutableArray *)subImageViewArray {
    return _subImageViewArray ?: ({ _subImageViewArray = NSMutableArray.new; });
}

- (SALabel *)recentlyUsedLB {
    if (!_recentlyUsedLB) {
        SALabel *label = SALabel.new;
        label.font = [UIFont systemFontOfSize:8 weight:UIFontWeightRegular];
        label.textColor = HDAppTheme.color.sa_C1;
        label.text = SALocalizedString(@"Ziwbr6ak", @"Recently Used");
        label.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(4), kRealWidth(7), kRealWidth(4), kRealWidth(7));
        label.layer.cornerRadius = 5;
        label.layer.borderColor = HDAppTheme.color.sa_C1.CGColor;
        label.layer.borderWidth = 1;
        _recentlyUsedLB = label;
    }
    return _recentlyUsedLB;
}

- (HDFloatLayoutView *)couponsContainer {
    if (!_couponsContainer) {
        _couponsContainer = HDFloatLayoutView.new;
        _couponsContainer.itemMargins = UIEdgeInsetsMake(0, 0, 10, 15);
        //        _couponsContainer.backgroundColor = UIColor.clearColor;
    }
    return _couponsContainer;
}

/** @lazy activiityInfoBtn */
- (SAOperationButton *)activityInfoBtn {
    if (!_activityInfoBtn) {
        _activityInfoBtn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        _activityInfoBtn.imagePosition = HDUIButtonImagePositionRight;
        _activityInfoBtn.titleLabel.font = [UIFont systemFontOfSize:9 weight:UIFontWeightMedium];
        _activityInfoBtn.titleEdgeInsets = UIEdgeInsetsMake(3.5, 5, 3.5, 0);
        _activityInfoBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        _activityInfoBtn.cornerRadius = 5.0f;
        [_activityInfoBtn setImage:[UIImage imageNamed:@"arrow_down_white"] forState:UIControlStateNormal];
        [_activityInfoBtn addTarget:self action:@selector(clickOnActivityButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _activityInfoBtn;
}

- (UIView *)whiteCoverView {
    if (!_whiteCoverView) {
        _whiteCoverView = UIView.new;
        _whiteCoverView.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.5];
        _whiteCoverView.hidden = YES;
    }
    return _whiteCoverView;
}

@end
