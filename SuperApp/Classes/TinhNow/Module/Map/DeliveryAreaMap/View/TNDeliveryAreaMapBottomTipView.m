//
//  TNDeliveryAreaMapBottomTipView.m
//  SuperApp
//
//  Created by 张杰 on 2021/9/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNDeliveryAreaMapBottomTipView.h"
#import "TNDeliveryAreaMapModel.h"
#import "TNLeftCircleImageButton.h"


@interface TNMapStoreTagItemView : TNView
/// 颜色视图
@property (strong, nonatomic) UIView *colorView;
/// 名称
@property (strong, nonatomic) UILabel *nameLabel;
///
@property (strong, nonatomic) TNDeliveryAreaStoreInfoModel *infoModel;
///
@property (strong, nonatomic) CAShapeLayer *cornerLayer;
/// 点击回调
@property (nonatomic, copy) void (^storeTagClickCallBack)(TNDeliveryAreaStoreInfoModel *model);
//宽高
- (CGSize)getSizeFits;
/// 还原原始状态
- (void)resetDefaultState;
/// 设置选中状态
- (void)setSelectededState;
@end


@implementation TNMapStoreTagItemView
- (void)hd_setupViews {
    [self addSubview:self.colorView];
    [self addSubview:self.nameLabel];
    @HDWeakify(self);
    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        @HDStrongify(self);
        if (!self.cornerLayer) {
            UIColor *color;
            if (HDIsStringNotEmpty(self.infoModel.color) && self.infoModel.isSelected) {
                color = [[UIColor hd_colorWithHexString:self.infoModel.color] colorWithAlphaComponent:0.7];
            } else {
                color = HDAppTheme.TinhNowColor.cD6DBE8;
            }
            self.cornerLayer = [view setRoundedCorners:UIRectCornerAllCorners radius:0 borderWidth:1 borderColor:color];
        }
    };
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storeTagClick)];
    [self addGestureRecognizer:tap];
}
- (void)storeTagClick {
    !self.storeTagClickCallBack ?: self.storeTagClickCallBack(self.infoModel);
}
- (void)setInfoModel:(TNDeliveryAreaStoreInfoModel *)infoModel {
    _infoModel = infoModel;
    self.nameLabel.text = infoModel.storeName;
    [self setNeedsUpdateConstraints];
    if (infoModel.isSelected) {
        [self setSelectededState];
    } else {
        [self resetDefaultState];
    }
}
- (CGSize)getSizeFits {
    [self layoutIfNeeded];
    CGFloat height = kRealHeight(12);
    CGFloat textWidth = [self.nameLabel.text boundingAllRectWithSize:CGSizeMake(kScreenWidth - kRealWidth(15) * 2, height) font:self.nameLabel.font].width;
    CGFloat width = textWidth + kRealWidth(20) + kRealWidth(15);
    return CGSizeMake(width, height + kRealHeight(14));
}
- (void)setSelectededState {
    self.infoModel.isSelected = YES;
    UIColor *color;
    if (HDIsStringNotEmpty(self.infoModel.color)) {
        color = [[UIColor hd_colorWithHexString:self.infoModel.color] colorWithAlphaComponent:0.7];
    } else {
        color = [HDAppTheme.TinhNowColor.C1 colorWithAlphaComponent:0.7];
    }
    self.colorView.backgroundColor = color;
    self.cornerLayer.strokeColor = color.CGColor;
    self.nameLabel.textColor = color;
}
- (void)resetDefaultState {
    self.infoModel.isSelected = NO;
    UIColor *color;
    if (HDIsStringNotEmpty(self.infoModel.color)) {
        color = [UIColor hd_colorWithHexString:self.infoModel.color];
    } else {
        color = HDAppTheme.TinhNowColor.C1;
    }
    self.colorView.backgroundColor = [color colorWithAlphaComponent:0.3];
    self.cornerLayer.strokeColor = HDAppTheme.TinhNowColor.cD6DBE8.CGColor;
    self.nameLabel.textColor = HDAppTheme.TinhNowColor.G1;
}
- (CGSize)sizeThatFits:(CGSize)size {
    return [self getSizeFits];
}
- (void)updateConstraints {
    [self.colorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(5));
        make.top.equalTo(self.mas_top).offset(kRealHeight(7));
        make.bottom.equalTo(self.mas_bottom).offset(-kRealHeight(7));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(20), kRealHeight(12)));
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.colorView.mas_right).offset(kRealWidth(5));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(5));
    }];
    [super updateConstraints];
}
/** @lazy colorView */
- (UIView *)colorView {
    if (!_colorView) {
        _colorView = [[UIView alloc] init];
    }
    return _colorView;
}
/** @lazy nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [HDAppTheme.TinhNowFont fontRegular:10];
        _nameLabel.textColor = HDAppTheme.TinhNowColor.G1;
    }
    return _nameLabel;
}
@end


@interface TNDeliveryAreaMapBottomTipView ()
/// 店铺标签容器
@property (strong, nonatomic) UIView *tagContainer;
/// 标题
@property (strong, nonatomic) UILabel *areaTitleLabel;
/// 标题提示标题
@property (strong, nonatomic) UILabel *areaTipsLabel;
/// 标签背景色
@property (strong, nonatomic) HDFloatLayoutView *floatLayoutView;
/// 标签流真实高度
@property (nonatomic, assign) CGFloat floatLayoutViewRealHeight;
/// 展开按钮
@property (strong, nonatomic) HDUIButton *expandBtn;
/// 收货地址图片
@property (strong, nonatomic) UIImageView *adressImageView;
/// 收货地址
@property (strong, nonatomic) UILabel *adressLabel;
/// 提示文本
@property (strong, nonatomic) UILabel *tipsLabel;
/// 查看专题按钮
@property (strong, nonatomic) HDUIButton *activityBtn;
/// 地址按钮
@property (strong, nonatomic) HDUIButton *adressBtn;

@end


@implementation TNDeliveryAreaMapBottomTipView
- (void)hd_setupViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.adressImageView];
    [self addSubview:self.adressLabel];
    [self addSubview:self.tipsLabel];
    [self addSubview:self.activityBtn];
    [self addSubview:self.adressBtn];
    [self addSubview:self.tagContainer];
    [self.tagContainer addSubview:self.areaTitleLabel];
    [self.tagContainer addSubview:self.areaTipsLabel];
    [self.tagContainer addSubview:self.floatLayoutView];
    [self.tagContainer addSubview:self.expandBtn];
    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:10];
    };
}
- (void)setModel:(TNDeliveryAreaMapModel *)model {
    _model = model;
    [self layoutIfNeeded];
    [self setNeedsUpdateConstraints];
    if (!HDIsArrayEmpty(model.storeInfoDTOList)) {
        self.tagContainer.hidden = NO;
        self.floatLayoutView.maxRowCount = 1;
        [self addTagItemViews];
        NSInteger count = [self.floatLayoutView fowardingTotalRowCountWithMaxSize:CGSizeMake(kScreenWidth - kRealWidth(15) * 2, CGFLOAT_MAX)];
        self.expandBtn.hidden = count <= 1;
        [self setNeedsUpdateConstraints];
    }
}
- (void)updateStoreTagSelected {
    [self addTagItemViews];
}
- (void)addTagItemViews {
    [self.floatLayoutView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (TNDeliveryAreaStoreInfoModel *infoModel in self.model.storeInfoDTOList) {
        TNMapStoreTagItemView *itemView = [[TNMapStoreTagItemView alloc] init];
        itemView.infoModel = infoModel;
        itemView.size = [itemView getSizeFits];
        @HDWeakify(self);
        itemView.storeTagClickCallBack = ^(TNDeliveryAreaStoreInfoModel *infoModel) {
            @HDStrongify(self);
            for (UIView *subView in self.floatLayoutView.subviews) {
                if ([subView isKindOfClass:[TNMapStoreTagItemView class]]) {
                    TNMapStoreTagItemView *targetView = (TNMapStoreTagItemView *)subView;
                    if ([targetView.infoModel.specialId isEqualToString:infoModel.specialId]) {
                        [targetView setSelectededState];
                    } else {
                        [targetView resetDefaultState];
                    }
                }
            }
            !self.storeTagClickCallBack ?: self.storeTagClickCallBack(infoModel);
        };
        [self.floatLayoutView addSubview:itemView];
    }
}
- (void)setAdressName:(NSString *)adressName {
    _adressName = adressName;
    if (HDIsStringNotEmpty(adressName)) {
        self.adressLabel.hidden = NO;
        self.adressImageView.hidden = NO;
        self.adressLabel.text = [NSString stringWithFormat:@"%@：%@", TNLocalizedString(@"tn_page_deliveryto_title", @"收货地址"), self.adressName];
    } else {
        self.adressLabel.hidden = YES;
        self.adressImageView.hidden = YES;
    }
    [self setNeedsUpdateConstraints];
}
- (void)setTips:(NSString *)tips {
    _tips = tips;
    if (HDIsStringNotEmpty(tips)) {
        self.tipsLabel.hidden = NO;
        self.tipsLabel.text = tips;
    } else {
        self.tipsLabel.hidden = YES;
    }
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    UIView *lastView;
    if (!self.tagContainer.isHidden) {
        [self.tagContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(kRealWidth(10));
            make.left.equalTo(self.mas_left).offset(kRealWidth(15));
            make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
        }];
        [self.areaTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.tagContainer);
        }];
        [self.areaTipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.tagContainer);
            make.top.equalTo(self.areaTitleLabel.mas_bottom).offset(kRealWidth(5));
        }];
        CGFloat width = kScreenWidth - kRealWidth(15) * 2;

        [self.floatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tagContainer);
            make.top.equalTo(self.areaTipsLabel.mas_bottom).offset(kRealWidth(15));
            CGSize size = [self.floatLayoutView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
            make.size.mas_equalTo(size);
            if (self.expandBtn.isHidden) {
                make.bottom.equalTo(self.tagContainer.mas_bottom).offset(-kRealWidth(10));
            }
        }];
        if (!self.expandBtn.isHidden) {
            [self.expandBtn sizeToFit];
            [self.expandBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.tagContainer);
                make.top.equalTo(self.floatLayoutView.mas_bottom).offset(kRealWidth(15));
                make.bottom.equalTo(self.tagContainer.mas_bottom).offset(-kRealWidth(10));
                make.height.mas_equalTo(kRealWidth(20));
            }];
        }
        lastView = self.tagContainer;
    }

    if (!self.adressLabel.isHidden) {
        [self.adressImageView sizeToFit];
        [self.adressImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!self.tagContainer.isHidden) {
                make.top.equalTo(self.tagContainer.mas_bottom).offset(kRealWidth(15));
            } else {
                make.top.equalTo(self.mas_top).offset(kRealWidth(20));
            }
            make.left.equalTo(self.mas_left).offset(kRealWidth(15));
            make.size.mas_equalTo(self.adressImageView.image.size);
        }];
        [self.adressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.adressImageView.mas_right).offset(kRealWidth(5));
            make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
            if (!self.tagContainer.isHidden) {
                make.top.equalTo(self.tagContainer.mas_bottom).offset(kRealWidth(16));
            } else {
                make.top.equalTo(self.mas_top).offset(kRealWidth(21));
            }
        }];

        [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.adressImageView.mas_leading);
            make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
            make.top.equalTo(self.adressLabel.mas_bottom).offset(kRealWidth(10));
            if (self.activityBtn.isHidden) {
                make.bottom.equalTo(self.mas_bottom).offset(-kRealWidth(20 + kiPhoneXSeriesSafeBottomHeight));
            }
        }];

        lastView = self.tipsLabel;
    }

    [self.activityBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(15));
        if (lastView) {
            make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(20));
        } else {
            make.top.equalTo(self.mas_top).offset(kRealWidth(20));
        }
        make.right.equalTo(self.adressBtn.mas_left).offset(-kRealWidth(30));
        make.width.equalTo(self.adressBtn.mas_width);
        make.height.mas_equalTo(kRealWidth(58));
        make.bottom.equalTo(self.mas_bottom).offset(-kRealWidth(20 + kiPhoneXSeriesSafeBottomHeight));
    }];
    [self.adressBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.activityBtn);
        make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
        make.height.mas_equalTo(kRealWidth(58));
    }];
    [super updateConstraints];
}
/** @lazy adressImageView */
- (UIImageView *)adressImageView {
    if (!_adressImageView) {
        _adressImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_receipt_adress"]];
    }
    return _adressImageView;
}
/** @lazy adressLabel */
- (UILabel *)adressLabel {
    if (!_adressLabel) {
        _adressLabel = [[UILabel alloc] init];
        _adressLabel.numberOfLines = 0;
        _adressLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _adressLabel.font = HDAppTheme.TinhNowFont.standard12;
    }
    return _adressLabel;
}
/** @lazy tipsLabel */
- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _tipsLabel.font = HDAppTheme.TinhNowFont.standard12;
        _tipsLabel.hidden = YES;
    }
    return _tipsLabel;
}

