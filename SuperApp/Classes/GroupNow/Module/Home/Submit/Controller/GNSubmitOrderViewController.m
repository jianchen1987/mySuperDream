//
//  GNSubmitOrderViewController.m
//  SuperApp
//
//  Created by wmz on 2021/6/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNSubmitOrderViewController.h"
#import "GNOrderSubmitViewModel.h"
#import "GNPromoCodeView.h"
#import "GNRedundAlertView.h"
#import "GNReserveRspModel.h"
#import "GNStoreOrderFootView.h"
#import "GNStoreOrderProductTableViewCell.h"
#import "LKDataRecord.h"
#import "SAAppSwitchManager.h"
#import "WMOrderSubmitChoosePaymentMethodView.h"
#import "WMOrderSubmitPaymentMethodCellModel.h"


@interface GNSubmitOrderViewController () <GNTableViewProtocol>
/// footView
@property (nonatomic, strong) GNStoreOrderFootView *footView;
/// tableview
@property (nonatomic, strong) GNTableView *tableView;
/// viewModel
@property (nonatomic, strong) GNOrderSubmitViewModel *viewModel;

/// 埋点
///< 来源
@property (nonatomic, copy) NSString *source;
///< 关联ID
@property (nonatomic, copy) NSString *associatedId;

@end


@implementation GNSubmitOrderViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        self.viewModel = [parameters objectForKey:@"viewModel"];
        self.productCode = [parameters objectForKey:@"productCode"];
        self.storeNo = [parameters objectForKey:@"storeNo"];
        self.source = parameters[@"source"];
        self.associatedId = parameters[@"associatedId"];
        if (!self.viewModel || ![self.viewModel isKindOfClass:GNOrderSubmitViewModel.class]) {
            [self getData];
        } else {
            [self updateUI:nil];
        }
    }
    return self;
}

- (void)updateViewConstraints {
    [self.footView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kNavigationBarH);
        make.bottom.equalTo(self.footView.mas_top);
    }];
    [super updateViewConstraints];
}

- (void)hd_setupViews {
    [self.view addSubview:self.footView];
    [self.view addSubview:self.tableView];
    [self performSelector:@selector(showProtocolAlert) withObject:nil afterDelay:0.5];
}

- (void)showProtocolAlert {
    @HDWeakify(self) if (self.viewModel.rushBuyModel.whetherRefund == 2) {
        GNNormalAlertConfig *config = GNNormalAlertConfig.new;
        config.title = GNLocalizedString(@"gn_refund_protocol_title", @"退改签规定协议");
        config.content = GNLocalizedString(@"gn_refund_protocol_content", @"退改签规定协议");
        ;
        config.confirm = GNLocalizedString(@"gn_refund_protocol_contiune", @"");
        config.cancelHandle = ^(GNRedundAlertView *_Nonnull alertView, HDUIButton *_Nonnull button) {
            @HDStrongify(self)[alertView dismiss];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        };
        GNRedundAlertView *alert = [[GNRedundAlertView alloc] initWithConfig:config];
        [alert show];
    }
}

- (void)hd_setupNavigation {
    [super hd_setupNavigation];
    self.boldTitle = GNLocalizedString(@"gn_order_submit", @"提交订单");
}

- (void)hd_bindViewModel {
    self.type = GNOrderFromSubmit;
    [self.viewModel hd_bindView:self.view];
    @HDWeakify(self)[self.KVOController hd_observe:self.viewModel keyPath:@"promoCode" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        BOOL empty = HDIsStringEmpty(self.viewModel.promoCode);
        self.viewModel.usePromoCodeModel.detailColor = empty ? HDAppTheme.color.gn_888888 : HDAppTheme.color.gn_000000;
        self.viewModel.usePromoCodeModel.image = [UIImage imageNamed:empty ? @"gn_order_more" : @"gn_order_close"];
        self.viewModel.usePromoCodeModel.rightClickEnable = !empty;
        [self getPromoCode];
    }];

    ///优惠码删除
    self.viewModel.usePromoCodeModel.block = ^(NSInteger index) {
        @HDStrongify(self);
        if (!self.viewModel.usePromoCodeModel.rightClickEnable)
            return;
        self.viewModel.promoCode = nil;
        self.viewModel.rushBuyModel.promoCodeRspModel = nil;
        [self getPromoCode];
    };
}

