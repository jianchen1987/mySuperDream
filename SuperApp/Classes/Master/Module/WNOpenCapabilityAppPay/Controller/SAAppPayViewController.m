//
//  SAAppPayViewController.m
//  SuperApp
//
//  Created by seeu on 2021/11/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAAppPayViewController.h"
#import "HDCheckStandViewController.h"
#import "SAAppPayInitModel.h"
#import "SAAppPayReqDetailModel.h"
#import "SAAppPayResultViewController.h"
#import "SAMoneyModel.h"
#import "SANavigationController.h"
#import "SAOpenCapabilityAppPayPresenter.h"
#import "SAOpenCapabilityDTO.h"
#import "SAPaymentDetailsRspModel.h"


@implementation SAAppPayReqModel

@end


@interface SAAppPayViewController () <HDCheckStandViewControllerDelegate>
@property (nonatomic, strong) HDUIButton *closeBtn;                ///< 关闭按钮
@property (nonatomic, strong) UILabel *orderDescLabel;             ///< 订单描述
@property (nonatomic, strong) UIImageView *loadingIV;              ///< 加载框
@property (nonatomic, strong) UILabel *merInfoLabel;               ///< 商户信息
@property (nonatomic, strong) UILabel *productInfoLabel;           ///< 商品信息
@property (nonatomic, strong) UIImageView *bgPlaceHolderImageView; ///< 背景占位图

@property (nonatomic, strong) SAAppPayReqModel *model;                  ///< 支付请求
@property (nonatomic, strong) SAPaymentDetailsRspModel *paymentDetails; ///< 支付详情

@property (nonatomic, strong) SAOpenCapabilityDTO *openCapabilityDto; ///<

@property (nonatomic, copy) NSString *secretKey; ///< 密钥
@end

UIWindow *__appPayWindow = nil;


@implementation SAAppPayViewController

- (void)hd_setupViews {
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.orderDescLabel];
    [self.view addSubview:self.loadingIV];
    [self.view addSubview:self.merInfoLabel];
    [self.view addSubview:self.productInfoLabel];
    [self.view addSubview:self.bgPlaceHolderImageView];
    [self.loadingIV startAnimating];
    [self initPayment];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(loginSuccessHandler) name:kNotificationNameLoginSuccess object:nil];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLoginSuccess object:nil];
}

- (void)hd_setupNavigation {
    self.hd_navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeBtn];
    if (@available(iOS 13.0, *)) {
        self.hd_statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        self.hd_statusBarStyle = UIStatusBarStyleDefault;
    }
}
- (void)hd_languageDidChanged {
    [self setBoldTitle:SALocalizedString(@"app_pay_onlne", @"在线支付")];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)updateViewConstraints {
    if (!self.orderDescLabel.isHidden) {
        [self.orderDescLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(15);
            make.right.equalTo(self.view.mas_right).offset(-15);
            make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(47);
        }];
    }

    if (!self.loadingIV.isHidden) {
        [self.loadingIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.orderDescLabel.mas_bottom).offset(16);
            make.centerX.equalTo(self.view);
        }];
    }

    if (!self.merInfoLabel.isHidden) {
        [self.merInfoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(15);
            make.right.equalTo(self.view.mas_right).offset(-15);
            make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(47);
        }];
    }

    if (!self.productInfoLabel.isHidden) {
        [self.productInfoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(15);
            make.right.equalTo(self.view.mas_right).offset(-15);
            make.top.equalTo(self.merInfoLabel.mas_bottom).offset(15);
        }];
    }

    [self.bgPlaceHolderImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.equalTo(self.view.mas_left).offset(72);
        make.bottom.equalTo(self.view.mas_bottom).offset(-140);
    }];
    [super updateViewConstraints];
}

#pragma mark - Action
- (void)close {
    [self notifyMerchantWithErrorCode:-2 errorMessage:@"usercancel" extend:nil];
}

#pragma mark - public methods
- (void)payWithReqModel:(SAAppPayReqModel *)model {
    self.model = model;
    SANavigationController *nav = [SANavigationController rootVC:self];
    UIViewController *vc = [SAWindowManager visibleViewController];
    if (vc) {
        [vc presentViewController:nav animated:YES completion:nil];
    } else {
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        window.opaque = NO;
        window.rootViewController = nav;
        // 确保最顶层显示
        window.windowLevel = HDActionAlertViewWindowLevel - 10;
        __appPayWindow = window;
        [__appPayWindow makeKeyAndVisible];
    }
}

