//
//  PayHDCheckstandViewController.m
//  customer
//
//  Created by VanJay on 2019/5/15.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDCheckStandViewController.h"
#import "PNUtilMacro.h"
#import "PayHDCheckstandInputPwdViewController.h"
#import "PayHDCheckstandPaymentUserInfoModel.h"


@interface PayHDCheckstandViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) PayHDPresentViewControllerAnimation *transitioning;
@property (nonatomic, strong) PayHDTradeBuildOrderRspModel *buildModel; ///< 下单模型
@property (nonatomic, assign) CGFloat preferedHeight;                   ///< 高度，不设置将使用默认高度
@property (nonatomic, assign) PayHDCheckstandViewControllerStyle style; ///< 风格
@property (nonatomic, strong) PNPaymentReqModel *businessModel;         ///< 付款码业务模型
@end


@implementation PayHDCheckstandViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    NSString *orderNo = parameters[@"orderNo"];
    NSString *orderAmt = parameters[@"orderAmt"];
    NSString *orderCy = parameters[@"orderCy"];
    NSString *userInfoStr = parameters[@"userInfo"];
    NSNumber *showPaymentResult = parameters[@"showResult"];
    id<PayHDCheckstandViewControllerDelegate> delegate = parameters[@"delegateObject"];
    if (WJIsStringNotEmpty(orderNo) && WJIsStringNotEmpty(orderAmt) && WJIsStringNotEmpty(orderCy)) {
        SAMoneyModel *amountModel = [SAMoneyModel modelWithAmount:orderAmt currency:orderCy];
        PayHDTradeBuildOrderRspModel *buildModel = [PayHDTradeBuildOrderRspModel modelWithOrderAmount:amountModel tradeNo:orderNo];

        if (userInfoStr) {
            NSData *jsonData = [userInfoStr dataUsingEncoding:NSUTF8StringEncoding];
            id obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            if (obj && [obj isKindOfClass:NSArray.class]) {
                for (id dic in obj) {
                    PayHDCheckstandPaymentUserInfoModel *model = [PayHDCheckstandPaymentUserInfoModel yy_modelWithJSON:dic];
                    [buildModel.customerInfo addObject:[HDDealCommonInfoRowViewModel modelWithKey:model.title value:model.desc]];
                }
            }
        }

        PayHDCheckstandViewController *vc = [PayHDCheckstandViewController checkStandWithTradeBuildModel:buildModel preferedHeight:0];
        if (showPaymentResult) {
            vc.showPaymentResult = showPaymentResult.boolValue;
        }
        vc.resultDelegate = delegate;
        return vc;
    }
    return nil;
}

+ (instancetype)checkStandWithBusinessPaymenModel:(PNPaymentReqModel *)businessPaymenModel
                                   preferedHeight:(CGFloat)preferedHeight
                                            style:(PayHDCheckstandViewControllerStyle)style
                                            title:(NSString *)title
                                           tipStr:(NSString *)tipStr {
    return [[self alloc] initWithBusinessPaymenModel:businessPaymenModel preferedHeight:preferedHeight style:style title:title tipStr:tipStr];
}

- (instancetype)initWithBusinessPaymenModel:(PNPaymentReqModel *)businessPaymenModel
                             preferedHeight:(CGFloat)preferedHeight
                                      style:(PayHDCheckstandViewControllerStyle)style
                                      title:(NSString *)title
                                     tipStr:(NSString *)tipStr {
    self = [super init];
    if (self) {
        self.businessModel = businessPaymenModel;
        self.preferedHeight = preferedHeight;
        self.style = style;

        self.transitioning = [[PayHDPresentViewControllerAnimation alloc] init];
        self.transitioning.presentingStyle = PayHDPresentVCAnimationPresentingStyleFromBottom;

        [self commonInitForVeriftPwdWithTitle:title tipStr:tipStr];
    }
    return self;
}

+ (instancetype)checkStandWithTradeBuildModel:(PayHDTradeBuildOrderRspModel *)buildModel preferedHeight:(CGFloat)preferedHeight {
    return [[self alloc] initWithTradeBuildModel:buildModel preferedHeight:preferedHeight];
}

