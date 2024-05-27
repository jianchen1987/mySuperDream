//
//  GNOrderDetailViewController.m
//  SuperApp
//
//  Created by wmz on 2021/6/4.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNOrderDetailViewController.h"
#import "GNAlertUntils.h"
#import "GNOneClickCouponAlert.h"
#import "GNOrderDetailHeadView.h"
#import "GNOrderViewModel.h"
#import "GNReserveRspModel.h"
#import "GNStringUntils.h"
#import "GNTimer.h"


@interface GNOrderDetailViewController () <GNTableViewProtocol>
/// 正在核销
@property (nonatomic, assign) BOOL verification;
/// tableview
@property (nonatomic, strong) GNTableView *tableView;
/// viewModel
@property (nonatomic, strong) GNOrderViewModel *viewModel;
/// 导航栏
@property (nonatomic, strong) GNOrderDetailHeadView *naviView;
/// 优惠券弹窗
@property (nonatomic, strong) GNOneClickCouponAlert *couponAlert;
/// 首次展示优惠券弹窗
@property (nonatomic, assign) BOOL firstShowCoupon;

@end


@implementation GNOrderDetailViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        self.orderNo = [parameters objectForKey:@"orderNo"];
        [self getDetail];
    }
    return self;
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}

- (void)hd_setupNavigation {
    [super hd_setupNavigation];
    self.hd_statusBarStyle = UIStatusBarStyleDefault;
}

- (void)updateViewConstraints {
    [self.naviView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(kNavigationBarH);
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.naviView.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    [super updateViewConstraints];
}

- (void)hd_setupViews {
    [self.view addSubview:self.naviView];
    [self.view addSubview:self.tableView];
    @HDWeakify(self);
    self.tableView.requestNewDataHandler = self.tableView.tappedRefreshBtnHandler = ^{
        @HDStrongify(self);
        if ([self.viewModel.detailModel.paymentMethod.codeId isEqualToString:GNPayMetnodTypeOnline] && [self.viewModel.detailModel.bizState.codeId isEqualToString:GNOrderStatusUnPay]
            && self.aggregateOrderNo) {
            [self getPaymentState];
        } else {
            [self getDetail];
        }
    };
    self.naviView.titleLB.text = GNLocalizedString(@"gn_order_detail", @"订单详情");
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
    @HDWeakify(self)[self.KVOController hd_observe:self.viewModel keyPath:@"couponDataSource" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self dismissLoading];
        if (!HDIsArrayEmpty(self.viewModel.couponDataSource)) {
            [self showCoupnAlert];
        }
    }];
}

///获取优惠券
- (void)getCouponAction {
    if (HDIsStringNotEmpty(self.orderNo) && self.viewModel.detailModel.joinActivity
        && ([self.viewModel.detailModel.bizState.codeId isEqualToString:GNOrderStatusUse] || [self.viewModel.detailModel.bizState.codeId isEqualToString:GNOrderStatusFinish])) {
        [self.viewModel orderCouponWithOrderNo:self.orderNo];
    }
}

///展示优惠券
- (void)showCoupnAlert {
    @HDWeakify(self) if (self.couponAlert.isShow) {
        [self.couponAlert dissmiss];
        [self performSelector:@selector(showCoupnAlert) withObject:nil afterDelay:0.25];
        return;
    }
    self.couponAlert = [[GNOneClickCouponAlert alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    BOOL finish = [self.viewModel.detailModel.bizState.codeId isEqualToString:GNOrderStatusFinish];
    [self.couponAlert configDataSource:self.viewModel.couponDataSource finish:finish];
    self.couponAlert.useBlock = ^(GNCouponDetailModel *_Nonnull rspModel) {
        @HDStrongify(self)[self.couponAlert dissmiss];
        [HDMediator.sharedInstance navigaveToStoreDetailViewController:@{@"storeNo": rspModel.storeNo}];
    };
    [self.view addSubview:self.couponAlert];
    [self.couponAlert show];
}

- (void)updateUI {
    [self getPaymentState];
}

///获取支付状态
- (void)getPaymentState {
    @HDWeakify(self);
    [self getPaymentStateSuccess:^(SAQueryPaymentStateRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self getDetail];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self getDetail];
    }];
}