///优惠码
- (void)getPromoCode {
    @HDWeakify(self) if (HDIsStringEmpty(self.viewModel.promoCode)) {
        self.viewModel.rushBuyModel.promoCodeRspModel = nil;
        [self reloadCell:nil];
        [self updateSubmitInfo:YES];
        return;
    }
    [self showloading];
    [self.viewModel getPromoCodeInfoWithPromoCode:self.viewModel.promoCode completion:^(GNPromoCodeRspModel *_Nonnull rspModel, NSString *_Nonnull errorCode) {
        @HDStrongify(self);
        [self dismissLoading];
        if (!rspModel)
            self.viewModel.promoCode = nil;
        [self reloadCell:rspModel];
        [self updateSubmitInfo:YES];
    }];
}

///刷新cell
- (void)reloadCell:(GNPromoCodeRspModel *)rspModel {
    if (rspModel) {
        if ([self.viewModel.productSection.rows indexOfObject:self.viewModel.promoCodeModel] == NSNotFound) {
            [self.viewModel.productSection.rows addObject:self.viewModel.promoCodeModel];
        }
        self.viewModel.usePromoCodeModel.detail = self.viewModel.promoCode;
        self.viewModel.usePromoCodeModel.detailColor = HDAppTheme.color.gn_333Color;
        self.viewModel.promoCodeModel.detail = [NSString stringWithFormat:@"- %@", self.viewModel.rushBuyModel.promoCodeRspModel.discountAmount.thousandSeparatorAmount];
    } else {
        if ([self.viewModel.productSection.rows indexOfObject:self.viewModel.promoCodeModel] != NSNotFound) {
            [self.viewModel.productSection.rows removeObject:self.viewModel.promoCodeModel];
        }
        self.viewModel.usePromoCodeModel.detailColor = HDAppTheme.color.gn_999Color;
        self.viewModel.usePromoCodeModel.detail = WMLocalizedString(@"wm_use_promo_code", @"可使用优惠码");
        self.viewModel.promoCodeModel.detail = nil;
    }
    [self.tableView reloadData];
}

///更新支付信息
- (void)updateSubmitInfo:(BOOL)allUpdate {
    self.viewModel.subtotalModel.detail = GNFillMonEmpty(self.viewModel.rushBuyModel.subPrice);
    self.viewModel.vatModel.detail = GNFillMonEmpty(self.viewModel.rushBuyModel.vat);
    if ([self.tableView numberOfSections] > 2 && !allUpdate) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        [self.tableView reloadData];
    }
    [self.footView setGNModel:self.viewModel.rushBuyModel];
}

///抢购
- (void)getData {
    @HDWeakify(self)[self.viewModel getRushBuyDetailStoreNo:self.storeNo code:self.productCode completion:^(NSString *_Nonnull error) {
        @HDStrongify(self)[self updateUI:error];
    }];
}

- (void)updateUI:(NSString *)error {
    self.tableView.GNdelegate = self;
    if (error) {
        self.footView.hidden = YES;
        [self.tableView reloadFail];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        self.footView.hidden = NO;
        [self.tableView reloadData:NO];
        [self.tableView layoutIfNeeded];
        if (self.viewModel.rushBuyModel.block) {
            self.viewModel.rushBuyModel.block(self.viewModel.rushBuyModel.customAmount);
        }
        [self.footView setGNModel:self.viewModel.rushBuyModel];
    }
}

