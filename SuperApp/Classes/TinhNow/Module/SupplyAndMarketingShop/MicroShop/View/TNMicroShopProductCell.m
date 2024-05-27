//
//  TNMicroShopProductCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/9.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNMicroShopProductCell.h"
#import "HDAppTheme+TinhNow.h"
#import "SAAppEnvManager.h"
#import "TNEventTracking.h"
#import "TNGlobalData.h"
#import "TNHostUrlConst.h"
#import "TNMarkupPriceSettingAlertView.h"
#import "TNMicroShopDTO.h"
#import "TNShareManager.h"
#import "UIView+NAT.h"


@interface TNMicroShopProductCell ()
@property (strong, nonatomic) UIStackView *stackView;        ///<容器
@property (strong, nonatomic) HDUIButton *selectedButton;    ///< 选择按钮
@property (strong, nonatomic) UIView *containerView;         ///< 内容视图
@property (strong, nonatomic) UIImageView *productImageView; ///<商品图片
@property (strong, nonatomic) UILabel *productNameLabel;     ///<商品名称
@property (strong, nonatomic) UILabel *salePriceLabel;       ///<销售价
@property (strong, nonatomic) UILabel *supplyPriceLabel;     ///<供货价
@property (strong, nonatomic) UILabel *incomeLabel;          ///<收益
///
@property (strong, nonatomic) UIView *buttonContainer;              ///<容器
@property (strong, nonatomic) SAOperationButton *deleteButton;      ///<删除按钮
@property (strong, nonatomic) SAOperationButton *changePriceButton; ///<改价按钮
@property (strong, nonatomic) SAOperationButton *shareButton;       ///<分享按钮
@property (strong, nonatomic) HDUIGhostButton *hotButton;           ///<热卖按钮
@property (strong, nonatomic) UIView *bottonLineView;               ///<底部分割线
/// tagStackView
@property (strong, nonatomic) UIStackView *tagStackView;
///促销标签
@property (nonatomic, strong) HDLabel *promotionTag;
/// 包邮图片
@property (strong, nonatomic) UIImageView *freeShippingImageView;
///批量标签
@property (nonatomic, strong) HDLabel *stagePriceTag;
///
@property (strong, nonatomic) UIImageView *hotImageView;
@property (strong, nonatomic) TNMicroShopDTO *dto;
@end


