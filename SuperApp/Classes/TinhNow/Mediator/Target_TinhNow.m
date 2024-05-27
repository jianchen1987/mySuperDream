//
//  Target_TinhNow.m
//  SuperApp
//
//  Created by seeu on 2020/6/22.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "Target_TinhNow.h"
#import "SAMessageCenterViewController.h"
#import "SAMyCouponsViewController.h"
#import "TNBargainActivityViewController.h"
#import "TNBargainDetailViewController.h"
#import "TNBargainMyRecordViewController.h"
#import "TNBargainProductDetailViewController.h"
#import "TNChooseCouponViewController.h"
#import "TNContactCustomerServiceViewController.h"
#import "TNDeliveryAreaMapViewController.h"
#import "TNExpressDetailsViewController.h"
#import "TNExpressTrackingViewController.h"
#import "TNGetTinhNowUserDiffRspModel.h"
#import "TNGlobalData.h"
#import "TNGoodReviewViewController.h"
#import "TNHelpBargainViewController.h"
#import "TNHomeViewController.h"
#import "TNIncomeDetailViewController.h"
#import "TNIncomeViewController.h"
#import "TNMyFavoritesViewController.h"
#import "TNMyReviewViewController.h"
#import "TNNewIncomeDTO.h"
#import "TNOrderDetailsViewController.h"
#import "TNOrderSubmitViewController.h"
#import "TNOrderViewController.h"
#import "TNPictureSearchViewController.h"
#import "TNPreIncomeRecordViewController.h"
#import "TNProductCenterViewController.h"
#import "TNProductDetailsViewController.h"
#import "TNRefundDetailViewController.h"
#import "TNRefundViewController.h"
#import "TNSearchViewController.h"
#import "TNSellerApplyViewController.h"
#import "TNSellerSearchViewController.h"
#import "TNSellerTabBarViewController.h"
#import "TNShoppingCarViewController.h"
#import "TNSpecialActivityViewController.h"
#import "TNStoreInfoViewController.h"
#import "TNSubmitReviewController.h"
#import "TNTelegramGroupViewController.h"
#import "TNTransferViewController.h"
#import "TNWithdrawBindViewController.h"
#import "TNWithdrawDetailViewController.h"
#import "UIView+NAT.h"