/** @lazy activityBtn */
- (HDUIButton *)activityBtn {
    if (!_activityBtn) {
        _activityBtn = [[HDUIButton alloc] init];
        _activityBtn.imagePosition = HDUIButtonImagePositionTop;
        _activityBtn.spacingBetweenImageAndTitle = 5;
        _activityBtn.titleLabel.numberOfLines = 2;
        _activityBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_activityBtn setTitle:TNLocalizedString(@"IvMdlQpA", @"进入店铺") forState:UIControlStateNormal];
        [_activityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _activityBtn.backgroundColor = HDAppTheme.TinhNowColor.C1;
        _activityBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        _activityBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
        @HDWeakify(self);
        [_activityBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.activityClickCallBack ?: self.activityClickCallBack();
        }];
    }
    return _activityBtn;
}

/** @lazy adressBtn */
- (HDUIButton *)adressBtn {
    if (!_adressBtn) {
        _adressBtn = [[HDUIButton alloc] init];
        _adressBtn.imagePosition = HDUIButtonImagePositionTop;
        _adressBtn.titleLabel.numberOfLines = 2;
        _adressBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _adressBtn.spacingBetweenImageAndTitle = 5;
        [_adressBtn setTitle:TNLocalizedString(@"lps6Jl61", @"选择收货地址") forState:UIControlStateNormal];
        [_adressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _adressBtn.backgroundColor = HDAppTheme.TinhNowColor.cFF2323;
        _adressBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        _adressBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
        @HDWeakify(self);
        [_adressBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.adressClickCallBack ?: self.adressClickCallBack();
        }];
    }
    return _adressBtn;
}