#pragma mark event
- (void)respondEvent:(NSObject<GNEvent> *)event {
    [super respondEvent:event];
    @HDWeakify(self)
        /// 提交下单
        if ([event.key isEqualToString:@"orderAction"]) {
        [SAWindowManager navigateToSetPhoneViewControllerWithText:[NSString stringWithFormat:SALocalizedString(@"login_new2_tip10",
                                                                                                               @"您将使用的 %@ 功能，需要您设置手机号码。请放心，手机号码经加密保护，不会对外泄露。"),
                                                                                             SALocalizedString(@"login_new2_Local Service Order", @"团购点餐")] bindSuccessBlock:^{
            @HDStrongify(self);
            [self showloading];
            @HDWeakify(self)[self.viewModel submitOrderWithInfo:self.viewModel.rushBuyModel completion:^(WMOrderSubmitRspModel *_Nonnull rspModel, NSString *_Nonnull errorCode) {
                @HDStrongify(self)[self dismissLoading];
                if (rspModel && rspModel.orderNo) {
                    self.viewModel.rushBuyModel.orderNo = rspModel.businessNo;
                    self.viewModel.rushBuyModel.aggregateOrderNo = rspModel.orderNo;
                    /// 如果是在线支付，呼起收银台
                    WMOrderAvailablePaymentType paymentType = self.viewModel.rushBuyModel.payType;
                    if ([paymentType isEqualToString:WMOrderAvailablePaymentTypeOnline]) {
                        if (self.viewModel.rushBuyModel.allPrice.doubleValue <= 0) {
                            [HDMediator.sharedInstance navigaveToGNOrderResultViewController:@{@"orderNo": GNFillEmpty(self.viewModel.rushBuyModel.orderNo)}];
                        } else {
                            [self respondEvent:[GNEvent eventKey:@"onlinePayAction" info:@{@"model": self.viewModel.rushBuyModel}]];
                        }
                    } else if ([paymentType isEqualToString:WMOrderAvailablePaymentTypeOffline]) {
                        /// 线下付款直接去详情页
                        [HDMediator.sharedInstance navigaveToGNOrderResultViewController:@{@"orderNo": GNFillEmpty(self.viewModel.rushBuyModel.orderNo)}];
                    }

                    // 首页转化漏斗
                    NSString *homeSource = HDIsStringNotEmpty(self.source) ? self.source : [NSUserDefaults.standardUserDefaults valueForKey:@"homePage_click_source"];
                    NSString *homeAssociateId = HDIsStringNotEmpty(self.associatedId) ? self.associatedId : [NSUserDefaults.standardUserDefaults valueForKey:@"homePage_click_associatedId"];
                    NSString *shortID = [SACacheManager.shared objectPublicForKey:kCacheKeyShortIDTrace];

                    [LKDataRecord.shared
                        traceEvent:@"order_submit"
                              name:[NSString stringWithFormat:@"团购_下单_%@", HDIsStringNotEmpty(homeSource) ? homeSource : @"other"]
                        parameters:
                            @{@"associatedId": HDIsStringNotEmpty(homeAssociateId) ? homeAssociateId : @"", @"orderNo": rspModel.orderNo, @"shortID": HDIsStringNotEmpty(shortID) ? shortID : @""}
                               SPM:[LKSPM SPMWithPage:@"GNStoreOrderViewController" area:@"" node:@""]];

                    // 清空缓存
                    [NSUserDefaults.standardUserDefaults setObject:@"" forKey:@"homePage_click_source"];
                    [NSUserDefaults.standardUserDefaults setObject:@"" forKey:@"homePage_click_associatedId"];

                }
                ///信息有变更 重新请求
                else if (!rspModel && [errorCode isEqualToString:GNPayErrorTypeChange]) {
                    [self getData];
                }
                ///商品已下架
                else if (!rspModel && ([errorCode isEqualToString:GNPayErrorTypeProductUp] || [errorCode isEqualToString:GNPayErrorTypeSolded])) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameProductUp object:nil];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            }];
        }
                                                  cancelBindBlock:nil];
    }
    /// 购买数量改变
    else if ([event.key isEqualToString:@"numChange"]) {
        if (event.info[@"data"] && [event.info[@"data"] isKindOfClass:GNOrderRushBuyModel.class]) {
            self.viewModel.rushBuyModel = event.info[@"data"];
        }
        [self updateSubmitInfo:NO];
    }
}

#pragma mark GNTableViewProtocol
- (NSArray<GNSectionModel *> *)numberOfSectionsInGNTableView:(GNTableView *)tableView {
    return self.viewModel.dataSource;
}

