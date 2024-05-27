//
//  TNSellerProductCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerProductCell.h"
#import "TNEventTracking.h"
#import "TNGlobalData.h"
#import "TNMarkupPriceSettingAlertView.h"
#import "TNMicroShopDTO.h"
#import "UIView+NAT.h"


@interface TNSellerProductCell ()
@property (strong, nonatomic) UIImageView *productImageView; ///<
@property (strong, nonatomic) UILabel *productNameLabel;     ///<商品名称
@property (strong, nonatomic) UILabel *salePriceLabel;       ///<销售价
@property (strong, nonatomic) UILabel *supplyPriceLabel;     ///<供货价
@property (strong, nonatomic) UILabel *incomeLabel;          ///<收益
@property (strong, nonatomic) HDLabel *salesLabel;           ///<销量

@property (strong, nonatomic) UIStackView *storeStackView; ///< 店铺stackView
@property (strong, nonatomic) UIImageView *storeImageView; ///< 店铺图片
@property (strong, nonatomic) UILabel *storeNameLabel;     ///< 店铺名称
@property (strong, nonatomic) UIImageView *arrowImageView; ///< 右箭头

@property (strong, nonatomic) HDUIButton *addSaleBtn; ///< 加入销售

/// tagStackView
@property (strong, nonatomic) UIStackView *tagStackView;
///促销标签
@property (nonatomic, strong) HDLabel *promotionTag;
/// 包邮图片
@property (strong, nonatomic) UIImageView *freeShippingImageView;
///批量标签
@property (nonatomic, strong) HDLabel *stagePriceTag;

@property (strong, nonatomic) TNMicroShopDTO *dto;
@end