@implementation TNMicroShopProductCell
- (void)hd_setupViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.stackView];

    [self.stackView addArrangedSubview:self.selectedButton];
    [self.stackView addArrangedSubview:self.containerView];

    [self.containerView addSubview:self.productImageView];
    [self.productImageView addSubview:self.hotImageView];
    [self.containerView addSubview:self.productNameLabel];

    [self.contentView addSubview:self.tagStackView];
    [self.tagStackView addArrangedSubview:self.freeShippingImageView];
    [self.tagStackView addArrangedSubview:self.promotionTag];
    [self.tagStackView addArrangedSubview:self.stagePriceTag];

    [self.containerView addSubview:self.salePriceLabel];
    [self.containerView addSubview:self.supplyPriceLabel];
    [self.containerView addSubview:self.incomeLabel];

    [self.containerView addSubview:self.buttonContainer];
    [self.buttonContainer addSubview:self.deleteButton];
    [self.buttonContainer addSubview:self.changePriceButton];
    [self.buttonContainer addSubview:self.shareButton];
    [self.buttonContainer addSubview:self.hotButton];
    [self.contentView addSubview:self.bottonLineView];
}
- (void)setModel:(TNSellerProductModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.thumbnail placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(100, 100)] imageView:self.productImageView];
    //    [self setProductNameLabelText];
    if (self.model.storeType == TNStoreEnumTypeSelf || self.model.storeType == TNStoreEnumTypeOverseasShopping) {
        self.productNameLabel.attributedText = [self getGoodNameAttributedText];
    } else {
        self.productNameLabel.text = model.productName;
    }
    //显示促销商品
    self.promotionTag.hidden = !model.promotion;
    self.stagePriceTag.hidden = !model.stagePrice;
    //包邮图标
    self.freeShippingImageView.hidden = !model.freightSetting;
    if (!HDIsObjectNil(model.price)) {
        self.salePriceLabel.text = [NSString stringWithFormat:@"%@ %@", TNLocalizedString(@"vg0PzsXn", @"销售价"), model.price.thousandSeparatorAmount];
    }
    if (!HDIsObjectNil(model.bulkPrice)) {
        self.supplyPriceLabel.text = [NSString stringWithFormat:@"%@ %@", TNLocalizedString(@"QWjyhTSY", @"批发价"), model.bulkPrice.thousandSeparatorAmount];
    }
    if (!HDIsObjectNil(model.profit)) {
        self.incomeLabel.text = [NSString stringWithFormat:@"%@ %@", TNLocalizedString(@"1dh32q2n", @"收益"), model.profit.thousandSeparatorAmount];
    }
    self.selectedButton.selected = model.isSelected;
    self.hotImageView.hidden = !model.enabledHotSale;
    self.hotButton.selected = model.enabledHotSale;
    if (model.enabledHotSale) {
        self.hotButton.backgroundColor = HDAppTheme.TinhNowColor.cD6DBE8;
    } else {
        self.hotButton.backgroundColor = HDAppTheme.TinhNowColor.C1;
    }
    [self setNeedsUpdateConstraints];
}
- (void)setIsShowSelected:(BOOL)isShowSelected {
    _isShowSelected = isShowSelected;
    self.selectedButton.hidden = !isShowSelected;
    self.deleteButton.enabled = !isShowSelected;
    self.changePriceButton.enabled = !isShowSelected;
    self.shareButton.enabled = !isShowSelected;
    self.hotButton.enabled = !isShowSelected;
    [self setNeedsUpdateConstraints];
}
- (void)setIsFromSearch:(BOOL)isFromSearch {
    _isFromSearch = isFromSearch;
    if (isFromSearch) {
        self.bottonLineView.hidden = YES;
        //        self.incomeLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
    }
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
//    if ([self.model.productType isEqualToString:TNGoodsTypeOverseas] || [self.model.productType isEqualToString:@"4"]) {
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
///验证视图是否画过圆角线
- (BOOL)checkViewHasRoundLineLayer:(UIView *)checkView {
    if (checkView.layer.sublayers.count > 0) {
        CALayer *layer = checkView.layer.sublayers.firstObject;
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            return YES;
        }
    }
    return NO;
}
#pragma mark -删除商品
- (void)deleteProduct {
    [self.viewController.view showloading];
    @HDWeakify(self);
    [self.dto cancelProductSaleWithSupplierId:[TNGlobalData shared].seller.supplierId productId:self.model.productId success:^{
        @HDStrongify(self);
        [self.viewController.view dismissLoading];
        !self.deleteProductCallBack ?: self.deleteProductCallBack(self.model);
        //删除商品
        [TNEventTrackingInstance trackEvent:@"buyer_del_product" properties:@{@"buyerId": [TNGlobalData shared].seller.supplierId, @"type": @"4", @"productId": self.model.productId}];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.viewController.view dismissLoading];
    }];
}