- (void)GNTableView:(GNTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath data:(id<GNRowModelProtocol>)rowData {
    /// 跳转商家详情
    if ([NSStringFromClass(rowData.cellClass) isEqualToString:@"GNStoreDetailTimeTableViewCell"]) {
        [HDMediator.sharedInstance navigaveToGNStoreDetailViewController:@{@"storeNo": self.storeNo}];
    } else if ([NSStringFromClass(rowData.cellClass) isEqualToString:@"GNCommonCell"] && [rowData isKindOfClass:GNCellModel.class]) {
        GNCellModel *model = (GNCellModel *)rowData;
        /// 支付方式
        if ([model.tag isEqualToString:@"selectPay"]) {
            [self adjustShowChoosePaymentMethodView:model];
        }
        ///优惠码
        else if ([model.tag isEqualToString:@"promoCode"] && model.cellClickEnable) {
            [self showInputPromoCodeAlert];
        }
        ///预约
        else if ([model.tag isEqualToString:@"reserve"]) {
            @HDWeakify(self) void (^callback)(GNReserveRspModel *_Nullable) = ^(GNReserveRspModel *rspModel) {
                @HDStrongify(self) self.viewModel.reserveModel.object = rspModel;
                if (rspModel) {
                    self.viewModel.reserveModel.detail = [SAGeneralUtil getDateStrWithTimeInterval:rspModel.reservationTime.doubleValue / 1000 format:@"dd/MM/yyyy HH:mm"];
                    self.viewModel.reserveModel.detailColor = HDAppTheme.color.gn_333Color;
                    self.viewModel.reserveModel.image = [UIImage imageNamed:@"gn_order_close"];
                    self.viewModel.reserveModel.rightClickEnable = YES;
                    ///预约信息删除
                    self.viewModel.reserveModel.block = ^(NSInteger index) {
                        @HDStrongify(self);
                        [self clearReserviInfo];
                        [self.tableView reloadData];
                    };
                } else {
                    [self clearReserviInfo];
                }
                [self.tableView reloadData];
            };
            [HDMediator.sharedInstance navigaveToGNOrderReserveViewController:@{@"callback": callback, @"storeNo": self.storeNo, @"reserveModel": self.viewModel.reserveModel.object}];
        }
    }
}

///清除预约信息
- (void)clearReserviInfo {
    self.viewModel.reserveModel.detail = GNLocalizedString(@"gn_can_be_booked_in_advance", @"Prior reservation");
    ;
    self.viewModel.reserveModel.image = [UIImage imageNamed:@"gn_order_more"];
    self.viewModel.reserveModel.detailColor = HDAppTheme.color.gn_999Color;
    self.viewModel.reserveModel.rightClickEnable = NO;
    self.viewModel.reserveModel.object = nil;
}

- (void)adjustShowChoosePaymentMethodView:(GNCellModel *)cellModel {
    NSArray<WMOrderAvailablePaymentType> *paymentMethods = @[];
    if ([self.viewModel.rushBuyModel.paymentMethod.codeId isEqualToString:GNPayMetnodTypeAll]) {
        paymentMethods = @[WMOrderAvailablePaymentTypeOnline, WMOrderAvailablePaymentTypeOffline];
    } else if ([self.viewModel.rushBuyModel.paymentMethod.codeId isEqualToString:GNPayMetnodTypeOnline]) {
        paymentMethods = @[WMOrderAvailablePaymentTypeOnline];
    } else if ([self.viewModel.rushBuyModel.paymentMethod.codeId isEqualToString:GNPayMetnodTypeCash]) {
        paymentMethods = @[WMOrderAvailablePaymentTypeOffline];
    } else {
        return;
    }
    NSMutableArray<WMOrderSubmitPaymentMethodCellModel *> *dataSource = [NSMutableArray arrayWithCapacity:2];
    if ([paymentMethods containsObject:WMOrderAvailablePaymentTypeOnline]) {
        WMOrderSubmitPaymentMethodCellModel *model = WMOrderSubmitPaymentMethodCellModel.new;
        model.paymentType = WMOrderAvailablePaymentTypeOnline;
        model.title = WMLocalizedString(@"order_payment_method_online", @"在线支付");
        model.subTitle = WMLocalizedString(@"pay_online_tips", @"We support these online payment methods:");
        NSArray<NSString *> *supportChannelArray = [SACacheManager.shared objectForKey:kCacheKeyYumNowPaymentToolsCache type:SACacheTypeCachePublic];
        if (supportChannelArray.count) {
            model.imageNames = [NSArray arrayWithArray:supportChannelArray];
        } else {
            NSString *supportChannelStr = [SAAppSwitchManager.shared switchForKey:SAAppSwitchPaymentChannelList];
            model.imageNames = [NSJSONSerialization JSONObjectWithData:[supportChannelStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        }

        [dataSource addObject:model];
    }
    if ([paymentMethods containsObject:WMOrderAvailablePaymentTypeOffline]) {
        WMOrderSubmitPaymentMethodCellModel *model = WMOrderSubmitPaymentMethodCellModel.new;
        model.paymentType = WMOrderAvailablePaymentTypeOffline;
        model.title = GNLocalizedString(@"gn_order_cash", @"到店付款");
        [dataSource addObject:model];
    }

    HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
    config.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(15), 0, kRealWidth(15));
    config.title = WMLocalizedString(@"order_choose_payment_method_title", @"选择支付方式");
    config.style = HDCustomViewActionViewStyleClose;
    config.iPhoneXFillViewBgColor = UIColor.whiteColor;
    config.contentHorizontalEdgeMargin = 0;
    config.textAlignment = HDCustomViewActionViewTextAlignmentCenter;
    const CGFloat width = kScreenWidth - config.contentHorizontalEdgeMargin * 2;
    WMOrderSubmitChoosePaymentMethodView *view = [[WMOrderSubmitChoosePaymentMethodView alloc] initWithFrame:CGRectMake(0, 0, width, 10)];
    [view configureDataSource:dataSource];
    view.currentPaymentType = self.viewModel.rushBuyModel.payType;
    [view layoutyImmediately];
    HDCustomViewActionView *actionView = [HDCustomViewActionView actionViewWithContentView:view config:config];
    @HDWeakify(actionView);
    @HDWeakify(self) view.selectedItemHandler = ^(WMOrderSubmitPaymentMethodCellModel *model) {
        @HDStrongify(actionView);
        @HDStrongify(self)[actionView dismiss];
        cellModel.detail = model.title;
        cellModel.detailColor = HDAppTheme.color.gn_333Color;
        self.viewModel.rushBuyModel.payType = model.paymentType;
        // 保存用户选择的支付方式
        [SACacheManager.shared setObject:model.paymentType forKey:kCacheKeyGroupBuyUserLastTimeChoosedPaymentMethod type:SACacheTypeDocumentNotPublic];

        [self.tableView reloadData];
    };
    [actionView show];
}

///优惠码弹窗
- (void)showInputPromoCodeAlert {
    GNPromoCodeView *contentView = [[GNPromoCodeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - kRealWidth(75), kRealWidth(114))];
    contentView.textField.text = self.viewModel.promoCode;
    HDAlertViewConfig *config = HDAlertViewConfig.new;
    UIEdgeInsets containerViewEdgeInsets = config.containerViewEdgeInsets;
    containerViewEdgeInsets.top = kRealWidth(28);
    config.containerViewEdgeInsets = containerViewEdgeInsets;
    config.titleFont = [HDAppTheme.font gn_boldForSize:16];
    HDAlertView *alertView = [HDAlertView alertViewWithTitle:WMLocalizedString(@"notice", @"提示") contentView:contentView config:config];
    alertView.canBecomeKeyWindow = true;
    HDAlertViewButton *button = [HDAlertViewButton buttonWithTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons") type:HDAlertViewButtonTypeCustom
                                                           handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                                               [alertView dismiss];
                                                               HDLog(@"%@", contentView.textField.text);
                                                               self.viewModel.promoCode = contentView.textField.text;
                                                           }];
    button.backgroundColor = UIColor.whiteColor;

    HDAlertViewButton *cancelButton = [HDAlertViewButton buttonWithTitle:WMLocalizedString(@"wm_button_cancel", @"取消") type:HDAlertViewButtonTypeCancel
                                                                 handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                                                     [alertView dismiss];
                                                                 }];
    [alertView addButtons:@[cancelButton, button]];
    [alertView show];
    [alertView.containerView setFollowKeyBoardConfigEnable:true margin:10 refView:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [contentView.textField becomeFirstResponder];
    });
}

- (GNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[GNTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.needRefreshHeader = NO;
        _tableView.needShowErrorView = YES;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = HDAppTheme.color.gn_mainBgColor;
        _tableView.provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            return [GNStoreOrderProductTableViewCell cellWithTableView:tableview];
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [GNStoreOrderProductTableViewCell skeletonViewHeight];
        }];
        _tableView.provider.numberOfRowsInSection = 2;
        _tableView.delegate = _tableView.provider;
        _tableView.dataSource = _tableView.provider;
    }
    return _tableView;
}

- (GNOrderSubmitViewModel *)viewModel {
    return _viewModel ?: ({ _viewModel = GNOrderSubmitViewModel.new; });
}

- (GNStoreOrderFootView *)footView {
    if (!_footView) {
        _footView = GNStoreOrderFootView.new;
        _footView.hidden = YES;
    }
    return _footView;
}

- (BOOL)needLogin {
    return YES;
}

- (BOOL)needClose {
    return YES;
}

@end