#pragma mark - private methods
- (void)initPayment {
    @HDWeakify(self);
    [self queryOrderDetails:self.model completion:^(SAAppPayInitModel *_Nullable model, SARspModel *_Nullable rspModel, NSError *error) {
        @HDStrongify(self);
        [self.loadingIV stopAnimating];
        if (model) {
            self.merInfoLabel.text = model.merchantName;
            self.productInfoLabel.text = model.remark.desc;
            self.merInfoLabel.hidden = NO;
            self.productInfoLabel.hidden = NO;

            self.orderDescLabel.hidden = YES;
            self.loadingIV.hidden = YES;
            [self.view setNeedsUpdateConstraints];
            // 拉起支付
            [self payOrderWithOrderDetails:model];
        } else {
            [NAT showToastWithTitle:@"" content:error ? error.domain : rspModel.msg type:HDTopToastTypeError];
        }
    }];
}
- (void)dismissAndCallBack:(NSString *)callBack {
    void (^notifyMerchant)(void) = ^void(void) {
        NSString *schema = [NSString stringWithFormat:@"WN%@://WOWNOWOpenCapability.com%@", self.model.appId, callBack];
        NSURL *callBackUrl = [NSURL URLWithString:schema];
        HDLog(@"call back :%@", callBackUrl.absoluteString);
        [UIApplication.sharedApplication openURL:callBackUrl options:@{} completionHandler:^(BOOL success) {
            HDLog(@"call back :%@", @(success));
        }];
    };

    if (self.navigationController.presentingViewController) {
        [self.navigationController dismissAnimated:YES completion:^{
            __appPayWindow = nil;
            notifyMerchant();
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            __appPayWindow.top = UIScreen.mainScreen.bounds.size.height;
        } completion:^(BOOL finished) {
            // 使原来的 rootViewController 释放
            __appPayWindow = nil;
            notifyMerchant();
        }];
    }
}

- (void)notifyMerchantWithErrorCode:(NSInteger)errCode errorMessage:(NSString *_Nullable)errMsg extend:(NSDictionary *_Nullable)extend {
    NSString *callBackStr = [NSString stringWithFormat:@"?type=%@&errCode=%zd", WNOpenCapabilityAppPay, errCode];
    if (HDIsStringNotEmpty(errMsg)) {
        callBackStr = [callBackStr stringByAppendingFormat:@"&errStr=%@", errMsg];
    }

    NSMutableDictionary *body = [[NSMutableDictionary alloc] initWithCapacity:4];
    [body addEntriesFromDictionary:@{
        @"bizOrderNo": self.paymentDetails.bizOrderNo,
        @"payOrderNo": self.paymentDetails.payOrderNo,
        @"payAmount": self.paymentDetails.actualPayAmount.cent,
        @"currency": self.paymentDetails.currency
    }];
    if (extend) {
        [body addEntriesFromDictionary:extend];
    }
    NSString *bodyJsonStr = [body yy_modelToJSONString];
    HDLog(@"返回body:%@", bodyJsonStr);
    NSString *secretTex = [bodyJsonStr hd_AESEncryptWithKey:self.secretKey];
    HDLog(@"body密文:%@", secretTex);
    callBackStr = [callBackStr stringByAppendingFormat:@"&body=%@", secretTex];

    [self dismissAndCallBack:callBackStr];
}

- (void)payOrderWithOrderDetails:(SAAppPayInitModel *)model {
    HDTradeBuildOrderModel *buildModel = [HDTradeBuildOrderModel new];
    buildModel.orderNo = model.aggregateOrderNo;
    buildModel.outPayOrderNo = model.outPayOrderNo;
    buildModel.payableAmount = model.actualPayAmount;
    buildModel.businessLine = model.businessLine;
    buildModel.merchantNo = model.merchantNo;
    HDCheckStandViewController *checkStandVC = [[HDCheckStandViewController alloc] initWithTradeBuildModel:buildModel preferedHeight:0];
    checkStandVC.resultDelegate = self;

    [self presentViewController:checkStandVC animated:YES completion:nil];
}

- (void)gotoResultPage {
    @HDWeakify(self);

    void (^backToMerchantBlock)(SAQueryPaymentStateRspModel *) = ^void(SAQueryPaymentStateRspModel *result) {
        @HDStrongify(self);

        if (!result) {
            [self notifyMerchantWithErrorCode:-1 errorMessage:@"error" extend:nil];
        } else {
            [self notifyMerchantWithErrorCode:0 errorMessage:@"success" extend:@{@"status": @(result.payState)}];
        }
    };

    SAAppPayResultViewController *vc = SAAppPayResultViewController.new;
    vc.clickedCompleteHandler = backToMerchantBlock;
    vc.clickedBackToMerchantHandler = backToMerchantBlock;
    vc.payOrderNo = self.paymentDetails.payOrderNo;
    [self.navigationController pushViewController:vc animated:YES];
}
// 登陆成功，重新发起
- (void)loginSuccessHandler {
    [self initPayment];
}