@implementation TNSellerProductCell
- (void)hd_setupViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.productImageView];
    [self.productImageView addSubview:self.salesLabel];
    [self.contentView addSubview:self.productNameLabel];
    [self.contentView addSubview:self.tagStackView];
    [self.tagStackView addArrangedSubview:self.freeShippingImageView];
    [self.tagStackView addArrangedSubview:self.promotionTag];
    [self.tagStackView addArrangedSubview:self.stagePriceTag];
    [self.contentView addSubview:self.salePriceLabel];
    [self.contentView addSubview:self.supplyPriceLabel];
    [self.contentView addSubview:self.incomeLabel];
    [self.contentView addSubview:self.storeStackView];
    [self.storeStackView addArrangedSubview:self.storeImageView];
    [self.storeStackView addArrangedSubview:self.storeNameLabel];
    [self.storeStackView addArrangedSubview:self.arrowImageView];
    [self.contentView addSubview:self.addSaleBtn];
}
- (void)setHiddeStoreInfo:(BOOL)hiddeStoreInfo {
    _hiddeStoreInfo = hiddeStoreInfo;
    self.storeImageView.hidden = YES;
    self.storeNameLabel.hidden = YES;
    self.arrowImageView.hidden = YES;
}
- (void)setModel:(TNSellerProductModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.thumbnail placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(110, 110)] imageView:self.productImageView];

    //判断是否显示已售数量 商品销量>0，显示销售件数；如商品销量=0，则不显示销售数量字段
    if (HDIsStringNotEmpty(model.salesLabel)) {
        self.salesLabel.hidden = false;
        NSString *str = TNLocalizedString(@"tn_text_sold_title", @"Sold ");
        self.salesLabel.text = [str stringByAppendingFormat:@"%@", model.salesLabel];
    } else {
        self.salesLabel.hidden = true;
    }

    if (self.model.storeType == TNStoreEnumTypeSelf || self.model.storeType == TNStoreEnumTypeOverseasShopping) {
        self.productNameLabel.attributedText = [self getGoodNameAttributedText];
    } else {
        self.productNameLabel.text = model.productName;
    }

    [HDWebImageManager setImageWithURL:model.logo placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(15, 15)] imageView:self.storeImageView];
    self.storeNameLabel.text = model.storeName;

    //显示促销商品
    self.promotionTag.hidden = !model.promotion;
    self.stagePriceTag.hidden = !model.stagePrice;
    //包邮图标
    self.freeShippingImageView.hidden = !model.freightSetting;
    if (model.sale) {
        self.addSaleBtn.backgroundColor = HexColor(0xD6DBE8);
        self.addSaleBtn.selected = YES;
    } else {
        self.addSaleBtn.backgroundColor = HDAppTheme.TinhNowColor.C1;
        self.addSaleBtn.selected = NO;
    }
    if (model.sale && !HDIsObjectNil(model.profit)) {
        //已经加入了销售
        self.salePriceLabel.hidden = NO;
        self.incomeLabel.hidden = NO;
        self.supplyPriceLabel.font = [HDAppTheme.TinhNowFont fontRegular:10];
        self.supplyPriceLabel.textColor = HDAppTheme.TinhNowColor.G2;
        self.supplyPriceLabel.text = [NSString stringWithFormat:@"%@ %@", TNLocalizedString(@"QWjyhTSY", @"批发价"), model.bulkPrice.thousandSeparatorAmount];
        self.salePriceLabel.text = [NSString stringWithFormat:@"%@ %@", TNLocalizedString(@"vg0PzsXn", @"销售价"), model.price.thousandSeparatorAmount];
        self.incomeLabel.text = [NSString stringWithFormat:@"%@ %@", TNLocalizedString(@"1dh32q2n", @"收益"), model.profit.thousandSeparatorAmount];
    } else {
        self.salePriceLabel.hidden = YES;
        self.incomeLabel.hidden = YES;
        self.supplyPriceLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        self.supplyPriceLabel.textColor = HexColor(0xFF2323);
        self.supplyPriceLabel.text = [NSString stringWithFormat:@"%@ %@", TNLocalizedString(@"QWjyhTSY", @"批发价"), model.bulkPrice.thousandSeparatorAmount];
    }
    [self setNeedsUpdateConstraints];
}
- (NSMutableAttributedString *)getGoodNameAttributedText {
    NSString *imageName;
    if (self.model.storeType == TNStoreEnumTypeSelf) {
        imageName = @"tn_offcial_k";
    } else {
        imageName = @"tn_global_k";
    }
    UIImage *globalImage = [UIImage imageNamed:imageName];
    NSString *name = [NSString stringWithFormat:@" %@", self.model.productName];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:name];
    NSTextAttachment *imageMent = [[NSTextAttachment alloc] init];
    imageMent.image = globalImage;
    UIFont *font = HDAppTheme.TinhNowFont.standard15;
    CGFloat paddingTop = font.lineHeight - font.pointSize;
    imageMent.bounds = CGRectMake(0, -paddingTop, globalImage.size.width, globalImage.size.height);
    NSAttributedString *attachment = [NSAttributedString attributedStringWithAttachment:imageMent];
    [text insertAttributedString:attachment atIndex:0];
    [text addAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: HDAppTheme.TinhNowColor.G1} range:NSMakeRange(0, name.length)];
    return text;
}
//- (void)setProductNameLabelText {
//    if ([self.model.productType isEqualToString:TNGoodsTypeOverseas]) {
//        UIImage *globalImage = [UIImage imageNamed:@"tn_global_k"];
//        NSString *name = [NSString stringWithFormat:@" %@", self.model.productName];
//        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:name];
//        NSTextAttachment *imageMent = [[NSTextAttachment alloc] init];
//        imageMent.image = globalImage;
//        UIFont *font = HDAppTheme.TinhNowFont.standard15;
//        CGFloat paddingTop = font.lineHeight - font.pointSize;
//        imageMent.bounds = CGRectMake(0, -paddingTop, globalImage.size.width, globalImage.size.height);
//        NSAttributedString *attachment = [NSAttributedString attributedStringWithAttachment:imageMent];
//        [text insertAttributedString:attachment atIndex:0];
//        [text addAttributes:@{NSFontAttributeName : font, NSForegroundColorAttributeName : HDAppTheme.TinhNowColor.G1} range:NSMakeRange(0, name.length)];
//        self.productNameLabel.attributedText = text;
//    } else {
//        self.productNameLabel.text = self.model.productName;
//    }
//}
#pragma mark -privite methed
- (void)storeClick {
    [[HDMediator sharedInstance] navigaveToTinhNowStoreInfoViewController:@{@"isFromProductCenter": @"1", @"sp": [TNGlobalData shared].seller.supplierId, @"storeNo": self.model.storeNo}];
}
///设置加价弹窗
- (void)showSettingPricePolicyAlertView {
    TNMarkupPriceSettingConfig *config = [TNMarkupPriceSettingConfig defaultConfig];
    TNMarkupPriceSettingAlertView *alertView = [[TNMarkupPriceSettingAlertView alloc] initAlertViewWithConfig:config];
    @HDWeakify(self);
    alertView.setPricePolicyCompleteCallBack = ^{
        @HDStrongify(self);
        [self addSale];
    };
    [alertView show];
}
//加入销售
- (void)addSale {
    [self.viewController.view showloading];
    @HDWeakify(self);
    [self.dto addProductToSaleWithSupplierId:[TNGlobalData shared].seller.supplierId productId:self.model.productId categoryId:self.model.categoryId
        policyModel:[TNGlobalData shared].seller.pricePolicyModel success:^(NSArray<TNSellerProductModel *> *list) {
            @HDStrongify(self);
            [self.viewController.view dismissLoading];
            [self setAddBtnSelected:YES];
            [TNGlobalData shared].seller.isNeedRefreshMicroShop = YES;
            if (!HDIsArrayEmpty(list)) {
                TNSellerProductModel *firstModel = list.firstObject;
                self.salePriceLabel.hidden = NO;
                self.incomeLabel.hidden = NO;
                self.supplyPriceLabel.font = [HDAppTheme.TinhNowFont fontRegular:10];
                self.supplyPriceLabel.textColor = HDAppTheme.TinhNowColor.G2;
                self.salePriceLabel.text = [NSString stringWithFormat:@"%@ %@", TNLocalizedString(@"vg0PzsXn", @"销售价"), firstModel.price.thousandSeparatorAmount];
                self.incomeLabel.text = [NSString stringWithFormat:@"%@ %@", TNLocalizedString(@"1dh32q2n", @"收益"), firstModel.profit.thousandSeparatorAmount];
                self.model.profit = firstModel.profit;
                self.model.price = firstModel.price;
            }
            !self.reloadTableViewCallBack ?: self.reloadTableViewCallBack();
            [TNEventTrackingInstance trackEvent:@"buyer_add_product" properties:@{@"buyerId": [TNGlobalData shared].seller.supplierId, @"productId": self.model.productId}];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.viewController.view dismissLoading];
        }];
}
//取消销售
- (void)cancelSale {
    [self.viewController.view showloading];
    @HDWeakify(self);
    [self.dto cancelProductSaleWithSupplierId:[TNGlobalData shared].seller.supplierId productId:self.model.productId success:^{
        @HDStrongify(self);
        [self.viewController.view dismissLoading];
        [self setAddBtnSelected:NO];
        [TNGlobalData shared].seller.isNeedRefreshMicroShop = YES;
        self.salePriceLabel.hidden = YES;
        self.incomeLabel.hidden = YES;
        self.supplyPriceLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        self.supplyPriceLabel.textColor = HexColor(0xFF2323);
        self.supplyPriceLabel.text = [NSString stringWithFormat:@"%@ %@", TNLocalizedString(@"QWjyhTSY", @"批发价"), self.model.bulkPrice.thousandSeparatorAmount];
        !self.reloadTableViewCallBack ?: self.reloadTableViewCallBack();
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.viewController.view dismissLoading];
    }];
}
//点击按钮的点击状态
- (void)setAddBtnSelected:(BOOL)selected {
    self.model.sale = selected;
    self.addSaleBtn.selected = selected;
    if (self.addSaleBtn.isSelected) {
        self.addSaleBtn.backgroundColor = HexColor(0xD6DBE8);
    } else {
        self.addSaleBtn.backgroundColor = HDAppTheme.TinhNowColor.C1;
    }
}
- (void)updateConstraints {
    [self.productImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(20));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(110), kRealWidth(110)));
    }];
    [self.salesLabel sizeToFit];
    [self.salesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_left).offset(kRealWidth(5));
        make.right.equalTo(self.productImageView.mas_right).offset(-kRealWidth(5));
        make.bottom.equalTo(self.productImageView.mas_bottom).offset(-kRealWidth(5));
    }];
    [self.productNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productImageView.mas_top);
        make.left.equalTo(self.productImageView.mas_right).offset(kRealWidth(10));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    UIView *lastView = self.productNameLabel;
    if (!self.freeShippingImageView.isHidden || !self.promotionTag.isHidden || !self.stagePriceTag.isHidden) {
        lastView = self.tagStackView;
        [self.freeShippingImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kRealWidth(34), kRealWidth(18)));
        }];
        [self.promotionTag sizeToFit];
        [self.promotionTag mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kRealWidth(15));
        }];
        [self.stagePriceTag sizeToFit];
        [self.stagePriceTag mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kRealWidth(15));
        }];
        [self.tagStackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.productNameLabel.mas_bottom).offset(kRealWidth(10));
            make.leading.equalTo(self.productNameLabel.mas_leading);
        }];
    }
    if (!self.supplyPriceLabel.isHidden) {
        [self.supplyPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(10));
            make.leading.equalTo(self.productNameLabel.mas_leading);
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        }];
    }
    if (!self.salePriceLabel.isHidden) {
        [self.salePriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.supplyPriceLabel.mas_bottom).offset(kRealWidth(5));
            make.leading.equalTo(self.productNameLabel.mas_leading);
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        }];
    }
    if (!self.incomeLabel.isHidden) {
        [self.incomeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.productNameLabel.mas_leading);
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
            if (lastView == self.tagStackView) {
                make.top.equalTo(self.salePriceLabel.mas_bottom).offset(kRealWidth(10));
            } else {
                make.bottom.equalTo(self.productImageView.mas_bottom);
            }
        }];
    }
    [self.storeStackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.productImageView.mas_leading);
        make.right.lessThanOrEqualTo(self.addSaleBtn.mas_left).offset(-kRealWidth(15));
        make.centerY.equalTo(self.addSaleBtn.mas_centerY);
    }];

    if (!self.storeNameLabel.isHidden) {
        [self.storeNameLabel sizeToFit];
        [self.storeNameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    [self.storeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(15), kRealWidth(15)));
    }];
    [self.arrowImageView sizeToFit];
    [self.arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.arrowImageView.image.size);
    }];

    [self.addSaleBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(10));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(110), kRealWidth(25)));
    }];

    [super updateConstraints];
}