/// 获取详情
- (void)getDetail {
    @HDWeakify(self);
    [self.viewModel getOrderDetailOrderNo:GNFillEmpty(self.orderNo) completion:^(BOOL error) {
        @HDStrongify(self);
        if (([self.viewModel.detailModel.paymentMethod.codeId isEqualToString:GNPayMetnodTypeOnline] && self.viewModel.detailModel.payFailureTime > 0))
            [self startTimer];

        if ([self.viewModel.detailModel.paymentMethod.codeId isEqualToString:GNPayMetnodTypeOnline] && [self.viewModel.detailModel.bizState.codeId isEqualToString:GNOrderStatusUnPay]
            && !self.aggregateOrderNo) {
            self.aggregateOrderNo = self.viewModel.detailModel.aggregateOrderNo;
            [self performSelector:@selector(getPaymentState) withObject:nil afterDelay:1];
        }
        self.aggregateOrderNo = self.viewModel.detailModel.aggregateOrderNo;
        [GNTimer cancel:@"orderVerificationState"];
        self.tableView.GNdelegate = self;
        if (!error) {
            [self.tableView reloadData:NO];
            [self checkTimer];
            if (!self.firstShowCoupon) {
                [self getCouponAction];
                self.firstShowCoupon = YES;
            }
        } else {
            [self.tableView reloadFail];
        }
    }];
}

///订单倒计时
- (void)refreshAction {
    self.viewModel.detailModel.payFailureTime = ((self.viewModel.detailModel.payFailureTime / 1000) - 1) * 1000;

    if (self.viewModel.detailModel.payFailureTime / 1000 <= 0) {
        [self cancelTimer];
        [self getPaymentState];
    }

    if (self.viewModel.detailModel.payFailureTime > 0) {
        NSString *timeStr = [NSString stringWithFormat:@"%@：%@", GNLocalizedString(@"gn_payment_time", @"剩余支付时间"), [self lessSecondToDay:self.viewModel.detailModel.payFailureTime / 1000]];
        NSString *titleStr = GNLocalizedString(@"gn_order_detail", @"订单详情");
        NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", titleStr, timeStr]];
        [GNStringUntils attributedString:mstr color:HDAppTheme.color.gn_333Color colorRange:titleStr font:[HDAppTheme.font gn_boldForSize:14] fontRange:titleStr];
        [GNStringUntils attributedString:mstr color:HDAppTheme.color.gn_mainColor colorRange:timeStr font:[HDAppTheme.font gn_ForSize:12] fontRange:timeStr];
        self.naviView.titleLB.attributedText = mstr;
    } else {
        self.naviView.titleLB.attributedText = nil;
        self.naviView.titleLB.text = GNLocalizedString(@"gn_order_detail", @"订单详情");
    }
}

///剩余支付时间
- (NSString *)lessSecondToDay:(long)seconds {
    if (seconds <= 0)
        return @"";
    long min = (long)(seconds % (3600)) / 60;
    long second = (long)(seconds % 60);
    return [NSString stringWithFormat:@"%02ld:%02ld", min, second];
}

///检测核销定时器
- (void)checkTimer {
    @HDWeakify(self);
    if ([self.viewModel.detailModel.bizState.codeId isEqualToString:GNOrderStatusUse]) {
        [GNTimer cancel:@"orderVerificationState"];
        [GNTimer timerWithStartTime:0 interval:2 timeId:@"orderVerificationState" total:60 * 10 repeats:YES mainQueue:YES completion:^(NSInteger time) {
            @HDStrongify(self);
            [self checkState];
        }];
    }
}