@implementation _Target (TinhNow)
/// 搜索
- (void)_Action(SearchPage):(NSDictionary *)params {
    TNSearchViewController *vc = [[TNSearchViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params addBusinessHomePage:SAClientTypeTinhNow];
    //    [SAWindowManager navigateToViewController:vc parameters:params];
}

// 门店详情
- (void)_Action(StoreInfo):(NSDictionary *)params {
    TNStoreInfoViewController *vc = [[TNStoreInfoViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params addBusinessHomePage:SAClientTypeTinhNow];
    //    [SAWindowManager navigateToViewController:vc parameters:params];
}

// 订单提交
- (void)_Action(OrderSubmit):(NSDictionary *)params {
    TNOrderSubmitViewController *vc = [[TNOrderSubmitViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

// 购物车
- (void)_Action(ShoppingCar):(NSDictionary *)params {
    TNShoppingCarViewController *vc = [[TNShoppingCarViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

// 商品详情
- (void)_Action(productDetails):(NSDictionary *)params {
    TNProductDetailsViewController *vc = [[TNProductDetailsViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params addBusinessHomePage:SAClientTypeTinhNow];
    //    [SAWindowManager navigateToViewController:vc parameters:params];
}

// 门店介绍
- (void)_Action(storeDetails):(NSDictionary *)params {
    NSString *storeNo = [params objectForKey:@"storeNo"];
    if (HDIsStringEmpty(storeNo)) {
        return;
    }
    NSString *url = [[SAAppEnvManager sharedInstance].appEnvConfig.tinhNowHost stringByAppendingFormat:@"%@%@", kTinhNowStoreDetails, storeNo];
    [SAWindowManager openUrl:url withParameters:nil];
}

// 订单评价
- (void)_Action(uploadReview):(NSDictionary *)params {
    TNSubmitReviewController *vc = [[TNSubmitReviewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

// 订单详情
- (void)_Action(orderDetail):(NSDictionary *)params {
    TNOrderDetailsViewController *vc = [[TNOrderDetailsViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

// 商品评论详情
- (void)_Action(prductReviewDetials):(NSDictionary *)params {
    TNGoodReviewViewController *vc = [[TNGoodReviewViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

// 我的评论
- (void)_Action(myReviews):(NSDictionary *)params {
    TNMyReviewViewController *vc = [[TNMyReviewViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

// 商品专题  必须带参数  活动ID
- (void)_Action(specialActivity):(NSDictionary *)params {
    TNSpecialActivityViewController *vc = [[TNSpecialActivityViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params addBusinessHomePage:SAClientTypeTinhNow];
    //    [SAWindowManager navigateToViewController:vc parameters:params];
}

// 红区专题
- (void)_Action(redZoneSpecialActivity):(NSDictionary *)params {
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [newParams setValue:@(TNSpecialActivityTypeRedZone) forKey:@"type"];
    TNSpecialActivityViewController *vc = [[TNSpecialActivityViewController alloc] initWithRouteParameters:newParams];
    [SAWindowManager navigateToViewController:vc parameters:params addBusinessHomePage:SAClientTypeTinhNow];
    //    [SAWindowManager navigateToViewController:vc parameters:params];
}

// 助力砍价活动列表
- (void)_Action(helpActivity):(NSDictionary *)params {
    TNBargainActivityViewController *vc = [[TNBargainActivityViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

// 我的助力砍价记录
- (void)_Action(myBargainRecord):(NSDictionary *)params {
    TNBargainMyRecordViewController *vc = [[TNBargainMyRecordViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

// 选择优惠券页面
- (void)_Action(chooseCoupon):(NSDictionary *)params {
    TNChooseCouponViewController *vc = [[TNChooseCouponViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

// 运单详情
- (void)_Action(expressDetails):(NSDictionary *)params {
    TNExpressDetailsViewController *vc = [[TNExpressDetailsViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

// 帮砍价页面
- (void)_Action(helpFriend):(NSDictionary *)params {
    TNHelpBargainViewController *vc = [[TNHelpBargainViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

// 申请退款
- (void)_Action(applyRefund):(NSDictionary *)params {
    TNRefundViewController *vc = [[TNRefundViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

// 退款详情
- (void)_Action(refundDetail):(NSDictionary *)params {
    TNRefundDetailViewController *vc = [[TNRefundDetailViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

// 转账付款
- (void)_Action(transfer):(NSDictionary *)params {
    TNTransferViewController *vc = [[TNTransferViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

// 砍价详情
- (void)_Action(bargainDetail):(NSDictionary *)params {
    TNBargainDetailViewController *vc = [[TNBargainDetailViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

// 砍价商品详情  历史原因 砍价详情剥离了 路由未改
- (void)_Action(bargainProductDetail):(NSDictionary *)params {
    TNBargainProductDetailViewController *vc = [[TNBargainProductDetailViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params addBusinessHomePage:SAClientTypeTinhNow];
}
// 砍价商品专题
- (void)_Action(helpSpecialActivity):(NSDictionary *)params {
    TNBargainActivityViewController *vc = [[TNBargainActivityViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params addBusinessHomePage:SAClientTypeTinhNow];
}
//消息中心
- (void)_Action(message):(NSDictionary *)params {
    SAMessageCenterViewController *vc = [[SAMessageCenterViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}
// 电商优惠券列表 -- 另外开一个路由打开电商优惠券列表
- (void)_Action(myCoupon):(NSDictionary *)params {
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [newParams setValue:@"TinhNow" forKey:@"businessLine"];

    SAMyCouponsViewController *vc = [[SAMyCouponsViewController alloc] initWithRouteParameters:newParams];
    [SAWindowManager navigateToViewController:vc parameters:newParams];
}
// 物流跟踪路由
- (void)_Action(expressTracking):(NSDictionary *)params {
    TNExpressTrackingViewController *vc = [[TNExpressTrackingViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params addBusinessHomePage:SAClientTypeTinhNow];
}
// 我的收藏
- (void)_Action(myFavorites):(NSDictionary *)params {
    TNMyFavoritesViewController *vc = [[TNMyFavoritesViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params addBusinessHomePage:SAClientTypeTinhNow];
}
// 首页
- (void)_Action(home):(NSDictionary *)params {
    TNHomeViewController *vc = [[TNHomeViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}
// 配送区域地图
- (void)_Action(deliveryAreaMap):(NSDictionary *)params {
    TNDeliveryAreaMapViewController *vc = [[TNDeliveryAreaMapViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}
// 供销页面
- (void)_Action(SupplyAndMarketingShop):(NSDictionary *)params {
    TNSellerTabBarViewController *vc = [[TNSellerTabBarViewController alloc] init];
    [SAWindowManager navigateToViewController:vc parameters:params addBusinessHomePage:SAClientTypeTinhNow];
}
// 选品中心页面
- (void)_Action(ProductCenter):(NSDictionary *)params {
    TNProductCenterViewController *vc = [[TNProductCenterViewController alloc] init];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

// 卖家搜索页面
- (void)_Action(SellerSearch):(NSDictionary *)params {
    TNSellerSearchViewController *vc = [[TNSellerSearchViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}
// 卖家申请页面
- (void)_Action(SellerApply):(NSDictionary *)params {
    //根据开关判断是否要开启钱包验证
    if ([TNGlobalData shared].isNeedGobackSupplierIncomePage) {
        //回退旧版本
        TNSellerApplyViewController *vc = [[TNSellerApplyViewController alloc] init];
        [SAWindowManager navigateToViewController:vc parameters:params];
    } else {
        //新版本
        UIView *keyWindow = UIApplication.sharedApplication.keyWindow;
        [keyWindow showloading];
        TNNewIncomeDTO *dto = [[TNNewIncomeDTO alloc] init];
        [dto queryCheckUserOpenedSuccess:^(TNCheckWalletOpenedModel *_Nonnull model) {
            [keyWindow dismissLoading];
            //用户必须开通钱包以及实名认证才能用微店
            if (model.walletCreated && model.isVerifiedRealName) {
                TNSellerApplyViewController *vc = [[TNSellerApplyViewController alloc] init];
                [SAWindowManager navigateToViewController:vc parameters:params];
            } else {
                [NAT showAlertWithMessage:TNLocalizedString(@"m4qB6RZi", @"申请卖家之前，需开通wownow钱包和实名认证，方便收益及时打到您的钱包") buttonTitle:TNLocalizedString(@"bYACqNTz", @"去开通")
                                  handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                      [alertView dismiss];
                                      [SAWindowManager openUrl:@"SuperApp://SuperApp/wallet" withParameters:@{}];
                                  }];
            }
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            [keyWindow dismissLoading];
        }];
    }
}

///预估收入记录
- (void)_Action(PreIncomeRecord):(NSDictionary *)params {
    if ([TNGlobalData shared].isNeedGobackSupplierIncomePage) {
        //回退旧版本
        TNPreIncomeRecordViewController *vc = [[TNPreIncomeRecordViewController alloc] initWithRouteParameters:params];
        [SAWindowManager navigateToViewController:vc parameters:params addBusinessHomePage:SAClientTypeTinhNow];
    } else {
        //新版本 直接去预估收入列表
        TNIncomeViewController *vc = [[TNIncomeViewController alloc] initWithRouteParameters:@{@"isNeedPop": @(YES), @"queryMode": @(2)}];
        [SAWindowManager navigateToViewController:vc parameters:params addBusinessHomePage:SAClientTypeTinhNow];
    }
}

///提现绑定
- (void)_Action(WithdrawBind):(NSDictionary *)params {
    TNWithdrawBindViewController *vc = [[TNWithdrawBindViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

///收益详情
- (void)_Action(IncomeDetail):(NSDictionary *)params {
    TNIncomeDetailViewController *vc = [[TNIncomeDetailViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}
///提现详情
- (void)_Action(WithDrawDetail):(NSDictionary *)params {
    TNWithdrawDetailViewController *vc = [[TNWithdrawDetailViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

///图片搜索
- (void)_Action(PictureSearch):(NSDictionary *)params {
    TNPictureSearchViewController *vc = [[TNPictureSearchViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}
// 我的微店页面
- (void)_Action(myMicroShop):(NSDictionary *)params {
    void (^gotoMyMicroShop)(void) = ^(void) {
        UIView *keyWindow = UIApplication.sharedApplication.keyWindow;
        [keyWindow showloading];

        TNNetworkRequest *request = TNNetworkRequest.new;
        request.retryCount = 1;
        request.requestURI = @"/api/user/supplier/isSupplier";

        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"userName"] = [SAUser shared].loginName;
        request.requestParameter = params;
        [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
            [keyWindow dismissLoading];
            SARspModel *rspModel = response.extraData;
            TNGetTinhNowUserDiffRspModel *model = [TNGetTinhNowUserDiffRspModel yy_modelWithJSON:rspModel.data];
            if (model.supplierFlag) {
                TNSellerTabBarViewController *vc = [[TNSellerTabBarViewController alloc] init];
                [SAWindowManager navigateToViewController:vc parameters:params];
            } else {
                [SAWindowManager openUrl:@"SuperApp://TinhNow/SellerApply" withParameters:@{}];
            }
        } failure:^(HDNetworkResponse *_Nonnull response) {
            [keyWindow dismissLoading];
        }];
    };

    if (![SAUser hasSignedIn]) {
        [SAWindowManager switchWindowToLoginViewControllerWithLoginToDoEvent:gotoMyMicroShop];
        return;
    }

    if ([TNGlobalData shared].seller.isSeller) {
        TNSellerTabBarViewController *vc = [[TNSellerTabBarViewController alloc] init];
        [SAWindowManager navigateToViewController:vc parameters:params];
    } else {
        gotoMyMicroShop();
    }
}

// 砍价商品详情
- (void)_Action(BargainProductDetail):(NSDictionary *)params {
    TNBargainProductDetailViewController *vc = [[TNBargainProductDetailViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params addBusinessHomePage:SAClientTypeTinhNow];
    //    [SAWindowManager navigateToViewController:vc parameters:params];
}

//订单列表
- (void)_Action(orderList):(NSDictionary *)params {
    TNOrderViewController *vc = [[TNOrderViewController alloc] initWithRouteParameters:@{@"isNeedPop": @(YES)}];
    [SAWindowManager navigateToViewController:vc parameters:params addBusinessHomePage:SAClientTypeTinhNow];
}

//卖家收益列表列表
- (void)_Action(sellerIncome):(NSDictionary *)params {
    TNIncomeViewController *vc = [[TNIncomeViewController alloc] initWithRouteParameters:@{@"isNeedPop": @(YES)}];
    [SAWindowManager navigateToViewController:vc parameters:params addBusinessHomePage:SAClientTypeTinhNow];
}
//联系客服页面
- (void)_Action(contactCustomerService):(NSDictionary *)params {
    TNContactCustomerServiceViewController *vc = [[TNContactCustomerServiceViewController alloc] initWithRouteParameters:@{}];
    [SAWindowManager navigateToViewController:vc parameters:params addBusinessHomePage:SAClientTypeTinhNow];
}
// TG群信息页面
- (void)_Action(telegramGroup):(NSDictionary *)params {
    TNTelegramGroupViewController *vc = [[TNTelegramGroupViewController alloc] initWithRouteParameters:@{}];
    [SAWindowManager navigateToViewController:vc parameters:params addBusinessHomePage:SAClientTypeTinhNow];
}

@end