/** @lazy productImageView */
- (UIImageView *)productImageView {
    if (!_productImageView) {
        _productImageView = [[UIImageView alloc] init];
        _productImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _productImageView;
}
/** @lazy salesLabel */
- (HDLabel *)salesLabel {
    if (!_salesLabel) {
        _salesLabel = [[HDLabel alloc] init];
        _salesLabel.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.50];
        _salesLabel.textColor = [UIColor whiteColor];
        _salesLabel.font = [HDAppTheme.TinhNowFont fontRegular:10];
        _salesLabel.textAlignment = NSTextAlignmentCenter;
        _salesLabel.hd_edgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
        _salesLabel.layer.cornerRadius = 4;
        _salesLabel.layer.masksToBounds = YES;
    }
    return _salesLabel;
}
/** @lazy productNameLabel */
- (UILabel *)productNameLabel {
    if (!_productNameLabel) {
        _productNameLabel = [[UILabel alloc] init];
        _productNameLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15];
        _productNameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _productNameLabel.numberOfLines = 2;
    }
    return _productNameLabel;
}
/** @lazy salePriceLabel */
- (UILabel *)salePriceLabel {
    if (!_salePriceLabel) {
        _salePriceLabel = [[UILabel alloc] init];
        _salePriceLabel.font = [HDAppTheme.TinhNowFont fontRegular:10];
        _salePriceLabel.textColor = HDAppTheme.TinhNowColor.cFF2323;
    }
    return _salePriceLabel;
}
/** @lazy supplyPriceLabel */
- (UILabel *)supplyPriceLabel {
    if (!_supplyPriceLabel) {
        _supplyPriceLabel = [[UILabel alloc] init];
        _supplyPriceLabel.font = [HDAppTheme.TinhNowFont fontRegular:10];
        _supplyPriceLabel.textColor = HDAppTheme.TinhNowColor.cFF2323;
    }
    return _supplyPriceLabel;
}
/** @lazy incomeLabel */
- (UILabel *)incomeLabel {
    if (!_incomeLabel) {
        _incomeLabel = [[UILabel alloc] init];
        _incomeLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        _incomeLabel.textColor = HDAppTheme.TinhNowColor.C1;
    }
    return _incomeLabel;
}
/** @lazy storeStackView */
- (UIStackView *)storeStackView {
    if (!_storeStackView) {
        _storeStackView = [[UIStackView alloc] init];
        _storeStackView.axis = UILayoutConstraintAxisHorizontal;
        _storeStackView.spacing = 5;
        _storeStackView.alignment = UIStackViewAlignmentCenter;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storeClick)];
        [_storeStackView addGestureRecognizer:tap];
    }
    return _storeStackView;
}
/** @lazy storeImageView */
- (UIImageView *)storeImageView {
    if (!_storeImageView) {
        _storeImageView = [[UIImageView alloc] init];
        _storeImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.width / 2];
        };
    }
    return _storeImageView;
}
/** @lazy storeNameLabel */
- (UILabel *)storeNameLabel {
    if (!_storeNameLabel) {
        _storeNameLabel = [[UILabel alloc] init];
        _storeNameLabel.font = [HDAppTheme.TinhNowFont fontRegular:12];
        _storeNameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _storeNameLabel.numberOfLines = 2;
    }
    return _storeNameLabel;
}
/** @lazy arrowImageView */
- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_gray_small"]];
    }
    return _arrowImageView;
}
/** @lazy addSaleBtn */
- (HDUIButton *)addSaleBtn {
    if (!_addSaleBtn) {
        _addSaleBtn = [[HDUIButton alloc] init];
        _addSaleBtn.backgroundColor = HDAppTheme.TinhNowColor.C1;
        _addSaleBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        [_addSaleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        _addSaleBtn.titleEdgeInsets = UIEdgeInsetsMake(4, 20, 4, 20);
        [_addSaleBtn setTitle:TNLocalizedString(@"3Sfc8II1", @"加入销售") forState:UIControlStateNormal];
        [_addSaleBtn setTitle:TNLocalizedString(@"i4h6aHsC", @"取消销售") forState:UIControlStateSelected];
        _addSaleBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
        @HDWeakify(self);
        [_addSaleBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.model.sale) { //已经加入销售了
                [NAT showAlertWithMessage:TNLocalizedString(@"SZwLu50L", @"确定移除所选商品？") confirmButtonTitle:TNLocalizedString(@"tn_button_confirm_title", @"确定")
                    confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        [self cancelSale];
                        [alertView dismiss];
                    }
                    cancelButtonTitle:TNLocalizedString(@"tn_button_cancel_title", @"取消") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        [alertView dismiss];
                    }];

            } else {
                if (!HDIsObjectNil([TNGlobalData shared].seller.pricePolicyModel) && [TNGlobalData shared].seller.pricePolicyModel.operationType != TNMicroShopPricePolicyTypeNone) {
                    [self addSale];
                } else {
                    [NAT showAlertWithMessage:TNLocalizedString(@"AKccELBK", @"暂未设置店铺加价，请先设置") confirmButtonTitle:TNLocalizedString(@"tn_button_confirm_title", @"确定")
                        confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                            [self showSettingPricePolicyAlertView];
                            [alertView dismiss];
                        }
                        cancelButtonTitle:TNLocalizedString(@"tn_button_cancel_title", @"取消") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                            [alertView dismiss];
                        }];
                }
            }
        }];
    }
    return _addSaleBtn;
}
/** @lazy promotionTag */
- (HDLabel *)promotionTag {
    if (!_promotionTag) {
        _promotionTag = [[HDLabel alloc] init];
        _promotionTag.font = [HDAppTheme.TinhNowFont fontSemibold:10];
        _promotionTag.textColor = HexColor(0xFF2323);
        _promotionTag.backgroundColor = [UIColor whiteColor];
        _promotionTag.textAlignment = NSTextAlignmentCenter;
        _promotionTag.text = @"Promotion";
        _promotionTag.hd_edgeInsets = UIEdgeInsetsMake(0, 4, 0, 4);
        _promotionTag.layer.cornerRadius = 2;
        _promotionTag.layer.borderColor = HexColor(0xFF2323).CGColor;
        _promotionTag.layer.borderWidth = 0.5;
    }
    return _promotionTag;
}
/** @lazy stagePriceTag */
- (HDLabel *)stagePriceTag {
    if (!_stagePriceTag) {
        _stagePriceTag = [[HDLabel alloc] init];
        _stagePriceTag.font = [HDAppTheme.TinhNowFont fontSemibold:10];
        _stagePriceTag.textColor = HexColor(0xFF2323);
        _stagePriceTag.backgroundColor = [UIColor whiteColor];
        _stagePriceTag.textAlignment = NSTextAlignmentCenter;
        _stagePriceTag.text = TNLocalizedString(@"d6Te2ndf", @"批量");
        _stagePriceTag.hd_edgeInsets = UIEdgeInsetsMake(0, 4, 0, 4);
        _stagePriceTag.layer.cornerRadius = 2;
        _stagePriceTag.layer.borderColor = HexColor(0xFF2323).CGColor;
        _stagePriceTag.layer.borderWidth = 0.5;
    }
    return _stagePriceTag;
}
/** @lazy freeShippingImageView */
- (UIImageView *)freeShippingImageView {
    if (!_freeShippingImageView) {
        _freeShippingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_small_freeshipping"]];
        _freeShippingImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _freeShippingImageView;
}
/** @lazy tagStackView */
- (UIStackView *)tagStackView {
    if (!_tagStackView) {
        _tagStackView = [[UIStackView alloc] init];
        _tagStackView.axis = UILayoutConstraintAxisHorizontal;
        _tagStackView.spacing = kRealWidth(5);
        _tagStackView.alignment = UIStackViewAlignmentFill;
    }
    return _tagStackView;
}
/** @lazy dto */
- (TNMicroShopDTO *)dto {
    if (!_dto) {
        _dto = [[TNMicroShopDTO alloc] init];
    }
    return _dto;
}
@end