///检测核销
- (void)checkState {
    if (![NSStringFromClass(self.class) isEqualToString:@"GNOrderDetailViewController"])
        [GNTimer cancel:@"orderVerificationState"];
    @HDWeakify(self);
    [self.viewModel orderVerificationStateOrderNo:self.orderNo completion:^(GNMessageCode *_Nonnull rspModel) {
        @HDStrongify(self);
        if ([rspModel.codeId isEqualToString:GNVerificationStateIng]) {
            if (!self.verification) {
                [self showloadingText:GNLocalizedString(@"gn_check_ing", @"核销中")];
                self.verification = YES;
            }
        } else if (([rspModel.codeId isEqualToString:GNVerificationStateSome] || [rspModel.codeId isEqualToString:GNVerificationStateFinish])) {
            [self dismissLoading];
            self.verification = NO;
            [GNTimer cancel:@"orderVerificationState"];
            [HDTips showWithText:GNLocalizedString(@"gn_check_success", @"核销成功") inView:self.view hideAfterDelay:2];
            self.firstShowCoupon = NO;
            [self getDetail];
        } else if ([rspModel.codeId isEqualToString:GNVerificationStateUse]) {
            self.verification = NO;
            [self dismissLoading];
        }
    }];
}

#pragma mark RespondEvent
- (void)respondEvent:(NSObject<GNEvent> *)event {
    [super respondEvent:event];
    @HDWeakify(self)
        ///取消订单
        if ([event.key isEqualToString:@"cancelOrder"]) {
        void (^callback)(BOOL) = ^(BOOL result) {
            @HDStrongify(self);
            ///刷新
            [self.tableView.mj_header beginRefreshing];
        };
        [HDMediator.sharedInstance navigaveToGNOrderCancelViewController:@{
            @"orderNo": self.viewModel.detailModel.orderNo,
            @"callback": callback,
        }];
    }
    ///再次购买
    else if ([event.key isEqualToString:@"bugAgain"]) {
        [HDMediator.sharedInstance navigaveToGNStoreProductViewController:
                                       @{@"storeNo": self.viewModel.detailModel.merchantInfo.storeNo, @"productCode": self.viewModel.detailModel.productInfo.codeId, @"fromOrder": @"bugAgain"}];
    }
    ///导航
    else if ([event.key isEqualToString:@"navigationAction"]) {
        [GNAlertUntils navigation:self.viewModel.detailModel.merchantInfo.storeName.desc lat:self.viewModel.detailModel.merchantInfo.geoPointDTO.lat.doubleValue
                              lon:self.viewModel.detailModel.merchantInfo.geoPointDTO.lon.doubleValue];
    }
    ///联系商家
    else if ([event.key isEqualToString:@"callAction"]) {
        [GNAlertUntils callString:self.viewModel.detailModel.merchantInfo.businessPhone];
    }
    ///联系平台
    else if ([event.key isEqualToString:@"callServerAction"]) {
        [GNAlertUntils callAndServerString:self.viewModel.detailModel.merchantInfo.businessPhone];
    }
    /// 查看更多
    else if ([event.key isEqualToString:@"openText"] && event.indexPath) {
        if ([self.tableView numberOfSections] > event.indexPath.section && [self.tableView numberOfRowsInSection:event.indexPath.section] > event.indexPath.row) {
            [self.tableView updateCell:event.indexPath];
        }
    }
    ///查看优惠券
    else if ([event.key isEqualToString:@"enterCouponAction"]) {
        [self showloading];
        [self getCouponAction];
    }
    ///预约
    else if ([event.key isEqualToString:@"reserveAction"]) {
        if (self.viewModel.detailModel.reservation) {
            [HDMediator.sharedInstance navigaveToGNReserveDetailViewController:@{@"orderNo": self.viewModel.detailModel.orderNo}];
        } else {
            @HDWeakify(self) void (^callback)(GNReserveRspModel *_Nullable) = ^(GNReserveRspModel *rspModel) {
                @HDStrongify(self) self.viewModel.detailModel.reservation = YES;
                [self getDetail];
            };
            [HDMediator.sharedInstance navigaveToGNOrderReserveViewController:@{@"callback": callback, @"orderNo": self.orderNo, @"storeNo": self.viewModel.detailModel.merchantInfo.storeNo}];
        }
    }
}

