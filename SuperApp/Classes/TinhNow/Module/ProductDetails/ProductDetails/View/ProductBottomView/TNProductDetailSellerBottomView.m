//
//  TNProductDetailSellerBottomView.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNProductDetailSellerBottomView.h"
#import "SATalkingData.h"
#import "TNCutomerServicePopCell.h"
#import "TNMarkupPriceSettingAlertView.h"
#import "TNMicroShopDTO.h"
#import "TNProductDetailsRspModel.h"
#import "TNProductDetailsViewModel.h"
#import "YBPopupMenu.h"


@interface TNProductDetailSellerBottomView () <YBPopupMenuDelegate>
/// viewModel
@property (nonatomic, strong) TNProductDetailsViewModel *viewModel;
/// 门店按钮
@property (nonatomic, strong) HDUIButton *storeBtn;
/// 客服按钮
@property (nonatomic, strong) HDUIButton *customerBtn;
/// 顶部线条
@property (nonatomic, strong) UIView *topLine;
/// 按钮
@property (strong, nonatomic) UIStackView *btnsStackView;
/// 加入购物车按钮
@property (nonatomic, strong) SAOperationButton *addShoppingCartBTN;
/// 立即购买
@property (nonatomic, strong) SAOperationButton *buyNowBtn;
/// 缺货
@property (nonatomic, strong) SAOperationButton *soldOutBtn;
/// 加入销售
@property (nonatomic, strong) SAOperationButton *addSellBtn;
@property (strong, nonatomic) TNMicroShopDTO *dto;
/// 是否能够购买
@property (nonatomic, assign) BOOL soldOutFlag;
@end