#pragma mark -商品改价
- (void)changeProductPriceWithSkus:(NSArray<TNProductSkuModel *> *)skus {
    TNMarkupPriceSettingConfig *config = [TNMarkupPriceSettingConfig defaultConfig];
    config.type = TNMarkupPriceSettingTypeSingleProduct;
    config.skus = skus;
    config.productId = self.model.productId;
    TNMarkupPriceSettingAlertView *alertView = [[TNMarkupPriceSettingAlertView alloc] initAlertViewWithConfig:config];
    @HDWeakify(self);
    alertView.setPricePolicyCompleteCallBack = ^{
        @HDStrongify(self);
        !self.changeProductPriceCallBack ?: self.changeProductPriceCallBack();
    };
    [alertView show];
}
#pragma mark -分享商品
- (void)shareProduct {
    TNShareModel *shareModel = [[TNShareModel alloc] init];
    shareModel.shareImage = self.model.thumbnail;
    shareModel.shareTitle = self.model.productName;
    shareModel.shareContent = [NSString stringWithFormat:TNLocalizedString(@"tn_share_good_detail_desc", @"优惠价 %@"), self.model.price.thousandSeparatorAmount];
    shareModel.shareLink = [[SAAppEnvManager sharedInstance].appEnvConfig.tinhNowHost
        stringByAppendingFormat:@"%@productId=%@&sp=%@", kTinhNowProductDetail, self.model.productId, [TNGlobalData shared].seller.supplierId];
    shareModel.sourceId = self.model.productId;
    TNSocialShareProductDetailModel *priceModel = [[TNSocialShareProductDetailModel alloc] init];
    priceModel.price = self.model.price;
    priceModel.marketPrice = self.model.marketPrice;
    priceModel.showDiscount = self.model.showDisCount;
    shareModel.productDetailModel = priceModel;
    [[TNShareManager sharedInstance] showShareWithShareModel:shareModel];

    //分享微店商品埋点
    [TNEventTrackingInstance trackEvent:@"share" properties:@{@"buyerId": [TNGlobalData shared].seller.supplierId, @"type": @"4", @"productId": self.model.productId}];
}
#pragma mark -设置取消商品热卖
- (void)setProductHotSales:(BOOL)hotSeles {
    [self.viewController.view showloading];
    @HDWeakify(self);
    [self.dto setProductHotSalesBySupplierId:[TNGlobalData shared].seller.supplierId productId:self.model.productId enabledHotSale:hotSeles success:^{
        @HDStrongify(self);
        [self.viewController.view dismissLoading];
        self.model.enabledHotSale = hotSeles;
        if (hotSeles) {
            [HDTips showWithText:TNLocalizedString(@"W8Ynfqn2", @"已设置热卖")];
        } else {
            [HDTips showWithText:TNLocalizedString(@"azV44ImU", @"已取消热卖")];
        }
        !self.setProductHotSalesCallBack ?: self.setProductHotSalesCallBack(hotSeles);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.viewController.view dismissLoading];
    }];
}
#pragma mark -获取商品sku信息
- (void)getProductSkuData {
    [self.viewController.view showloading];
    @HDWeakify(self);
    [self.dto queryProductSkuDataBySupplierId:[TNGlobalData shared].seller.supplierId productId:self.model.productId success:^(NSArray<TNProductSkuModel *> *skus) {
        @HDStrongify(self);
        [self.viewController.view dismissLoading];
        [self changeProductPriceWithSkus:skus];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.viewController.view dismissLoading];
    }];
}