#pragma mark GNTableViewProtocol
- (NSArray<GNSectionModel *> *)numberOfSectionsInGNTableView:(GNTableView *)tableView {
    return self.viewModel.detailSource;
}

- (void)GNTableView:(GNTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath data:(id<GNRowModelProtocol>)rowData {
    /// 跳转商家详情
    if ([NSStringFromClass(rowData.cellClass) isEqualToString:@"GNOrderStoreTableViewCell"] && [rowData.businessData isKindOfClass:GNStoreCellModel.class]) {
        [HDMediator.sharedInstance navigaveToGNStoreDetailViewController:@{@"storeNo": GNFillEmpty(self.viewModel.detailModel.merchantInfo.storeNo)}];
    }
    /// 商品详情
    else if (([NSStringFromClass(rowData.cellClass) isEqualToString:@"GNOrderProductTableViewCell"])) {
        [HDMediator.sharedInstance navigaveToGNStoreProductViewController:
                                       @{@"storeNo": self.viewModel.detailModel.merchantInfo.storeNo, @"productCode": self.viewModel.detailModel.productInfo.codeId, @"fromOrder": @"detail"}];
    } else if ([rowData isKindOfClass:GNCellModel.class]) {
        GNCellModel *trueModel = rowData;
        /// 复制
        if (GNStringNotEmpty(trueModel.tag) && [trueModel.tag isEqualToString:@"order"]) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            NSString *copyStr = [trueModel.detail stringByReplacingOccurrencesOfString:@" " withString:@""];
            pasteboard.string = copyStr;
            [NAT showToastWithTitle:nil content:WMLocalizedString(@"wm_order_copy_success", @"复制成功") type:HDTopToastTypeSuccess];
        }
        ///跳转退款详情
        else if (GNStringNotEmpty(trueModel.tag) && [trueModel.tag isEqualToString:@"refund"]) {
            [HDMediator.sharedInstance navigaveToCommonRefundDetailViewController:@{@"aggregateOrderNo": GNFillEmpty(self.viewModel.detailModel.aggregateOrderNo)}];
            //            [HDMediator.sharedInstance navigaveToGNRefundDetailViewController:@{
            //                @"aggregateOrderNo" : GNFillEmpty(self.viewModel.detailModel.aggregateOrderNo),
            //                @"businessPhone":self.viewModel.detailModel.merchantInfo.businessPhone,
            //                @"cancelTime":@(self.viewModel.detailModel.cancelTime),
            //                @"cancelState":self.viewModel.detailModel.cancelState.codeId}];
        }
    }
}

#pragma mark Lazy
- (GNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[GNTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, kiPhoneXSeriesSafeBottomHeight, 0);
        _tableView.backgroundColor = HDAppTheme.color.gn_mainBgColor;
        _tableView.delegate = _tableView.provider;
        _tableView.dataSource = _tableView.provider;
        _tableView.needShowErrorView = YES;
        _tableView.needRefreshBTN = YES;
        _tableView.needRefreshHeader = YES;
    }
    return _tableView;
}

- (GNOrderViewModel *)viewModel {
    return _viewModel ?: ({ _viewModel = GNOrderViewModel.new; });
}

- (GNOrderDetailHeadView *)naviView {
    if (!_naviView) {
        _naviView = GNOrderDetailHeadView.new;
    }
    return _naviView;
}

- (void)dealloc {
    [GNTimer cancel:@"orderVerificationState"];
}

- (BOOL)needClose {
    return YES;
}

@end