- (instancetype)initWithTradeBuildModel:(PayHDTradeBuildOrderRspModel *)buildModel preferedHeight:(CGFloat)preferedHeight {
    self = [super init];
    if (self) {
        self.buildModel = buildModel;
        self.preferedHeight = preferedHeight;

        self.transitioning = [[PayHDPresentViewControllerAnimation alloc] init];
        self.transitioning.presentingStyle = PayHDPresentVCAnimationPresentingStyleNone;

        [self commonInit];
    }
    return self;
}

+ (instancetype)checkStandWithPreferedHeight:(CGFloat)preferedHeight style:(PayHDCheckstandViewControllerStyle)style title:(NSString *)title tipStr:(NSString *)tipStr {
    return [[self alloc] initWithPreferedHeight:preferedHeight style:style title:title tipStr:tipStr];
}

- (instancetype)initWithPreferedHeight:(CGFloat)preferedHeight style:(PayHDCheckstandViewControllerStyle)style title:(NSString *)title tipStr:(NSString *)tipStr {
    //初始该方法请注意 支付类型 业务校验类型
    NSAssert(style >= PayHDCheckstandViewControllerStyleVerifyPwd, @"该构造器只允许创建验证密码类型的收银台");

    self = [super init];
    if (self) {
        self.preferedHeight = preferedHeight;
        self.style = style;

        self.transitioning = [[PayHDPresentViewControllerAnimation alloc] init];
        self.transitioning.presentingStyle = PayHDPresentVCAnimationPresentingStyleFromBottom;

        [self commonInitForVeriftPwdWithTitle:title tipStr:tipStr];
    }
    return self;
}

+ (instancetype)pn_payCheckStandWithTradeBuildModel:(PayHDTradeBuildOrderRspModel *)buildModel {
    return [[self alloc] initWithTradeBuldModel:buildModel style:PayHDCheckstandViewControllerStylePay title:buildModel.inputVCTitle tipStr:buildModel.tipsStr];
}

