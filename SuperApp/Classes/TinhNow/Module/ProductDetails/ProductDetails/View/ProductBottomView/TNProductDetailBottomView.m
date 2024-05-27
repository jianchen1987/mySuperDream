//
//  TNProductDetailBottomView.m
//  SuperApp
//
//  Created by seeu on 2020/7/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNProductDetailBottomView.h"
#import "SATalkingData.h"
#import "TNCutomerServicePopCell.h"
#import "TNProductDetailsRspModel.h"
#import "TNProductDetailsViewModel.h"
#import "TNProductSkuModel.h"
#import "TNQueryUserShoppingCarRspModel.h"
#import "TNShoppingCar.h"
#import "TNShoppingCartButton.h"
#import "UIView+Shake.h"
#import "YBPopupMenu.h"
#import <LOTAnimationView.h>
static NSString *kBuyNow = @"buyNow";


@interface TNProductDetailBottomView ()
/// viewModel
@property (nonatomic, strong) TNProductDetailsViewModel *viewModel;
/// 门店按钮
@property (nonatomic, strong) HDUIButton *storeBtn;
/// 客服
@property (nonatomic, strong) HDUIButton *customerServiceBtn;
/// 购物车按钮
@property (strong, nonatomic) TNShoppingCartButton *cartBtn;
/// 按钮容器
@property (nonatomic, strong) UIView *buttonContainer;
/// 加入购物车按钮
@property (nonatomic, strong) SAOperationButton *addShoppingCartBTN;
/// 立即购买
@property (nonatomic, strong) SAOperationButton *buyNowBtn;
/// 缺货
@property (nonatomic, strong) SAOperationButton *soldOutBtn;
/// 数据中心
@property (strong, nonatomic) TNShoppingCar *shopCarDataCenter;
/// 卡片动画图片
@property (strong, nonatomic) LOTAnimationView *animationImageView;

/// 是否能够购买
@property (nonatomic, assign) BOOL soldOutFlag;
/// 顶部线条
@property (nonatomic, strong) UIView *topLine;

/// 门店号
@property (nonatomic, copy) NSString *storeNo;

//是否显示立即购买 + 店铺
@property (nonatomic, copy) NSString *fValue;
@end


@implementation TNProductDetailBottomView
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    self = [super initWithViewModel:viewModel];
    return self;
}

- (void)hd_setupViews {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.topLine];
    [self addSubview:self.storeBtn];
    [self addSubview:self.customerServiceBtn];
    [self addSubview:self.cartBtn];
    [self.cartBtn addSubview:self.animationImageView];
    [self addSubview:self.buttonContainer];
    [self.buttonContainer addSubview:self.addShoppingCartBTN];
    [self.buttonContainer addSubview:self.buyNowBtn];
    [self.buttonContainer addSubview:self.soldOutBtn];

    [self.cartBtn updateIndicatorDotWithCount:self.shopCarDataCenter.totalGoodsCount];
}
/// MARK: 获取购物车的位置
- (CGPoint)getCartButtonPoint {
    CGPoint point = [self convertPoint:self.cartBtn.frame.origin toView:UIApplication.sharedApplication.keyWindow];
    HDLog(@"得到的位置 = %@", NSStringFromCGPoint(point));
    point.x += self.cartBtn.frame.size.width / 2;
    return point;
}
- (void)cartButtonBeginShake {
    [self.animationImageView play];
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

    [TNEventTrackingInstance trackEvent:@"detail_customer" properties:nil];
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
- (void)updateConstraints {
    [self configDefaultStyle];

    [super updateConstraints];
}

- (void)configDefaultStyle {
    [self.topLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];

    [self.storeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(50), 50));
    }];
    [self.customerServiceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.storeBtn.mas_right);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(50), 50));
    }];

    [self.cartBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.customerServiceBtn.mas_right);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(50), 50));
    }];

    [self.animationImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self.cartBtn);
        //        make.bottom.equalTo(self.cartBtn.titleLabel.mas_top);
        make.width.equalTo(self.animationImageView.mas_height);
    }];

    [self.buttonContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cartBtn.mas_right).offset(kRealWidth(10));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(10));
        make.height.mas_equalTo(kRealWidth(35));
        make.centerY.equalTo(self.storeBtn.mas_centerY);
    }];

    if (self.soldOutFlag) {
        [self.soldOutBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.buttonContainer);
        }];
    } else {
        if (self.viewModel.productDetailsModel.goodsLimitBuy) {
            [self.buyNowBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.buttonContainer);
            }];
        } else {
            [self.addShoppingCartBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self.buttonContainer);
                make.width.equalTo(self.buyNowBtn.mas_width);
            }];
            [self.buyNowBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.right.equalTo(self.buttonContainer);
                make.left.equalTo(self.addShoppingCartBTN.mas_right).offset(kRealWidth(5));
            }];
        }
    }
}