#pragma mark - DATA
- (void)queryOrderDetails:(SAAppPayReqModel *)reqModel completion:(void (^)(SAAppPayInitModel *_Nullable model, SARspModel *_Nullable rspModel, NSError *error))completion {
    @HDWeakify(self);
    [self.openCapabilityDto queryAppSecretKeyWithAppId:reqModel.appId success:^(SAQueryAppSecretKeyRspModel *rspModel) {
        @HDStrongify(self);
        if (HDIsStringEmpty(rspModel.secretKey)) {
            completion(nil, nil, [NSError errorWithDomain:@"密钥为空，请检查AppId是否正确" code:999999 userInfo:nil]);
            return;
        }
        self.secretKey = rspModel.secretKey;
        NSString *planText = [self.model.body hd_AESDecryptWithKey:rspModel.secretKey];
        if (HDIsStringEmpty(planText)) {
            !completion ?: completion(nil, nil, [NSError errorWithDomain:@"解密失败，请检查AppId是否正确" code:999999 userInfo:nil]);
            return;
        }
        SAAppPayReqDetailModel *details = [SAAppPayReqDetailModel yy_modelWithJSON:planText];
        if (!details) {
            !completion ?: completion(nil, nil, [NSError errorWithDomain:@"数据解析异常" code:999999 userInfo:nil]);
            return;
        }
        SAAppPayInitModel *infoModel = SAAppPayInitModel.new;

        [self getOrderDetailsWithModel:details infoModel:infoModel completion:completion];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion(nil, rspModel, error);
    }];
}

- (void)getOrderDetailsWithModel:(SAAppPayReqDetailModel *)details
                       infoModel:(SAAppPayInitModel *)infoModel
                      completion:(void (^)(SAAppPayInitModel *_Nullable model, SARspModel *_Nullable rep, NSError *error))completion {
    @HDWeakify(self);

    void (^successBlock)(SAPaymentDetailsRspModel *) = ^void(SAPaymentDetailsRspModel *rspModel) {
        @HDStrongify(self);
        self.paymentDetails = rspModel;
        infoModel.outPayOrderNo = rspModel.outPayOrderNo;
        infoModel.actualPayAmount = rspModel.actualPayAmount;
        infoModel.businessLine = rspModel.businessLine;
        infoModel.remark = rspModel.remark;
        infoModel.aggregateOrderNo = rspModel.aggregateOrderNo;
        infoModel.merchantNo = rspModel.merchantNo;
        [self getMerchantInfoWithMerchantNo:details.merchantNo infoModel:infoModel completion:completion];
    };

    void (^failureBlock)(SARspModel *_Nullable, CMResponseErrorType, NSError *_Nullable) = ^void(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion(nil, rspModel, error);
    };

    if (HDIsStringNotEmpty(details.orderNo)) {
        [self.openCapabilityDto queryPaymentInfoWithOrderNo:details.orderNo sign:details.sign success:successBlock failure:failureBlock];
    } else {
        // 兼容老逻辑
        [self.openCapabilityDto queryPaymentInfoWithPayOrderNo:details.payOrderNo sign:details.sign success:successBlock failure:failureBlock];
    }
}

/// 获取商户信息
/// @param merchant 商户号
/// @param infoModel 回传模型
/// @param completion 完成回调
- (void)getMerchantInfoWithMerchantNo:(NSString *)merchant
                            infoModel:(SAAppPayInitModel *)infoModel
                           completion:(void (^)(SAAppPayInitModel *_Nullable model, SARspModel *_Nullable resp, NSError *error))completion {
    [self.openCapabilityDto queryMerchantInfoWithMerchantNo:merchant success:^(SAOpenCapabilityMerchantInfoRespModel *_Nonnull rspModel) {
        infoModel.merchantName = rspModel.merchantName.desc;
        infoModel.merchantType = rspModel.merchantType;
        infoModel.merLogo = rspModel.merLogo;
        !completion ?: completion(infoModel, nil, nil);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion(nil, rspModel, error);
    }];
}

#pragma mark - hdchecnStanderDelegate
/**
 收银台初始化失败
 下支付单失败or获取支付工具失败，需要重新下单, 会自动收起收银台
 @param controller 收银台
 */