/** @lazy tagContainer */
- (UIView *)tagContainer {
    if (!_tagContainer) {
        _tagContainer = [[UIView alloc] init];
        _tagContainer.hd_borderPosition = HDViewBorderPositionBottom;
        _tagContainer.hd_borderWidth = 0.5;
        _tagContainer.hd_borderColor = HexColor(0xD6DBE8);
        _tagContainer.hidden = YES;
    }
    return _tagContainer;
}
/** @lazy areaTitleLabel */
- (UILabel *)areaTitleLabel {
    if (!_areaTitleLabel) {
        _areaTitleLabel = [[UILabel alloc] init];
        _areaTitleLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        _areaTitleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _areaTitleLabel.text = TNLocalizedString(@"tn_color_to_area", @"颜色对应的配送范围");
    }
    return _areaTitleLabel;
}
#pragma mark - lazy load
- (HDFloatLayoutView *)floatLayoutView {
    if (!_floatLayoutView) {
        _floatLayoutView = [[HDFloatLayoutView alloc] init];
        _floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 10, 15);
    }
    return _floatLayoutView;
}
/** @lazy expandBtn */
- (HDUIButton *)expandBtn {
    if (!_expandBtn) {
        _expandBtn = [[HDUIButton alloc] init];
        [_expandBtn setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        [_expandBtn setImage:[UIImage imageNamed:@"tn_expand_down"] forState:UIControlStateNormal];
        [_expandBtn setImage:[UIImage imageNamed:@"tn_expand_up"] forState:UIControlStateSelected];
        [_expandBtn setTitle:TNLocalizedString(@"tn_expand_more_area", @"展开查看更多配送范围") forState:UIControlStateNormal];
        [_expandBtn setTitle:TNLocalizedString(@"tn_store_less", @"收起") forState:UIControlStateSelected];
        _expandBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontRegular:10];
        _expandBtn.spacingBetweenImageAndTitle = 5;
        _expandBtn.imagePosition = HDUIButtonImagePositionRight;
        _expandBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _expandBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _expandBtn.layer.masksToBounds = YES;
        _expandBtn.layer.cornerRadius = 10;
        _expandBtn.layer.borderWidth = 0.5;
        _expandBtn.layer.borderColor = HDAppTheme.TinhNowColor.G1.CGColor;
        _expandBtn.hidden = YES;
        @HDWeakify(self);
        [_expandBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            btn.selected = !btn.isSelected;
            if (btn.isSelected) {
                self.floatLayoutView.maxRowCount = 0;
            } else {
                self.floatLayoutView.maxRowCount = 1;
            }
            [self addTagItemViews];
            [self setNeedsUpdateConstraints];
        }];
    }
    return _expandBtn;
}
/** @lazy areaTipsLabel */
- (UILabel *)areaTipsLabel {
    if (!_areaTipsLabel) {
        _areaTipsLabel = [[UILabel alloc] init];
        _areaTipsLabel.font = [HDAppTheme.TinhNowFont fontRegular:10];
        _areaTipsLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
        _areaTipsLabel.text = TNLocalizedString(@"tn_click_area_color", @"点击颜色可查看配送范围");
        _areaTipsLabel.numberOfLines = 0;
    }
    return _areaTipsLabel;
}
@end