#pragma mark
- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self refreshViewWithModel:self.viewModel.productDetailsModel];
    }];

    [self.KVOController hd_observe:self.shopCarDataCenter keyPath:@"totalGoodsCount" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self.cartBtn updateIndicatorDotWithCount:self.shopCarDataCenter.totalGoodsCount];
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

    self.storeNo = model.storeNo;
    if (self.soldOutFlag) {
        [self.addShoppingCartBTN setHidden:YES];
        [self.buyNowBtn setHidden:YES];
        [self.soldOutBtn setHidden:NO];
    } else {
        //有库存的情况下 还要判断商品是否是限购商品  如果是限购商品  只提供立即购买功能  隐藏加入购物车逻辑
        if (model.goodsLimitBuy) {
            [self.addShoppingCartBTN setHidden:YES];
            [self.buyNowBtn setHidden:NO];
            [self.soldOutBtn setHidden:YES];
        } else {
            [self.addShoppingCartBTN setHidden:NO];
            [self.buyNowBtn setHidden:NO];
            [self.soldOutBtn setHidden:YES];

            // 确认 fValue 是否为 buyNow 则只显示立即购买
            if ([self.fValue isEqualToString:kBuyNow]) {
                [self.addShoppingCartBTN setHidden:YES];
            }
        }
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
/** @lazy topLine */
- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = HDAppTheme.TinhNowColor.G4;
    }
    return _topLine;
}
/** @lazy storeBtn */
- (HDUIButton *)storeBtn {
    if (!_storeBtn) {
        _storeBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_storeBtn setImagePosition:HDUIButtonImagePositionTop];
        [_storeBtn setImage:[UIImage imageNamed:@"tn_product_bottom_store"] forState:UIControlStateNormal];
        [_storeBtn setTitle:TNLocalizedString(@"tn_product_store", @"Store") forState:UIControlStateNormal];
        _storeBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontRegular:11.f];
        [_storeBtn setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        @HDWeakify(self);
        [_storeBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"商品详情页_点击底部店铺"]];

            //进店逛逛埋点
            [TNEventTrackingInstance trackEvent:@"detail_store" properties:@{@"productId": self.viewModel.productId, @"storeId": self.viewModel.productDetailsModel.storeProductInfo.storeId}];

            if (self.viewModel.detailViewStyle == TNProductDetailViewTypeNomal) {
                [HDMediator.sharedInstance navigaveToTinhNowStoreInfoViewController:@{@"storeNo": self.viewModel.productDetailsModel.storeNo}];
            } else if (self.viewModel.detailViewStyle == TNProductDetailViewTypeSupplyAndMarketing) {
                [[HDMediator sharedInstance] navigaveToTinhNowStoreInfoViewController:@{@"isFromProductCenter": @"1", @"storeNo": self.viewModel.productDetailsModel.storeNo}];
            } else if (self.viewModel.detailViewStyle == TNProductDetailViewTypeMicroShop) {
                [[HDMediator sharedInstance] navigaveToTinhNowStoreInfoViewController:@{@"sp": self.viewModel.sp, @"storeNo": self.viewModel.productDetailsModel.storeNo}];
            }
        }];
    }
    return _storeBtn;
}