- (void)checkStandViewControllerInitializeFailed:(HDCheckStandViewController *)controller {
    //    @HDWeakify(self);
    [controller dismissViewControllerAnimated:YES completion:^{
        //        @HDStrongify(self);
        //        [self gotoResultPage];
    }];
}

/**
 支付成功
 @param controller 收银台
 @param resultResp 支付成功返回模型
 */
- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentSuccess:(HDCheckStandPayResultResp *)resultResp {
    @HDWeakify(self);
    [controller dismissViewControllerAnimated:YES completion:^{
        @HDStrongify(self);
        [self gotoResultPage];
    }];
}

/**
 支付失败
 @param controller 收银台
 @param resultResp 支付失败返回模型
 */
- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentFail:(HDCheckStandPayResultResp *)resultResp {
    @HDWeakify(self);
    [controller dismissViewControllerAnimated:YES completion:^{
        @HDStrongify(self);
        [self gotoResultPage];
    }];
}

/// 已完成，但是状态未明
/// @param controller 收银台
- (void)checkStandViewControllerCompletedAndPaymentUnknow:(HDCheckStandViewController *)controller {
    [self gotoResultPage];
}

/**
 支付失败（可能是网络错误）
 */
- (void)checkStandViewController:(HDCheckStandViewController *)controller failureWithRspModel:(SARspModel *_Nullable)rspModel errorType:(CMResponseErrorType)errorType error:(NSError *_Nullable)error {
    @HDWeakify(self);
    [controller dismissViewControllerAnimated:YES completion:^{
        @HDStrongify(self);
        [self gotoResultPage];
    }];
}

/**
 用户取消支付

 @param controller 收银台
 */
- (void)checkStandViewControllerUserClosedCheckStand:(HDCheckStandViewController *)controller {
    @HDWeakify(self);
    [controller dismissViewControllerAnimated:YES completion:^{
        @HDStrongify(self);
        [self notifyMerchantWithErrorCode:-2 errorMessage:@"usercancel" extend:nil];
    }];
}

#pragma mark - overwire
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleWhite;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

#pragma mark - lazy load
- (HDUIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake(0, 0, 44, 44);
        [_closeBtn setImage:[UIImage imageNamed:@"AppPay_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }

    return _closeBtn;
}

- (UILabel *)orderDescLabel {
    if (!_orderDescLabel) {
        _orderDescLabel = UILabel.new;
        _orderDescLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _orderDescLabel.textColor = [UIColor hd_colorWithHexString:@"#F83E00"];
        _orderDescLabel.textAlignment = NSTextAlignmentCenter;
        _orderDescLabel.numberOfLines = 0;
        _orderDescLabel.text = SALocalizedString(@"app_pay_init", @"等待付款中，请不要关闭页面");
    }
    return _orderDescLabel;
}

- (UIImageView *)loadingIV {
    if (!_loadingIV) {
        _loadingIV = [[UIImageView alloc] init];
        NSMutableArray<UIImage *> *arr = NSMutableArray.new;
        for (int i = 0; i < 24; i++) {
            [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"合成 1_000%02d", i]]];
        }
        _loadingIV.animationImages = arr;
        _loadingIV.animationDuration = 1;
    }
    return _loadingIV;
}

- (UILabel *)merInfoLabel {
    if (!_merInfoLabel) {
        UILabel *label = UILabel.new;
        label.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        label.textColor = [UIColor hd_colorWithHexString:@"#343B4D"];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 3;
        label.hidden = YES;
        _merInfoLabel = label;
    }

    return _merInfoLabel;
}

- (UILabel *)productInfoLabel {
    if (!_productInfoLabel) {
        _productInfoLabel = UILabel.new;
        _productInfoLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _productInfoLabel.textColor = [UIColor hd_colorWithHexString:@"#343B4D"];
        _productInfoLabel.textAlignment = NSTextAlignmentCenter;
        _productInfoLabel.numberOfLines = 0;
        _productInfoLabel.hidden = YES;
    }
    return _productInfoLabel;
}

- (UIImageView *)bgPlaceHolderImageView {
    if (!_bgPlaceHolderImageView) {
        _bgPlaceHolderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AppPay_placeholder"]];
    }
    return _bgPlaceHolderImageView;
}

- (SAOpenCapabilityDTO *)openCapabilityDto {
    if (!_openCapabilityDto) {
        _openCapabilityDto = SAOpenCapabilityDTO.new;
    }
    return _openCapabilityDto;
}

@end