- (instancetype)initWithTradeBuldModel:(PayHDTradeBuildOrderRspModel *)buildModel style:(PayHDCheckstandViewControllerStyle)style title:(NSString *)title tipStr:(NSString *)tipStr {
    //初始该方法请注意 支付类型 型 只管支付业务
    NSAssert(style == PayHDCheckstandViewControllerStylePay, @"该构造器只允许创建支付类型的密码输入");

    self = [super init];
    if (self) {
        self.preferedHeight = 0;
        self.style = style;

        self.transitioning = [[PayHDPresentViewControllerAnimation alloc] init];
        self.transitioning.presentingStyle = PayHDPresentVCAnimationPresentingStyleFromBottom;

        [self commonInit];
        PayHDCheckstandInputPwdViewController *vc = [[PayHDCheckstandInputPwdViewController alloc] initWithNumberOfCharacters:6 title:title tipStr:tipStr isVerifyPwd:NO];
        vc.model = buildModel.confirmRspMode;
        vc.buildModel = buildModel;
        vc.tradeNo = buildModel.tradeNo;
        [self pushViewControllerDiscontinuous:vc animated:YES];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    // 覆写此方法，只用于加载收银台相关控制器
    [self commonInit];
    return self;
}

- (void)dealloc {
    HDLog(@"收银台 -- %@ -- dealloc", NSStringFromClass([self preferredViewControllerClass]));
}

- (Class)preferredViewControllerClass {
    return self.class;
}

- (void)commonInit {
    __weak __typeof(self) weakSelf = self;
    self.transitioning.tappedShadowHandler = ^{
        HDLog(@"点击了阴影");
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        switch (strongSelf.tappedShadowAction) {
            case PayPayHDCheckstandTappedShadowActionDismiss:
                !strongSelf.tappedShadowHandler ?: strongSelf.tappedShadowHandler();
                break;

            case PayPayHDCheckstandTappedShadowActionDismissOnlyInConfirmPage: {
                if (strongSelf.viewControllers.count <= 1) {
                    !strongSelf.tappedShadowHandler ?: strongSelf.tappedShadowHandler();
                }
            } break;

            default:
                break;
        }
    };

    self.transitioningDelegate = self;
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;

    self.showPaymentResult = YES;

    // 初始加载收款确认页面
    if (self.style == PayHDCheckstandViewControllerStyleDefault) {
        PayHDCheckstandConfirmViewController *vc = [PayHDCheckstandConfirmViewController checkStandWithTradeBuildModel:self.buildModel];
        [self pushViewController:vc animated:NO];
    }
}

- (void)commonInitForVeriftPwdWithTitle:(NSString *)title tipStr:(NSString *)tipStr {
    [self commonInit];

    if (self.style >= PayHDCheckstandViewControllerStyleVerifyPwd) {
        PayHDCheckstandInputPwdViewController *vc = [[PayHDCheckstandInputPwdViewController alloc] initWithNumberOfCharacters:6 title:title tipStr:tipStr isVerifyPwd:YES];
        vc.style = self.style;
        if (self.style == PayHDCheckstandViewControllerStyleGetPaymentCode) {
            vc.actionType = BusinessActionType_GetPaymentCode;
            vc.businessModel = self.businessModel;
        } else if (self.style == PayHDCheckstandViewControllerStyleOpenPayment) {
            vc.actionType = BusinessActionType_OpenPayment;
            vc.businessModel = self.businessModel;
        } else if (self.style == PayHDCheckstandViewControllerStyleMerchantServicePwd) {
            vc.actionType = BusinessActionType_CheckMerchantServicePayPassword;
        } else {
            vc.actionType = BusinessActionType_CheckPayPassword;
        }
        [self pushViewController:vc animated:NO];
    }
}

- (void)loadView {
    [super loadView];
    // 隐藏导航栏
    self.navigationBar.hidden = YES;

    // 补齐高度
    CGFloat fillingHeight = kiPhoneXSeriesSafeBottomHeight;
    if ([self isKindOfClass:UINavigationController.class] && self.navigationBar.isHidden) {
        fillingHeight = kiPhoneXSeriesSafeBottomHeight - 44;
    }

    // 默认高度
    CGFloat defaultHeight = kScreenWidth * 1.2;

    if ([self isKindOfClass:UINavigationController.class]) {
        self.preferredContentSize = CGSizeMake(kScreenWidth, self.preferedHeight != 0 ? (self.preferedHeight + fillingHeight) : (defaultHeight + fillingHeight));
    } else {
        self.preferredContentSize = CGSizeMake(kScreenWidth, self.preferedHeight != 0 ? (self.preferedHeight + fillingHeight) : (defaultHeight + fillingHeight));
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:10];
}

#pragma mark - PayHDCheckstandBaseViewControllerDelegate
- (void)checkStandBaseViewController:(PayHDCheckstandBaseViewController *)controller paymentSuccess:(PayHDTradeSubmitPaymentRspModel *)rspModel {
    if (self.resultDelegate && [self.resultDelegate respondsToSelector:@selector(checkStandViewController:paymentSuccess:)]) {
        [self.resultDelegate checkStandViewController:self paymentSuccess:rspModel];
    }
}

- (void)checkStandBaseViewController:(PayHDCheckstandBaseViewController *)controller transactionFailure:(NSString *)reason code:(NSString *)code {
    if (self.resultDelegate && [self.resultDelegate respondsToSelector:@selector(checkStandViewController:transactionFailure:code:)]) {
        [self.resultDelegate checkStandViewController:self transactionFailure:reason code:code];
    }
}

- (void)checkStandViewBaseControllerUserClosedCheckStand:(PayHDCheckstandBaseViewController *)controller {
    if (self.resultDelegate && [self.resultDelegate respondsToSelector:@selector(checkStandViewControllerUserClosedCheckStand:)]) {
        [self.resultDelegate checkStandViewControllerUserClosedCheckStand:self];
    }
}

- (void)checkStandViewBaseController:(PayHDCheckstandBaseViewController *)controller confirmOrderSuccessWithVoucherNo:(NSString *)voucherNo {
    if (self.resultDelegate && [self.resultDelegate respondsToSelector:@selector(checkStandViewController:confirmOrderSuccessWithVoucherNo:)]) {
        [self.resultDelegate checkStandViewController:self confirmOrderSuccessWithVoucherNo:voucherNo];
    }
}

- (void)checkStandViewBaseController:(PayHDCheckstandBaseViewController *)controller completedInputPassword:(PayHDCheckstandTextField *)textField {
    if (self.resultDelegate && [self.resultDelegate respondsToSelector:@selector(checkStandViewController:completedInputPassword:)]) {
        [self.resultDelegate checkStandViewController:self completedInputPassword:textField];
    }
}

- (void)checkStandViewBaseControllerPaymentOverTime:(PayHDCheckstandBaseViewController *)controller endActionType:(PayHDCheckstandPaymentOverTimeEndActionType)type {
    if (self.resultDelegate && [self.resultDelegate respondsToSelector:@selector(checkStandViewControllerPaymentOverTime:endActionType:)]) {
        [self.resultDelegate checkStandViewControllerPaymentOverTime:self endActionType:type];
    }
}

- (void)checkStandViewBaseController:(PayHDCheckstandBaseViewController *)controller verifyPwdPaymentPasswordSuccess:(NSString *)token index:(NSString *)index password:(NSString *)password {
    if (self.resultDelegate && [self.resultDelegate respondsToSelector:@selector(checkStandViewController:verifyPwdPaymentPasswordSuccess:index:password:)]) {
        [self.resultDelegate checkStandViewController:self verifyPwdPaymentPasswordSuccess:token index:index password:password];
    }
}

- (void)checkStandViewBaseController:(PayHDCheckstandBaseViewController *)controller verifyPwdPaymentPasswordFailed:(NSString *)reason code:(NSString *)code {
    if (self.resultDelegate && [self.resultDelegate respondsToSelector:@selector(checkStandViewController:verifyPwdPaymentPasswordFailed:code:)]) {
        [self.resultDelegate checkStandViewController:self verifyPwdPaymentPasswordFailed:reason code:code];
    }
}

- (void)checkStandBaseViewControllerDidShown:(PayHDCheckstandBaseViewController *)controller {
    if (self.resultDelegate && [self.resultDelegate respondsToSelector:@selector(checkStandViewControllerDidShown:)]) {
        [self.resultDelegate checkStandViewControllerDidShown:self];
    }
}

- (void)checkStandViewBaseController:(PayHDCheckstandBaseViewController *)controller
    verifyOpenPaymentPasswordSuccess:(NSString *)payerUsrToken
                               index:(NSString *)index
                            password:(NSString *)password
                             authKey:(NSString *)authKey
                                 pwd:(NSString *)pwd {
    if (self.resultDelegate && [self.resultDelegate respondsToSelector:@selector(checkStandViewController:verifyOpenPaymentPasswordSuccess:index:password:key:pwd:)]) {
        [self.resultDelegate checkStandViewController:self verifyOpenPaymentPasswordSuccess:payerUsrToken index:index password:password key:authKey pwd:pwd];
    }
}

- (void)checkStandViewBaseController:(PayHDCheckstandBaseViewController *)controller verifyGetPaymentQRCodeSuccess:(NSDictionary *)rspData index:(NSString *)index password:(NSString *)password {
    if (self.resultDelegate && [self.resultDelegate respondsToSelector:@selector(checkStandViewController:verifyGetPaymentQRCodeSuccess:index:password:)]) {
        [self.resultDelegate checkStandViewController:self verifyGetPaymentQRCodeSuccess:rspData index:index password:password];
    }
}

- (void)checkStandViewBaseController:(PayHDCheckstandBaseViewController *)controller merchantPwd:(NSString *)index password:(NSString *)password {
    if (self.resultDelegate && [self.resultDelegate respondsToSelector:@selector(checkStandViewController:merchantPwd:password:)]) {
        [self.resultDelegate checkStandViewController:self merchantPwd:index password:password];
    }
}

#pragma mark - override system methods
- (void)dismissViewControllerCompletion:(void (^__nullable)(void))completion {
    UIViewController *vc = self.viewControllers.lastObject;
    if ([vc isKindOfClass:PayHDCheckstandBaseViewController.class]) {
        PayHDCheckstandBaseViewController *baseVC = (PayHDCheckstandBaseViewController *)vc;
        [baseVC hideContainerViewAndDismissCheckStandWithoutCallingClosePaymentFinshed:completion];
    } else {
        [self dismissViewControllerAnimated:true completion:completion];
    }
}

#pragma mark - getters and setters
- (void)setPresentingStyle:(PayHDPresentVCAnimationStyle)presentingStyle {
    _presentingStyle = presentingStyle;

    self.transitioning.presentingStyle = presentingStyle;
}

- (void)setDismissStyle:(PayHDPresentVCAnimationStyle)dismissStyle {
    _dismissStyle = dismissStyle;

    self.transitioning.dismissStyle = dismissStyle;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    return self.transitioning;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.transitioning;
}
@end