@implementation TNProductDetailSellerBottomView
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    self = [super initWithViewModel:viewModel];
    return self;
}
- (void)hd_setupViews {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.topLine];
    [self addSubview:self.storeBtn];
    [self addSubview:self.customerBtn];
    [self addSubview:self.btnsStackView];
    [self.btnsStackView addArrangedSubview:self.addShoppingCartBTN];
    [self.btnsStackView addArrangedSubview:self.buyNowBtn];
    [self.btnsStackView addArrangedSubview:self.addSellBtn];
    [self.btnsStackView addArrangedSubview:self.soldOutBtn];

    self.soldOutBtn.hidden = YES;
}
/// MARK: pop弹窗
- (void)showPopMenu:(HDUIButton *)sender {
    [YBPopupMenu showRelyOnView:sender titles:@[@""] icons:@[@""] menuWidth:kRealWidth(240) otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.delegate = (id)self;
        popupMenu.itemHeight = kRealWidth(70);
        popupMenu.cornerRadius = 8.f;
        popupMenu.backColor = HDAppTheme.TinhNowColor.G1;
        popupMenu.offset = 6;
    }];
}
#pragma mark - YBPopupMenuDelegate
- (UITableViewCell *)ybPopupMenu:(YBPopupMenu *)ybPopupMenu cellForRowAtIndex:(NSInteger)index {
    TNCutomerServicePopCell *cell = [TNCutomerServicePopCell cellWithTableView:ybPopupMenu.tableView];
    @HDWeakify(self);
    cell.chatClickCallBack = ^{
        @HDStrongify(self);
        [YBPopupMenu dismissAllPopupMenu];
        !self.customerServiceButtonClickedHander ?: self.customerServiceButtonClickedHander(self.viewModel.productDetailsModel.storeNo);
    };
    cell.phoneClickCallBack = ^{
        @HDStrongify(self);
        [YBPopupMenu dismissAllPopupMenu];
        !self.phoneButtonClickedHander ?: self.phoneButtonClickedHander();
    };
    cell.smsClickCallBack = ^{
        @HDStrongify(self);
        [YBPopupMenu dismissAllPopupMenu];
        !self.smsButtonClickedHander ?: self.smsButtonClickedHander();
    };
    return cell;
}
#pragma mark
- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self refreshViewWithModel:self.viewModel.productDetailsModel];
    }];
}
#pragma mark - private methods
- (void)refreshViewWithModel:(TNProductDetailsRspModel *)model {
    if (model.skus.count == 1) {
        TNProductSkuModel *skuModel = model.skus.firstObject;
        if (skuModel.stock.integerValue > 0) {
            self.soldOutFlag = NO;
        } else {
            self.soldOutFlag = YES;
        }
    } else {
        self.soldOutFlag = YES;
        for (TNProductSkuModel *skuModel in model.skus) {
            if (skuModel.stock.integerValue > 0) {
                self.soldOutFlag = NO;
                break;
            }
        }
    }
    if (self.soldOutFlag) {
        [self.addShoppingCartBTN setHidden:YES];
        [self.buyNowBtn setHidden:YES];
        [self.addSellBtn setHidden:YES];
        [self.soldOutBtn setHidden:NO];
    } else {
        //有库存的情况下 还要判断商品是否是限购商品  如果是限购商品  只提供立即购买功能  隐藏加入购物车逻辑
        [self.addSellBtn setHidden:NO];
        [self.buyNowBtn setHidden:NO];
        [self.soldOutBtn setHidden:YES];
        if (model.goodsLimitBuy) {
            [self.addShoppingCartBTN setHidden:YES];
        } else {
            [self.addShoppingCartBTN setHidden:NO];
            // 确认 fValue 是否为 buyNow 则只显示立即购买
            //            if ([self.fValue isEqualToString:kBuyNow]) {
            //                [self.addShoppingCartBTN setHidden:YES];
            //            }
        }

        [self setSellerBtnSelected:model.isJoinSales];
    }

    [self setNeedsUpdateConstraints];
}
//设置加入销售按钮状态
- (void)setSellerBtnSelected:(BOOL)isJoinSales {
    self.viewModel.productDetailsModel.isJoinSales = isJoinSales;
    if (isJoinSales) {
        [self.addSellBtn applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.cD6DBE8];
        [self.addSellBtn setTitleColor:HDAppTheme.TinhNowColor.G2 forState:UIControlStateNormal];
        [self.addSellBtn setTitle:TNLocalizedString(@"i4h6aHsC", @"取消销售") forState:UIControlStateNormal];
    } else {
        [self.addSellBtn applyPropertiesWithBackgroundColor:HexColor(0xE12733)];
        [self.addSellBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.addSellBtn setTitle:TNLocalizedString(@"3Sfc8II1", @"加入销售") forState:UIControlStateNormal];
    }
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
    [self.dto addProductToSaleWithSupplierId:[TNGlobalData shared].seller.supplierId productId:self.viewModel.productDetailsModel.productId
        categoryId:self.viewModel.productDetailsModel.productCategoryId
        policyModel:[TNGlobalData shared].seller.pricePolicyModel success:^(NSArray<TNSellerProductModel *> *list) {
            @HDStrongify(self);
            [self.viewController.view dismissLoading];
            [self setSellerBtnSelected:YES];
            !self.addOrCancelSellClickedHander ?: self.addOrCancelSellClickedHander();
            [TNGlobalData shared].seller.isNeedRefreshMicroShop = YES;
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.viewController.view dismissLoading];
        }];
}
//取消销售
- (void)cancelSale {
    [self.viewController.view showloading];
    @HDWeakify(self);
    [self.dto cancelProductSaleWithSupplierId:[TNGlobalData shared].seller.supplierId productId:self.viewModel.productDetailsModel.productId success:^{
        @HDStrongify(self);
        [self.viewController.view dismissLoading];
        [self setSellerBtnSelected:NO];
        !self.addOrCancelSellClickedHander ?: self.addOrCancelSellClickedHander();
        [TNGlobalData shared].seller.isNeedRefreshMicroShop = YES;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.viewController.view dismissLoading];
    }];
}