- (void)updateConstraints {
    [self.selectedButton sizeToFit];
    [self.selectedButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.selectedButton.imageView.image.size);
    }];

    [self.productImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView);
        make.top.equalTo(self.containerView.mas_top).offset(kRealWidth(10));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(100), kRealWidth(100)));
    }];
    if (!self.hotImageView.isHidden) {
        [self.hotImageView sizeToFit];
        [self.hotImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.productImageView);
        }];
    }
    [self.productNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productImageView.mas_top);
        make.left.equalTo(self.productImageView.mas_right).offset(kRealWidth(13));
        make.right.lessThanOrEqualTo(self.containerView.mas_right).offset(-kRealWidth(15));
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
            make.top.equalTo(self.productNameLabel.mas_bottom).offset(kRealWidth(5));
            make.leading.equalTo(self.productNameLabel.mas_leading);
        }];
    }

    [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(10));
        make.right.equalTo(self.contentView.mas_right).offset(self.isShowSelected ? -kRealWidth(5) + self.selectedButton.imageView.image.size.width : -kRealWidth(15));
        make.height.mas_equalTo(self.model.microShopContentStackHeight + kRealWidth(80));
    }];

    [self.salePriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(5));
        make.leading.equalTo(self.productNameLabel.mas_leading);
        make.right.lessThanOrEqualTo(self.containerView.mas_right).offset(-kRealWidth(15));
    }];
    [self.supplyPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.salePriceLabel.mas_bottom).offset(kRealWidth(5));
        make.leading.equalTo(self.productNameLabel.mas_leading);
        make.right.lessThanOrEqualTo(self.containerView.mas_right).offset(-kRealWidth(15));
    }];
    [self.incomeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.supplyPriceLabel.mas_bottom).offset(kRealWidth(5));
        make.leading.equalTo(self.productNameLabel.mas_leading);
        make.right.lessThanOrEqualTo(self.containerView.mas_right).offset(-kRealWidth(15));
    }];

    [self.buttonContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        //        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        //        make.right.equalTo(self.contentView.mas_right).offset(kRealWidth(-15));
        make.left.right.equalTo(self.containerView);
        if (lastView == self.tagStackView && self.model.microShopContentStackHeight > kRealWidth(120)) {
            make.top.equalTo(self.incomeLabel.mas_bottom).offset(kRealWidth(10));
        } else {
            make.top.equalTo(self.productImageView.mas_bottom).offset(kRealWidth(10));
        }
        make.height.mas_equalTo(kRealWidth(80));
    }];

    CGFloat buttonLeft = 0;
    //    self.isFromSearch ? kRealWidth(25) : kRealWidth(10);
    CGFloat buttonSpace = self.isFromSearch ? kRealWidth(35) : kRealWidth(18);
    [self.deleteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.buttonContainer.mas_left).offset(buttonLeft);
        make.width.mas_equalTo(self.shareButton.mas_width);
        make.top.equalTo(self.buttonContainer.mas_top).offset(kRealWidth(10));
        make.height.mas_equalTo(kRealWidth(25));
    }];

    [self.shareButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.buttonContainer.mas_right).offset(-buttonLeft);
        make.left.equalTo(self.deleteButton.mas_right).offset(buttonSpace);
        make.height.equalTo(self.deleteButton.mas_height);
        make.centerY.equalTo(self.deleteButton.mas_centerY);
    }];

    [self.changePriceButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.deleteButton.mas_height);
        make.left.equalTo(self.buttonContainer.mas_left).offset(buttonLeft);
        make.width.mas_equalTo(self.hotButton.mas_width);
        make.top.equalTo(self.deleteButton.mas_bottom).offset(kRealWidth(10));
    }];

    [self.hotButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.buttonContainer.mas_right).offset(-buttonLeft);
        make.left.equalTo(self.changePriceButton.mas_right).offset(buttonSpace);
        make.height.equalTo(self.deleteButton.mas_height);
        make.centerY.equalTo(self.changePriceButton.mas_centerY);
    }];

    [self.bottonLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        //        make.top.equalTo(self.buttonContainer.mas_bottom).offset(kRealWidth(10));
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    [super updateConstraints];
}
/** @lazy stackView */
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.spacing = kRealWidth(15);
    }
    return _stackView;
}
/** @lazy selectedButton */
- (HDUIButton *)selectedButton {
    if (!_selectedButton) {
        _selectedButton = [[HDUIButton alloc] init];
        [_selectedButton setImage:[UIImage imageNamed:@"tn_gray_unselect"] forState:UIControlStateNormal];
        [_selectedButton setImage:[UIImage imageNamed:@"tn_gray_select"] forState:UIControlStateSelected];
        _selectedButton.userInteractionEnabled = NO;
        _selectedButton.hidden = YES;
    }
    return _selectedButton;
}
/** @lazy containerView */
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}
/** @lazy productImageView */
- (UIImageView *)productImageView {
    if (!_productImageView) {
        _productImageView = [[UIImageView alloc] init];
        _productImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8.0];
        };
    }
    return _productImageView;
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
        _salePriceLabel.textColor = HDAppTheme.TinhNowColor.G2;
    }
    return _salePriceLabel;
}
/** @lazy supplyPriceLabel */
- (UILabel *)supplyPriceLabel {
    if (!_supplyPriceLabel) {
        _supplyPriceLabel = [[UILabel alloc] init];
        _supplyPriceLabel.font = [HDAppTheme.TinhNowFont fontRegular:10];
        _supplyPriceLabel.textColor = HDAppTheme.TinhNowColor.G2;
    }
    return _supplyPriceLabel;
}
/** @lazy incomeLabel */
- (UILabel *)incomeLabel {
    if (!_incomeLabel) {
        _incomeLabel = [[UILabel alloc] init];
        _incomeLabel.font = [HDAppTheme.TinhNowFont fontMedium:10];
        _incomeLabel.textColor = HDAppTheme.TinhNowColor.C1;
    }
    return _incomeLabel;
}
/** @lazy deleteButton */
- (SAOperationButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        _deleteButton.titleEdgeInsets = UIEdgeInsetsZero;
        _deleteButton.spacingBetweenImageAndTitle = 5;
        _deleteButton.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        [_deleteButton setTitle:TNLocalizedString(@"tn_delete", @"删除") forState:UIControlStateNormal];
        [_deleteButton setImage:[UIImage imageNamed:@"tn_seller_product_delete"] forState:UIControlStateNormal];
        [_deleteButton applyHollowPropertiesWithTintColor:HDAppTheme.TinhNowColor.G1];
        _deleteButton.borderWidth = 0.5;
        @HDWeakify(self);
        [_deleteButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [NAT showAlertWithMessage:TNLocalizedString(@"SZwLu50L", @"确定移除所选商品？") confirmButtonTitle:TNLocalizedString(@"tn_button_confirm_title", @"确定")
                confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                    [self deleteProduct];
                    [alertView dismiss];
                }
                cancelButtonTitle:TNLocalizedString(@"tn_button_cancel_title", @"取消") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                    [alertView dismiss];
                }];
        }];
    }
    return _deleteButton;
}
/** @lazy changePriceButton */
- (SAOperationButton *)changePriceButton {
    if (!_changePriceButton) {
        _changePriceButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        _changePriceButton.titleEdgeInsets = UIEdgeInsetsZero;
        _changePriceButton.spacingBetweenImageAndTitle = 5;
        _changePriceButton.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        [_changePriceButton setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        [_changePriceButton setTitle:TNLocalizedString(@"ZwILnSab", @"改价") forState:UIControlStateNormal];
        [_changePriceButton setImage:[UIImage imageNamed:@"tn_seller_product_modify_price"] forState:UIControlStateNormal];
        [_changePriceButton applyHollowPropertiesWithTintColor:HDAppTheme.TinhNowColor.G1];
        _changePriceButton.borderWidth = 0.5;
        @HDWeakify(self);
        [_changePriceButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self getProductSkuData];
        }];
    }
    return _changePriceButton;
}
/** @lazy changePriceButton */
- (HDUIGhostButton *)hotButton {
    if (!_hotButton) {
        _hotButton = [[HDUIGhostButton alloc] init];
        _hotButton.titleEdgeInsets = UIEdgeInsetsZero;
        _hotButton.spacingBetweenImageAndTitle = 5;
        _hotButton.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        [_hotButton setTitle:TNLocalizedString(@"hiVjz7zq", @"设置热卖") forState:UIControlStateNormal];
        [_hotButton setTitle:TNLocalizedString(@"FEVFu8Ej", @"取消热卖") forState:UIControlStateSelected];
        [_hotButton setImage:[UIImage imageNamed:@"tn_seller_product_set_hot"] forState:UIControlStateNormal];
        [_hotButton setImage:[UIImage imageNamed:@"tn_seller_product_cancel_hot"] forState:UIControlStateSelected];
        [_hotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_hotButton setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateSelected];
        @HDWeakify(self);
        [_hotButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self setProductHotSales:!self.model.enabledHotSale];
        }];
    }
    return _hotButton;
}
/** @lazy changePriceButton */
- (HDUIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        _shareButton.titleEdgeInsets = UIEdgeInsetsZero;
        _shareButton.spacingBetweenImageAndTitle = 5;
        _shareButton.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        [_shareButton setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        [_shareButton setTitle:TNLocalizedString(@"tn_share_category_title", @"分享") forState:UIControlStateNormal];
        [_shareButton setImage:[UIImage imageNamed:@"tn_seller_product_share"] forState:UIControlStateNormal];
        [_shareButton applyHollowPropertiesWithTintColor:HDAppTheme.TinhNowColor.G1];
        _shareButton.borderWidth = 0.5;
        @HDWeakify(self);
        [_shareButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self shareProduct];
        }];
    }
    return _shareButton;
}
/** @lazy bottonLineView */
- (UIView *)bottonLineView {
    if (!_bottonLineView) {
        _bottonLineView = [[UIView alloc] init];
        _bottonLineView.backgroundColor = HexColor(0xD6DBE8);
    }
    return _bottonLineView;
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
/** @lazy buttonContainer */
- (UIView *)buttonContainer {
    if (!_buttonContainer) {
        _buttonContainer = [[UIView alloc] init];
    }
    return _buttonContainer;
}
/** @lazy dto */
- (TNMicroShopDTO *)dto {
    if (!_dto) {
        _dto = [[TNMicroShopDTO alloc] init];
    }
    return _dto;
}
/** @lazy hotImageView */
- (UIImageView *)hotImageView {
    if (!_hotImageView) {
        _hotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_seller_hot_product"]];
    }
    return _hotImageView;
}
@end