/** @lazy customerServiceBtn */
- (HDUIButton *)customerServiceBtn {
    if (!_customerServiceBtn) {
        _customerServiceBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_customerServiceBtn setImagePosition:HDUIButtonImagePositionTop];
        [_customerServiceBtn setImage:[UIImage imageNamed:@"tn_product_bottom_customer"] forState:UIControlStateNormal];
        [_customerServiceBtn setTitle:TNLocalizedString(@"tn_product_customer", @"Customer") forState:UIControlStateNormal];
        _customerServiceBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontRegular:11.f];
        [_customerServiceBtn setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        [_customerServiceBtn addTarget:self action:@selector(showPopMenu:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _customerServiceBtn;
}

/** @lazy buttonContainer */
- (UIView *)buttonContainer {
    if (!_buttonContainer) {
        _buttonContainer = [[UIView alloc] init];
    }
    return _buttonContainer;
}
/** @lazy addShoppingCartBtn */
- (SAOperationButton *)addShoppingCartBTN {
    if (!_addShoppingCartBTN) {
        _addShoppingCartBTN = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        _addShoppingCartBTN.cornerRadius = 0;
        [_addShoppingCartBTN setTitle:TNLocalizedString(@"tn_add_cart", @"加入购物车") forState:UIControlStateNormal];
        [_addShoppingCartBTN setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _addShoppingCartBTN.titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:11];
        _addShoppingCartBTN.titleLabel.adjustsFontSizeToFitWidth = YES;
        _addShoppingCartBTN.titleEdgeInsets = UIEdgeInsetsMake(kRealHeight(2), kRealWidth(5), kRealHeight(2), kRealWidth(5));
        [_addShoppingCartBTN applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.C2];
        @HDWeakify(self);
        [_addShoppingCartBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.addCartButtonClickedHander) {
                self.addCartButtonClickedHander();
            }
        }];
        _addShoppingCartBTN.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.height / 2.0f];
        };
    }
    return _addShoppingCartBTN;
}
/** @lazy buyNowBtn */
- (SAOperationButton *)buyNowBtn {
    if (!_buyNowBtn) {
        _buyNowBtn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        _buyNowBtn.cornerRadius = 0;
        [_buyNowBtn setTitle:TNLocalizedString(@"tn_buynow", @"立即购买") forState:UIControlStateNormal];
        [_buyNowBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _buyNowBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:11];
        _buyNowBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        _buyNowBtn.titleEdgeInsets = UIEdgeInsetsMake(kRealHeight(2), kRealWidth(5), kRealHeight(2), kRealWidth(5));
        [_buyNowBtn applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.C1];
        @HDWeakify(self);
        [_buyNowBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.buyNowButtonClickedHander) {
                self.buyNowButtonClickedHander();
            }
        }];
        _buyNowBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.height / 2.0f];
        };
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
        _soldOutBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.height / 2.0f];
        };
    }
    return _soldOutBtn;
}
/** @lazy cartBtn */
- (TNShoppingCartButton *)cartBtn {
    if (!_cartBtn) {
        _cartBtn = [TNShoppingCartButton buttonWithType:UIButtonTypeCustom];
        [_cartBtn setImagePosition:HDUIButtonImagePositionTop];
        [_cartBtn setImage:[UIImage imageNamed:@"tn_product_bottom_cart"] forState:UIControlStateNormal];
        [_cartBtn setTitle:TNLocalizedString(@"tn_product_cart", @"购物车") forState:UIControlStateNormal];
        _cartBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontRegular:11.f];
        [_cartBtn setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        _cartBtn.indicatorFont = [HDAppTheme.TinhNowFont fontMedium:8];
        _cartBtn.offsetY = 9;
        _cartBtn.offsetX = 12;
        _cartBtn.edgeInsets = UIEdgeInsetsMake(1.5, 1.5, 1.5, 1.5);
        UIView *maskView = [[UIView alloc] init];
        maskView.backgroundColor = [UIColor whiteColor];
        [_cartBtn.imageView addSubview:maskView];

        @HDWeakify(self);
        [_cartBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"商品详情页_点击购物车"]];

            //点击购物车埋点
            [TNEventTrackingInstance trackEvent:@"detail_cart" properties:@{@"productId": self.viewModel.productId}];

            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            if (HDIsStringNotEmpty(self.viewModel.salesType)) {
                dict[@"tab"] = self.viewModel.salesType;
            }
            [SAWindowManager openUrl:@"SuperApp://TinhNow/ShoppingCar" withParameters:dict];
        }];
        _cartBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            maskView.frame = view.bounds;
        };
        _cartBtn.imageView.hidden = NO;
    }
    return _cartBtn;
}
/** @lazy shopCarDataCenter */
- (TNShoppingCar *)shopCarDataCenter {
    if (!_shopCarDataCenter) {
        _shopCarDataCenter = [TNShoppingCar share];
    }
    return _shopCarDataCenter;
}
/** @lazy animationImageView */
- (LOTAnimationView *)animationImageView {
    if (!_animationImageView) {
        _animationImageView = [LOTAnimationView animationNamed:@"productCartShake"];
        _animationImageView.loopAnimation = NO;
        _animationImageView.cacheEnable = YES;
        _animationImageView.userInteractionEnabled = NO;
    }
    return _animationImageView;
}
@end