- (void)updateConstraints {
    [self.topLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    [self.storeBtn sizeToFit];
    [self.storeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.centerY.equalTo(self.mas_top).offset(25);
    }];
    [self.customerBtn sizeToFit];
    [self.customerBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.storeBtn.mas_centerX).offset(40);
        make.centerY.equalTo(self.storeBtn.mas_centerY);
    }];
    [self.btnsStackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.customerBtn.mas_right).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(kRealWidth(36));
        make.centerY.equalTo(self.storeBtn.mas_centerY);
    }];
    [super updateConstraints];
}
/** @lazy addShoppingCartBtn */
- (SAOperationButton *)addShoppingCartBTN {
    if (!_addShoppingCartBTN) {
        _addShoppingCartBTN = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        _addShoppingCartBTN.cornerRadius = 0;
        [_addShoppingCartBTN setTitle:TNLocalizedString(@"tn_add_cart", @"加入购物车") forState:UIControlStateNormal];
        [_addShoppingCartBTN setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _addShoppingCartBTN.titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:12];
        _addShoppingCartBTN.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_addShoppingCartBTN applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.C2];
        @HDWeakify(self);
        [_addShoppingCartBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.addCartButtonClickedHander) {
                self.addCartButtonClickedHander();
            }
        }];
        _addShoppingCartBTN.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft radius:18];
        };
    }
    return _addShoppingCartBTN;
}
/** @lazy buyNowBtn */
- (SAOperationButton *)buyNowBtn {
    if (!_buyNowBtn) {
        _buyNowBtn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_buyNowBtn setTitle:TNLocalizedString(@"tn_buynow", @"立即购买") forState:UIControlStateNormal];
        [_buyNowBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _buyNowBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:12];
        _buyNowBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        _buyNowBtn.cornerRadius = 0;
        [_buyNowBtn applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.C1];
        @HDWeakify(self);
        _buyNowBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            @HDStrongify(self);
            if (self.viewModel.productDetailsModel.goodsLimitBuy) {
                [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft radius:18];
            }
        };
        [_buyNowBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.buyNowButtonClickedHander) {
                self.buyNowButtonClickedHander();
            }
        }];
        //        _buyNowBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        //            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft radius:18];
        //        };
    }
    return _buyNowBtn;
}
/** @lazy soldOutBtn */
- (SAOperationButton *)soldOutBtn {
    if (!_soldOutBtn) {
        _soldOutBtn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_soldOutBtn setTitle:TNLocalizedString(@"tn_out_sold", @"缺货") forState:UIControlStateNormal];
        [_soldOutBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _soldOutBtn.titleLabel.font = HDAppTheme.TinhNowFont.standard15;
        _soldOutBtn.disableBackgroundColor = HDAppTheme.TinhNowColor.G3;
        _soldOutBtn.enabled = NO;
    }
    return _soldOutBtn;
}

/** @lazy buyNowBtn */
- (SAOperationButton *)addSellBtn {
    if (!_addSellBtn) {
        _addSellBtn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        _addSellBtn.cornerRadius = 0;
        [_addSellBtn setTitle:TNLocalizedString(@"3Sfc8II1", @"加入销售") forState:UIControlStateNormal];
        [_addSellBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _addSellBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:12];
        _addSellBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        @HDWeakify(self);
        [_addSellBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.viewModel.productDetailsModel.isJoinSales) { //已经加入销售了
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
        _addSellBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopRight | UIRectCornerBottomRight radius:18];
        };
    }
    return _addSellBtn;
}
/** @lazy storeBtn */
- (HDUIButton *)storeBtn {
    if (!_storeBtn) {
        _storeBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_storeBtn setImagePosition:HDUIButtonImagePositionTop];
        [_storeBtn setImage:[UIImage imageNamed:@"tinhnow_product_store"] forState:UIControlStateNormal];
        [_storeBtn setTitle:TNLocalizedString(@"tn_product_store", @"Store") forState:UIControlStateNormal];
        _storeBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontRegular:11.f];
        [_storeBtn setTitleColor:HDAppTheme.TinhNowColor.G2 forState:UIControlStateNormal];
        @HDWeakify(self);
        [_storeBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"商品详情页_点击底部店铺"]];
            [[HDMediator sharedInstance] navigaveToTinhNowStoreInfoViewController:@{@"isFromProductCenter": @"1", @"sp": self.viewModel.sp, @"storeNo": self.viewModel.productDetailsModel.storeNo}];
        }];
    }
    return _storeBtn;
}
/** @lazy customerBtn */
- (HDUIButton *)customerBtn {
    if (!_customerBtn) {
        _customerBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_customerBtn setImagePosition:HDUIButtonImagePositionTop];
        [_customerBtn setImage:[UIImage imageNamed:@"tn_customer_service"] forState:UIControlStateNormal];
        [_customerBtn setTitle:TNLocalizedString(@"tn_product_customer", @"客服") forState:UIControlStateNormal];
        _customerBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontRegular:11.f];
        [_customerBtn setTitleColor:HDAppTheme.TinhNowColor.G2 forState:UIControlStateNormal];
        [_customerBtn addTarget:self action:@selector(showPopMenu:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _customerBtn;
}

/** @lazy topLine */
- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = HDAppTheme.TinhNowColor.G4;
    }
    return _topLine;
}
/** @lazy btnsStackView */
- (UIStackView *)btnsStackView {
    if (!_btnsStackView) {
        _btnsStackView = [[UIStackView alloc] init];
        _btnsStackView.axis = UILayoutConstraintAxisHorizontal;
        _btnsStackView.spacing = 0;
        _btnsStackView.distribution = UIStackViewDistributionFillEqually;
        _btnsStackView.alignment = UIStackViewAlignmentCenter;
    }
    return _btnsStackView;
}
/** @lazy dto */
- (TNMicroShopDTO *)dto {
    if (!_dto) {
        _dto = [[TNMicroShopDTO alloc] init];
    }
    return _dto;
}
@end
