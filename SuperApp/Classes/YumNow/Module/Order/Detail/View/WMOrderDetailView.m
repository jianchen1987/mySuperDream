//
//  WMOrderDetailView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderDetailView.h"
#import "HDCheckStandPresenter.h"
#import "SAInfoView.h"
#import "SAMapView.h"
#import "SAOrderListDTO.h"
#import "SAShoppingAddressModel.h"
#import "WMAnnotaionView.h"
#import "WMCustomViewActionView.h"
#import "WMOrderDetailCancelReasonView.h"
#import "WMOrderDetailContainerView.h"
#import "WMOrderDetailDeliveryInfoView.h"
#import "WMOrderDetailDeliveryRiderRspModel.h"
#import "WMOrderDetailMainInfoView.h"
#import "WMOrderDetailNaviBar.h"
#import "WMOrderDetailOrderInfoView.h"
#import "WMOrderDetailRspModel.h"
#import "WMOrderDetailStatusView.h"
#import "WMOrderDetailViewModel.h"
#import "WMOrderFeedBackView.h"
#import "WMOrderNoticeView.h"
#import "WMOrderRefundDTO.h"
#import "WMOrderDetailTelegramView.h"


@interface WMOrderDetailView () <UIScrollViewDelegate, HDCheckStandViewControllerDelegate, SAMapViewDelegate>
/// 地图
@property (nonatomic, strong) SAMapView *mapView;
/// 撑大 UIScrollView 的 UIView
@property (nonatomic, strong) WMOrderDetailContainerView *containerView;
/// VM
@property (nonatomic, strong) WMOrderDetailViewModel *viewModel;
/// 状态信息
@property (nonatomic, strong) WMOrderDetailStatusView *statusView;
/// 问题反馈
@property (nonatomic, strong) WMOrderFeedBackView *feedBackView;
/// 退款详情
@property (nonatomic, strong) SAInfoView *refundDetailView;
/// 配送费退款详情
@property (nonatomic, strong) SAInfoView *refundShippDetailView;
/// 退款View
@property (nonatomic, strong) UIView *refundView;
/// 修改地址View
@property (nonatomic, strong) SAInfoView *changeAddressView;
/// 商品和金额信息
@property (nonatomic, strong) WMOrderDetailMainInfoView *mainInfoView;
/// 配送信息
@property (nonatomic, strong) WMOrderDetailDeliveryInfoView *deliveryInfoView;
/// 订单信息
@property (nonatomic, strong) WMOrderDetailOrderInfoView *orderInfoView;
/// 订单列表 DTO
@property (nonatomic, strong) SAOrderListDTO *orderListDTO;
/// 阴影
@property (nonatomic, strong) UIView *shadowView;
/// 变化部分的高度
@property (nonatomic, assign) CGFloat mutativeHeight;
/// 是否拉下 ScrollView
@property (nonatomic, assign) BOOL shouldDropDownScrollView;
/// 收货人大头针
@property (nonatomic, strong) WMAnnotation *receiverAnnotation;
/// 商家大头针
@property (nonatomic, strong) WMAnnotation *storeAnnotation;
/// 配送员大头针
@property (nonatomic, strong) WMAnnotation *riderAnnotation;
/// 记录是否执行过收起、展开动作
@property (nonatomic, assign) BOOL hasProcesedDropUpOrDownScrollViewAction;
/// 退款 DTO
@property (nonatomic, strong) WMOrderRefundDTO *refundDTO;
/// 支付页面
@property (nonatomic, strong) HDCheckStandViewController *checkStandVC;
/// 顶部提示
@property (nonatomic, strong) WMOrderNoticeView *noticeView;
/// 导航栏
@property (nonatomic, strong) WMOrderDetailNaviBar *naviBar;
/// change
/// 状态描述
@property (nonatomic, strong) YYLabel *changStatusLB;
/// 状态描述
@property (nonatomic, strong) UIView *changeStatusView;
/// 绑telegram
@property (nonatomic, strong) WMOrderDetailTelegramView *telegramView;

@end


@implementation WMOrderDetailView
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.WMColor.bgGray;
    self.scrollView.delegate = self;
    [self addSubview:self.mapView];
    [self addSubview:self.shadowView];
    [self addSubview:self.changeStatusView];
    [self addSubview:self.scrollView];
    [self addSubview:self.naviBar];
    [self.scrollView addSubview:self.containerView];
    [self.containerView addSubview:self.changStatusLB];
    [self.containerView addSubview:self.noticeView];
    [self.containerView addSubview:self.statusView];
    [self.containerView addSubview:self.feedBackView];
    [self.containerView addSubview:self.telegramView];
    ///退款
    [self.containerView addSubview:self.refundView];
    [self.refundView addSubview:self.refundDetailView];
    [self.refundView addSubview:self.refundShippDetailView];
    ///修改地址
    [self.containerView addSubview:self.changeAddressView];

    [self.containerView addSubview:self.mainInfoView];
    [self.containerView addSubview:self.deliveryInfoView];
    [self.containerView addSubview:self.orderInfoView];

    [self hideMapView];

    @HDWeakify(self);
    self.statusView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        @HDStrongify(self);
        self.mutativeHeight = CGRectGetHeight(self.frame) - CGRectGetMaxY(self.statusView.frame) - kNavigationBarH - kRealWidth(83);
        [self dealingWithScrollViewStatus];
    };

    // 显示骨架 loading
    [self showSkeletonView];
}

- (void)updateConstraints {
    CGFloat leftL = kRealWidth(8);
    CGFloat rightL = kRealWidth(8);
    [self.statusView layoutIfNeeded];
    [self.mapView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.changeStatusView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(kRealWidth(300));
    }];

    [self.naviBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(kNavigationBarH);
    }];

    [self.shadowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.mapView);
    }];

    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.equalTo(self);
        make.top.equalTo(self.naviBar.mas_bottom);
    }];

    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
//        make.height.mas_greaterThanOrEqualTo(kScreenHeight - kNavigationBarH);
    }];

    __block UIView *topView;
    [self.changStatusLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.changStatusLB.alpha > 0) {
            make.left.mas_equalTo(kRealWidth(15));
            make.right.mas_equalTo(-kRealWidth(15));
            make.top.equalTo(self.containerView).offset(kRealWidth(12));
            topView = self.changStatusLB;
        }
    }];

    [self.noticeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.noticeView.isHidden) {
            if (topView) {
                make.top.equalTo(topView.mas_bottom).offset(kRealWidth(12));
            } else {
                make.top.equalTo(self.containerView).offset(kRealWidth(12));
            }
            make.left.mas_equalTo(leftL);
            make.right.mas_equalTo(-rightL);
            topView = self.noticeView;
        }
    }];

    [self.statusView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (topView) {
            make.top.equalTo(topView.mas_bottom).offset(kRealWidth(12));
        } else {
            make.top.equalTo(self.containerView).offset(kRealWidth(12));
        }
        make.left.mas_equalTo(leftL);
        make.right.mas_equalTo(-rightL);
        topView = self.statusView;
    }];

    [self.telegramView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.telegramView.isHidden) {
            make.top.equalTo(topView.mas_bottom).offset(kRealWidth(8));
            make.left.mas_equalTo(leftL);
            make.right.mas_equalTo(-rightL);
            topView = self.telegramView;
        }
    }];

    [self.feedBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.feedBackView.isHidden) {
            make.top.equalTo(topView.mas_bottom).offset(kRealWidth(8));
            make.left.mas_equalTo(leftL);
            make.right.mas_equalTo(-rightL);
            topView = self.feedBackView;
        }
    }];

    [self.changeAddressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.changeAddressView.isHidden) {
            make.top.equalTo(topView.mas_bottom).offset(kRealWidth(8));
            make.left.mas_equalTo(leftL);
            make.right.mas_equalTo(-rightL);
            topView = self.changeAddressView;
        }
    }];

    NSArray<SAInfoView *> *visitView = [self.refundView.subviews hd_filterWithBlock:^BOOL(__kindof UIView *_Nonnull item) {
        return [item isKindOfClass:SAInfoView.class] && !item.isHidden;
    }];
    self.refundView.hidden = HDIsArrayEmpty(visitView);
    [self.refundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.refundView.isHidden) {
            make.top.equalTo(topView.mas_bottom).offset(kRealWidth(8));
            make.left.mas_equalTo(leftL);
            make.right.mas_equalTo(-rightL);
            topView = self.refundView;
        }
    }];

    __block UIView *tepView = nil;
    [visitView enumerateObjectsUsingBlock:^(__kindof SAInfoView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.model.lineWidth = HDAppTheme.WMValue.line;
        if (idx == visitView.count - 1) {
            obj.model.lineWidth = 0;
        }
        [obj setNeedsUpdateContent];
        [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            if (!tepView) {
                make.top.mas_equalTo(0);
            } else {
                make.top.equalTo(tepView.mas_bottom);
            }
            make.bottom.mas_lessThanOrEqualTo(0);
        }];
        tepView = obj;
    }];

    [self.mainInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(kRealWidth(8));
        make.left.mas_equalTo(leftL);
        make.right.mas_equalTo(-rightL);
    }];

    [self.deliveryInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.deliveryInfoView.isHidden) {
            make.top.equalTo(self.mainInfoView.mas_bottom).offset(kRealWidth(8));
            make.left.mas_equalTo(leftL);
            make.right.mas_equalTo(-rightL);
        }
    }];

    [self.orderInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.deliveryInfoView.isHidden) {
            make.top.equalTo(self.deliveryInfoView.mas_bottom).offset(kRealWidth(8));
        } else {
            make.top.equalTo(self.mainInfoView.mas_bottom).offset(kRealWidth(8));
        }
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(8) - kiPhoneXSeriesSafeBottomHeight);
        make.left.mas_equalTo(leftL);
        make.right.mas_equalTo(-rightL);
    }];

    [super updateConstraints];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"orderDetailRspModel" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        WMOrderDetailRspModel *orderDetailRspModel = change[NSKeyValueChangeNewKey];
        self.naviBar.backgroundColor = UIColor.clearColor;
        self.statusView.statusTitleLB.hidden = self.statusView.statusDetailLB.hidden = NO;
        if (!self.viewModel.shouldHideMap) {
            self.shouldDropDownScrollView = true;
            // 设置收货人和门店位置大头针
            self.receiverAnnotation.coordinate
                = CLLocationCoordinate2DMake(orderDetailRspModel.orderDetailForUser.receiver.receiverLat.doubleValue, orderDetailRspModel.orderDetailForUser.receiver.receiverLon.doubleValue);

            self.storeAnnotation.logoImageURL = orderDetailRspModel.merchantStoreDetail.logo;
            self.storeAnnotation.coordinate = CLLocationCoordinate2DMake(orderDetailRspModel.merchantStoreDetail.latitude.doubleValue, orderDetailRspModel.merchantStoreDetail.longitude.doubleValue);

            // 根据业务状态显示
            WMBusinessStatus bizStatus = orderDetailRspModel.orderDetailForUser.bizState;
            if (bizStatus == WMBusinessStatusWaitingOrderReceiving) {
                self.storeAnnotation.tipTitle = WMLocalizedString(@"order_detail_accept_soon", @"等待商家接单");
            } else if (bizStatus == WMBusinessStatusMerchantAcceptedOrder) {
                if (orderDetailRspModel.orderDetailForUser.deliveryInfo.deliveryStatus == WMDeliveryStatusWaitingAccept || orderDetailRspModel.orderDetailForUser.deliveryInfo.deliveryStatus == WMDeliveryStatusWaitingDeploy) {
                    self.storeAnnotation.tipTitle = WMLocalizedString(@"order_submit_Waiting_for_rider_to_receive_order", @"等待骑手接单");
                }else if(orderDetailRspModel.orderDetailForUser.deliveryInfo.deliveryStatus == WMDeliveryStatusAccepted){
                    self.storeAnnotation.tipTitle = @"";
                }else{
                    self.storeAnnotation.tipTitle = WMLocalizedString(@"order_detail_preparing", @"备餐中");
                }
            }else{
                self.storeAnnotation.tipTitle = @"";
            }

            [self.mapView.mapView removeAnnotations:@[self.receiverAnnotation, self.storeAnnotation]];
            [self.mapView.mapView addAnnotations:@[self.receiverAnnotation, self.storeAnnotation]];
            [self updateMapViewCenterAndLeavel];
        } else {
            self.shouldDropDownScrollView = false;
        }
        if (!HDIsObjectNil(orderDetailRspModel)) {
            [self.mainInfoView configureWithOrderDetailRspModel:orderDetailRspModel];
        }
        if (!HDIsObjectNil(orderDetailRspModel.orderInfo)) {
            [self.orderInfoView configureWithOrderDetailRspModel:orderDetailRspModel];
        }

        if (!HDIsObjectNil(orderDetailRspModel.orderDetailForUser)) {
            self.deliveryInfoView.hidden = orderDetailRspModel.orderDetailForUser.serviceType == 20;
            if (!self.deliveryInfoView.hidden) {
                [self.deliveryInfoView configureWithOrderDetailModel:orderDetailRspModel.orderDetailForUser];
            }
            [self.statusView configureWithOrderDetailModel:orderDetailRspModel.orderDetailForUser storeInfoModel:orderDetailRspModel.merchantStoreDetail orderSimpleInfo:orderDetailRspModel.orderInfo];
        }

        NSMutableAttributedString *mstr = NSMutableAttributedString.new;
        [mstr appendAttributedString:self.statusView.statusTitleLB.attributedText];
        mstr.yy_font = [HDAppTheme.WMFont wm_boldForSize:20];
        mstr.yy_color = UIColor.whiteColor;
        self.changStatusLB.attributedText = [self.statusView statusTitleLBAttributedStringWithTitle:self.statusView.statusTitle arrowColor:UIColor.whiteColor
                                                                                               font:[HDAppTheme.WMFont wm_boldForSize:20]];
        if (!self.shouldDropDownScrollView) {
            self.statusView.statusTitleLB.hidden = YES;
            [self.statusView setNeedsUpdateConstraints];
        } else {
            self.statusView.statusDetailLB.hidden = YES;
            [self.statusView setNeedsUpdateConstraints];
        }
        [self.naviBar setNeedsUpdateConstraints];

        /// 退款申请中
        //        self.refundDetailView.hidden = HDIsObjectNil(orderDetailRspModel.orderDetailForUser.refundInfo);
        //新增货到付款的退款时，隐藏退款详情
        self.refundDetailView.hidden = HDIsObjectNil(orderDetailRspModel.orderDetailForUser.refundInfo) || (orderDetailRspModel.orderDetailForUser.paymentMethod == 10);
        if (!self.refundDetailView.isHidden) {
            NSString *refundStateDesc = @"";
            WMBusinessStatus bizStatus = orderDetailRspModel.orderDetailForUser.bizState;
            if (bizStatus == WMBusinessStatusOrderCancelled) {
                if (orderDetailRspModel.orderDetailForUser.refundInfo.refundState == WMOrderDetailRefundStateSuccess) {
                    refundStateDesc = WMLocalizedString(@"refunded_success", @"退款成功");
                } else if (orderDetailRspModel.orderDetailForUser.refundInfo.refundState == WMOrderDetailRefundStateApplying) {
                    // 只要不是退款成功并且不是退款申请中，都显示退款中
                    refundStateDesc = WMLocalizedString(@"refunding", @"退款中");
                }
            }
            self.refundDetailView.model.valueText = refundStateDesc;
            [self.refundDetailView setNeedsUpdateContent];
        }

        ///反馈
        BOOL feedBackHidden = YES;
        if (orderDetailRspModel.orderDetailForUser.bizState == WMBusinessStatusCompleted) {
            if ([orderDetailRspModel.orderDetailForUser.postSaleShowType isEqualToString:WMOrderFeedBackStepNone]) {
                ///大于60天隐藏反馈入口
                if (self.viewModel.orderDetailRspModel.orderDetailForUser.finishTime.doubleValue) {
                    feedBackHidden = NSDate.date.timeIntervalSince1970 - self.viewModel.orderDetailRspModel.orderDetailForUser.finishTime.doubleValue / 1000.0 > 60 * 24 * 60 * 60;
                } else {
                    feedBackHidden = NO;
                }
            } else {
                feedBackHidden = NO;
            }
        }
        self.feedBackView.hidden = feedBackHidden;

        self.feedBackView.hasPostSale = orderDetailRspModel.orderDetailForUser.hasPostSale;
        self.feedBackView.handleStatus = orderDetailRspModel.orderDetailForUser.handleStatus;
        self.feedBackView.postSaleShowType = orderDetailRspModel.orderDetailForUser.postSaleShowType;
        [self.feedBackView updateContent];

        ///特殊配送
        self.noticeView.showTip = orderDetailRspModel.orderDetailForUser.timeRemark.desc;
        self.noticeView.hidden = !orderDetailRspModel.orderDetailForUser.increaseTimeFlag;
        if ([self.noticeView.showTip isKindOfClass:NSString.class] && !self.noticeView.showTip.length) {
            self.noticeView.hidden = YES;
        }
        if (orderDetailRspModel.orderDetailForUser.bizState == WMBusinessStatusCompleted || orderDetailRspModel.orderDetailForUser.bizState == WMBusinessStatusOrderCancelled) {
            self.noticeView.hidden = YES;
        }
        
        if(orderDetailRspModel.orderDetailForUser.serviceType == 20) {
            self.noticeView.hidden = YES;
        }
        

        /// 修改地址退款申请中
        self.refundShippDetailView.hidden
            = (HDIsObjectNil(orderDetailRspModel.orderDetailForUser.updateAddressRefundInfo) || !orderDetailRspModel.orderDetailForUser.updateAddressRefundInfo.aggregateNo);
        if (!self.refundShippDetailView.isHidden) {
            NSString *refundStateDesc = @"";
            if (orderDetailRspModel.orderDetailForUser.updateAddressRefundInfo.refundState == WMOrderDetailRefundStateSuccess) {
                refundStateDesc = WMLocalizedString(@"refunded_success", @"退款成功");
            } else if (orderDetailRspModel.orderDetailForUser.updateAddressRefundInfo.refundState == WMOrderDetailRefundStateApplying) {
                refundStateDesc = WMLocalizedString(@"refunding", @"退款中");
            }
            self.refundShippDetailView.model.valueText = refundStateDesc;
            [self.refundShippDetailView setNeedsUpdateContent];
        }

        ///修改地址记录
        self.changeAddressView.hidden = !orderDetailRspModel.orderDetailForUser.isUpdateAddressHistory || orderDetailRspModel.orderDetailForUser.bizState == WMBusinessStatusOrderCancelled;
        if (!self.changeAddressView.isHidden) {
            if (orderDetailRspModel.orderDetailForUser.isUpdateAddress == WMOrderModifyING) {
                self.changeAddressView.model.keyText = WMLocalizedString(@"wm_modify_address_edit_view_detail", @"You are editing the delivery address");
                self.changeAddressView.model.keyImage = [UIImage imageNamed:@"yn_address_editing"];
            } else {
                self.changeAddressView.model.keyText = WMLocalizedString(@"wm_modify_address_record", @"Address modification record");
                self.changeAddressView.model.keyImage = [UIImage imageNamed:@"yn_address_edithistory"];
            }
            [self.changeAddressView setNeedsUpdateContent];
            [self.changeAddressView updateConstraints];
        }
        /// tg
        self.telegramView.hidden = !self.viewModel.TGBotLink;

        [self setNeedsUpdateConstraints];

        // statusView 可能不变
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dealingWithScrollViewStatus];
        });
        [self scrollViewDidScroll:self.scrollView];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"deliveryRiderRspModel" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        WMOrderDetailDeliveryRiderRspModel *deliveryRiderRspModel = change[NSKeyValueChangeNewKey];
        // 骑手接单后才显示
        BOOL isEventListContainsDeliverReceiveEvent = false;
        for (WMOrderEventModel *eventModel in self.viewModel.orderDetailRspModel.orderDetailForUser.orderEventList) {
            if (eventModel.eventType == WMOrderEventTypeDeliverReceive) {
                isEventListContainsDeliverReceiveEvent = true;
                break;
            }
        }

        if (!self.mapView.isHidden && !HDIsObjectNil(deliveryRiderRspModel) && isEventListContainsDeliverReceiveEvent) {
            [self.mapView.mapView removeAnnotation:self.riderAnnotation];
            self.riderAnnotation.coordinate = CLLocationCoordinate2DMake(deliveryRiderRspModel.lat.doubleValue, deliveryRiderRspModel.lon.doubleValue);
            // 计算收货地址和骑手距离
            CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:self.viewModel.orderDetailRspModel.orderDetailForUser.receiver.receiverLat.doubleValue
                                                                  longitude:self.viewModel.orderDetailRspModel.orderDetailForUser.receiver.receiverLon.doubleValue];
            CLLocation *riderLocation = [[CLLocation alloc] initWithLatitude:deliveryRiderRspModel.lat.doubleValue longitude:deliveryRiderRspModel.lon.doubleValue];
            CLLocationDistance distance = [HDLocationUtils distanceFromLocation:userLocation toLocation:riderLocation];

            WMDeliveryStatus status = self.viewModel.orderDetailRspModel.orderDetailForUser.deliveryInfo.deliveryStatus;
            if (status == WMDeliveryStatusArrivedMerchant) {
                self.riderAnnotation.tipTitle = WMLocalizedString(@"pick_up", @"取餐中");
            } else if (status == WMDeliveryStatusAccepted) {
                CLLocation *merchantLocation = [[CLLocation alloc] initWithLatitude:self.viewModel.orderDetailRspModel.merchantStoreDetail.latitude.doubleValue
                                                                          longitude:self.viewModel.orderDetailRspModel.merchantStoreDetail.longitude.doubleValue];
                CLLocationDistance riderToStore = [HDLocationUtils distanceFromLocation:riderLocation toLocation:merchantLocation];
                self.riderAnnotation.tipTitle = [NSString stringWithFormat:WMLocalizedString(@"some_meters_from_store", @"%.0f meters from store."), riderToStore];

            } else {
                self.riderAnnotation.tipTitle = [NSString stringWithFormat:WMLocalizedString(@"order_detail_distance_from_you", @"还有%.0f米到达"), distance];
            }

            [self.mapView.mapView addAnnotations:@[self.riderAnnotation]];
            [self updateMapViewCenterAndLeavel];
        }
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"TGBotLink" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self) self.telegramView.hidden = !self.viewModel.TGBotLink;
        [self setNeedsUpdateConstraints];
    }];
}

#pragma mark 修改地址
- (void)modifyAddressAction {
    [HDMediator.sharedInstance navigaveToModifyOrderAddressViewController:@{
        @"orderDetailRspModel": self.viewModel.orderDetailRspModel,
        @"orderNo": self.viewModel.orderNo,
        @"storeNo": self.viewModel.storeNo,
        @"fee": self.mainInfoView.deliveryFeeView.model.associatedObject,
    }];
}

#pragma mark 确认取餐
- (void)submitPickUpAction {
    @HDWeakify(self);
    HDAlertView *alert = [HDAlertView alertViewWithTitle:WMLocalizedString(@"wm_pickup_Kind reminder", @"温馨提示") message:WMLocalizedString(@"wm_pickup_tips03", @"您确定已收到商品吗？")
                                                  config:nil];
    [alert addButton:[HDAlertViewButton buttonWithTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") type:HDAlertViewButtonTypeCancel
                                                handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                                    [alertView dismiss];
                                                }]];

    [alert addButton:[HDAlertViewButton buttonWithTitle:SALocalizedStringFromTable(@"confirm", @"确认", @"Buttons") type:HDAlertViewButtonTypeCustom
                                                handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                                    [alertView dismiss];
                                                    @HDStrongify(self);

                                                    [self showloading];
                                                    @HDWeakify(self);
                                                    [self.orderListDTO submitPickUpOrderWithOrderNo:self.viewModel.orderNo success:^{
                                                        @HDStrongify(self);
                                                        [self dismissLoading];
                                                        // 重新获取订单详情
                                                        [self.viewModel getOrderDetailSuccess:nil failure:nil];
                                                    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                                                        @HDStrongify(self);
                                                        [self dismissLoading];
                                                    }];
                                                }]];


    [alert show];
}

#pragma mark 确认订单
- (void)confirmOrder {
    [self showloading];
    @HDWeakify(self);
    [self.orderListDTO confirmOrderWithOrderNo:self.viewModel.orderNo success:^{
        @HDStrongify(self);
        [self dismissLoading];
        // 重新获取订单详情
        [self.viewModel getOrderDetailSuccess:nil failure:nil];
        [NAT showAlertWithMessage:WMLocalizedString(@"thanks_for_your_order", @"感谢你的下单！") buttonTitle:WMLocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                          handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                              [alertView dismiss];
                          }];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

#pragma mark 取消订单 带原因
- (void)cancelOrder {
    [self showloading];
    @HDWeakify(self);
    [self.viewModel userCancelOrderReasonSuccess:^(NSArray<WMOrderCancelReasonModel *> *_Nonnull rspModel, BOOL error) {
        @HDStrongify(self);
        [self dismissLoading];
        if ([rspModel isKindOfClass:NSArray.class]) {
            WMOrderDetailCancelReasonView *reasonView = [[WMOrderDetailCancelReasonView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            reasonView.dataSource = rspModel;
            [reasonView layoutyImmediately];
            WMCustomViewActionView *actionView = [WMCustomViewActionView actionViewWithContentView:reasonView block:^(HDCustomViewActionViewConfig *_Nullable config) {
                config.title = WMLocalizedString(@"wm_cancel_reason_title", @"订单取消");
                config.shouldAddScrollViewContainer = YES;
            }];
            [actionView show];
            reasonView.clickedConfirmBlock = ^(WMOrderCancelReasonModel *_Nonnull model) {
                @HDStrongify(self);
                [actionView dismiss];
                [self requestOrderCancel:model];
            };
        }
    }];
}

#pragma mark 取消订单 不带原因
- (void)requestOrderCancel:(nullable WMOrderCancelReasonModel *)model {
    [self showloading];
    @HDWeakify(self);
    [self.viewModel userCancelOrderWithCancelReason:model success:^(WMOrderDetailCancelOrderRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];
        [self.viewModel getOrderDetailSuccess:nil failure:nil];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
        [self.viewModel getOrderDetailSuccess:nil failure:nil];
    }];
}

#pragma mark 催单
- (void)urgeOrder {
    [self showloading];
    @HDWeakify(self);
    [self.viewModel userUrgeOrderSuccess:^{
        @HDStrongify(self);
        [self dismissLoading];
        [HDTips showWithText:WMLocalizedString(@"store_reminder_process_order", @"The store has received the reminder and will process your order as soon as possible.")];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
        [HDTips showWithText:rspModel.msg];
    }];
}
#pragma mark 再来一单
- (void)onceAgainOrder {
    [HDMediator.sharedInstance navigaveToStoreDetailViewController:@{
        @"storeNo": self.viewModel.storeNo,
        @"onceAgainOrderNo": self.viewModel.orderNo,
        @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|订单详情.再来一单"] : @"订单详情.再来一单",
        @"associatedId" : self.viewModel.associatedId
    }];
}

#pragma mark 确认收货
- (void)showConfirmOrderAlert {
    [NAT showAlertWithMessage:WMLocalizedString(@"receive_goods_confirm_ask", @"是否确认收到商品？") confirmButtonTitle:WMLocalizedString(@"not_now", @"暂时不")
        confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [alertView dismiss];
        }
        cancelButtonTitle:WMLocalizedStringFromTable(@"confirm", @"确定", @"Buttons") cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [alertView dismiss];
            [self confirmOrder];
        }];
}

- (void)showCancelOrderAlert {
    [self cancelOrder];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    scrollView.isScrolling = true;

    CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
    CGFloat alpha = offsetY / self.mutativeHeight;
    alpha = alpha > 0.98 ? 1 : alpha;
    alpha = alpha < 0.02 ? 0 : alpha;
    self.shadowView.alpha = alpha;
    if (self.shouldDropDownScrollView) {
        self.statusView.statusTitleLB.alpha = 1 - alpha;
        BOOL last = self.statusView.statusTitleLB.isHidden;
        BOOL change = NO;
        if (alpha > 0.5) {
            self.statusView.statusTitleLB.hidden = YES;
            self.statusView.statusDetailLB.hidden = NO;
            if (!last)
                change = YES;
        } else {
            self.statusView.statusTitleLB.hidden = NO;
            self.statusView.statusDetailLB.hidden = YES;
            if (last)
                change = YES;
        }
        if (change) {
            [self.statusView setNeedsUpdateConstraints];
            [self setNeedsUpdateConstraints];
        }
        [self.naviBar updateUIWithScrollViewOffsetY:offsetY];
        self.changStatusLB.alpha = self.changeStatusView.alpha = alpha;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:scrollView afterDelay:0.1];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    scrollView.isScrolling = false;

    if (self.mapView.isHidden)
        return;

    // 滚动停止
    CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;

    // 临界值
    const CGFloat criticalY = self.mutativeHeight * 0.5;
    if (offsetY > 0 && offsetY < criticalY) {
        // 状态statusView下滑
        [scrollView setContentOffset:CGPointMake(0, -scrollView.contentInset.top) animated:true];
    } else if (offsetY >= criticalY && offsetY < self.mutativeHeight) {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:true];
    }
}

#pragma mark - public methods
- (void)resetDetailView {
    [self hideMapView];
    self.hasProcesedDropUpOrDownScrollViewAction = NO;
    [self.containerView hd_beginSkeletonAnimation];
}
#pragma mark - private methods
- (void)updateMapViewCenterAndLeavel {
    double latitudeDelta = 0;  // 纬度范围
    double longitudeDelta = 0; // 经度范围
    CGFloat leavel = 2.5;      // 缩放等级，越大缩的越小

    //默认用户居中
    WMAnnotation *centerAnnotation = self.receiverAnnotation;
    if ([self.mapView.mapView.annotations containsObject:self.storeAnnotation]) {
        if ([self.storeAnnotation.tipTitle isEqualToString:WMLocalizedString(@"order_detail_accept_soon", @"等待商家接单")]) {
            //待接单时，商家居中
            centerAnnotation = self.storeAnnotation;
        }
        latitudeDelta = fabs(self.storeAnnotation.coordinate.latitude - self.receiverAnnotation.coordinate.latitude) * leavel;
        longitudeDelta = fabs(self.storeAnnotation.coordinate.longitude - self.receiverAnnotation.coordinate.longitude) * leavel;
    }
    if ([self.mapView.mapView.annotations containsObject:self.riderAnnotation]) {
        //出现骑士时，骑手居中
        centerAnnotation = self.riderAnnotation;
        //骑手和用户距离比对
        latitudeDelta = MAX(fabs(self.riderAnnotation.coordinate.latitude - self.receiverAnnotation.coordinate.latitude) * leavel, latitudeDelta);
        longitudeDelta = MAX(fabs(self.riderAnnotation.coordinate.longitude - self.receiverAnnotation.coordinate.longitude) * leavel, longitudeDelta);
        //        //骑手和店家距离比对
        latitudeDelta = MAX(fabs(self.riderAnnotation.coordinate.latitude - self.storeAnnotation.coordinate.latitude) * leavel, latitudeDelta);
        longitudeDelta = MAX(fabs(self.riderAnnotation.coordinate.longitude - self.storeAnnotation.coordinate.longitude) * leavel, longitudeDelta);
    }

    [self.mapView.mapView setCenterCoordinate:centerAnnotation.coordinate animated:false];
    // 纬度范围最大180度，经度范围最大360度
    latitudeDelta = MIN(180, latitudeDelta);
    longitudeDelta = MIN(360, longitudeDelta);
    MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
    MKCoordinateRegion region = MKCoordinateRegionMake(centerAnnotation.coordinate, span);
    [self.mapView.mapView setRegion:region animated:false];
    //设置地图偏移量
    [self.mapView.mapView setVisibleMapRect:self.mapView.mapView.visibleMapRect edgePadding:UIEdgeInsetsMake(0, 0, 178 + 60 + kRealWidth(8 * 2) + 10, 0) animated:false];
}

- (void)hideMapView {
    self.scrollView.bounces = true;
    self.scrollView.alwaysBounceVertical = true;
    self.mapView.hidden = true;
    self.shadowView.hidden = true;

    self.scrollView.hd_ignoreSpace = [UIScrollViewIgnoreSpaceModel ignoreSpaceWithMinX:0 maxX:0 minY:0 maxY:0];
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:false];
}

- (void)dropDownScrollView {
    self.shadowView.hidden = false;
    self.mapView.hidden = false;
    self.scrollView.bounces = false;

    self.scrollView.contentInset = UIEdgeInsetsMake(self.mutativeHeight, 0, 0, 0);
    [self.scrollView setContentOffset:CGPointMake(0, -self.mutativeHeight) animated:false];
    self.scrollView.hd_ignoreSpace = [UIScrollViewIgnoreSpaceModel ignoreSpaceWithMinX:0 maxX:0 minY:0 maxY:self.mutativeHeight];
}

- (void)showSkeletonView {
    @HDWeakify(self);
    self.containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        @HDStrongify(self);
        // 没获取到数据
        if (!self.viewModel.hasGotInitializedData) {
            [self.containerView hd_beginSkeletonAnimation];
        }
    };
}

- (void)dealingWithScrollViewStatus {
    if (self.shouldDropDownScrollView) {
        if (!self.hasProcesedDropUpOrDownScrollViewAction) {
            [self dropDownScrollView];
            self.hasProcesedDropUpOrDownScrollViewAction = true;
        }
    } else {
        [self hideMapView];
    }

    if (self.viewModel.hasGotInitializedData) {
        // 去除骨架 loading
        [self.containerView hd_endSkeletonAnimation];
    }
}

#pragma mark - HDCheckStandViewControllerDelegate
- (void)checkStandViewControllerInitializeFailed:(HDCheckStandViewController *)controller {
    [NAT showToastWithTitle:SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试") content:nil type:HDTopToastTypeError];
}

- (void)checkStandViewControllerCompletedAndPaymentUnknow:(HDCheckStandViewController *)controller {
    [self.viewModel getOrderDetailSuccess:nil failure:nil];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentSuccess:(HDCheckStandPayResultResp *)resultResp {
    [controller dismissViewControllerAnimated:true completion:^{
        // 重新获取订单详情
        [self.viewModel getOrderDetailSuccess:nil failure:nil];
        // HDOrderStatusKnown是为了进入支付结果页重新请求数据
        [self navigationToResultPageWithStatus:HDOrderStatusKnown];
    }];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentFail:(nonnull HDCheckStandPayResultResp *)resultResp {
    [controller dismissAnimated:true completion:^{
        [self navigationToResultPageWithStatus:HDOrderStatusFailure];
    }];
}

- (void)checkStandViewControllerUserClosedCheckStand:(HDCheckStandViewController *)controller {
    HDLog(@"用户取消支付");
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller failureWithRspModel:(SARspModel *)rspModel errorType:(CMResponseErrorType)errorType error:(NSError *)error {
    [controller dismissAnimated:true completion:^{
        [NAT showToastWithTitle:@"" content:rspModel.msg type:HDTopToastTypeError];
    }];
}
//货到付款操作完成
- (void)checkStandViewControllerCashOnDeliveryCompleted:(HDCheckStandViewController *)controller bussineLine:(SAClientType)bussineLine orderNo:(NSString *)orderNo {
    [controller dismissViewControllerAnimated:true completion:^{
        if ([bussineLine isEqualToString:SAClientTypeYumNow] && HDIsStringNotEmpty(orderNo)) {
            [HDMediator.sharedInstance navigaveToOrderResultViewController:@{@"orderNo": orderNo}];
        }
    }];
}

- (void)getCheckStandViewController:(HDCheckStandViewController *)controller {
    self.checkStandVC = controller;
}

- (void)navigationToResultPageWithStatus:(HDOrderStatus)status {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    void (^orderDetailBlock)(UIViewController *) = ^(UIViewController *vc) {
        [vc.navigationController popViewControllerAnimated:NO];
    };

    params[@"orderClickBlock"] = orderDetailBlock;
    params[@"orderNo"] = self.viewModel.orderNo;
    params[@"businessLine"] = SAClientTypeYumNow;
    params[@"merchantNo"] = self.viewModel.orderDetailRspModel.merchantStoreDetail.merchantNo;

    [HDMediator.sharedInstance navigaveToCheckStandPayResultViewController:params];
}

- (void)clickedStatusTitleHandler {
    [self.statusView clickedStatusTitleHandler];
}

- (void)setShouldDropDownScrollView:(BOOL)shouldDropDownScrollView {
    _shouldDropDownScrollView = shouldDropDownScrollView;
    if (!shouldDropDownScrollView) {
        self.changeStatusView.alpha = self.changStatusLB.alpha = 1;
        [self.naviBar updateUIWithScrollViewOffsetY:kNavigationBarH];
    }
}

///绑定telegram
- (void)teleBindAction {
    if (!self.viewModel.TGBotLink)
        return;
    [UIApplication.sharedApplication openURL:[NSURL URLWithString:self.viewModel.TGBotLink] options:@{} completionHandler:^(BOOL success){

    }];
}

#pragma mark - lazy load

- (WMOrderDetailContainerView *)containerView {
    if (!_containerView) {
        _containerView = WMOrderDetailContainerView.new;
    }
    return _containerView;
}

- (SAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[SAMapView alloc] init];
    }
    return _mapView;
}

- (WMOrderDetailStatusView *)statusView {
    if (!_statusView) {
        _statusView = WMOrderDetailStatusView.new;
        @HDWeakify(self);
        _statusView.clickedConfirmOrderBlock = ^{
            @HDStrongify(self);
            [self showConfirmOrderAlert];
        };
        _statusView.clickedCancelOrderBlock = ^{
            @HDStrongify(self);
            [self showCancelOrderAlert];
        };
        _statusView.clickedPayNowBlock = ^{
            @HDStrongify(self);

            HDTradeBuildOrderModel *buildModel = [HDTradeBuildOrderModel new];
            buildModel.orderNo = self.viewModel.orderDetailRspModel.orderInfo.orderNo;
            //            buildModel.outPayOrderNo = self.viewModel.orderDetailRspModel.orderInfo.outPayOrderNo;
            buildModel.merchantNo = self.viewModel.orderDetailRspModel.merchantStoreDetail.merchantNo;
            buildModel.storeNo = self.viewModel.orderDetailRspModel.merchantStoreDetail.storeNo;
            buildModel.payableAmount = self.viewModel.orderDetailRspModel.orderDetailForUser.actualAmount;
            buildModel.businessLine = SAClientTypeYumNow;

            buildModel.needCheckPaying = YES; //需要校验重新支付的时候改成YES

            buildModel.payType = self.viewModel.orderDetailRspModel.orderInfo.paymentMethod;
            buildModel.serviceType = self.viewModel.orderDetailRspModel.orderDetailForUser.serviceType;
            [HDCheckStandPresenter payWithTradeBuildModel:buildModel preferedHeight:0 fromViewController:self.viewController delegate:self];
        };
        _statusView.clickedRefundOrderBlock = ^{
            @HDStrongify(self);
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
            params[@"orderNo"] = self.viewModel.orderNo;
            params[@"refundMoney"] = self.viewModel.orderDetailRspModel.orderDetailForUser.actualAmount;
            [HDMediator.sharedInstance navigaveToOrderRefundApplyViewController:params];
        };
        _statusView.clickedEvaluationOrderBlock = ^{
            @HDStrongify(self);
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
            params[@"orderNo"] = self.viewModel.orderNo;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.viewModel.orderDetailRspModel.orderDetailForUser.deliveryInfo.ata / 1000.0];
            NSString *dateStr = [SAGeneralUtil getDateStrWithDate:date format:@"dd/MM/yyyy HH:mm"];
            params[@"time"] = dateStr;
            params[@"storeNo"] = self.viewModel.storeNo;
            params[@"logoURL"] = self.viewModel.orderDetailRspModel.merchantStoreDetail.logo;
            params[@"storeName"] = self.viewModel.orderDetailRspModel.merchantStoreDetail.storeName.desc;
            params[@"deliveryType"] = @(self.viewModel.orderDetailRspModel.orderDetailForUser.deliveryInfo.deliverType);
            params[@"serviceType"] = @(self.viewModel.orderDetailRspModel.orderDetailForUser.serviceType);
            [HDMediator.sharedInstance navigaveToOrderEvaluationViewController:params];
        };
        _statusView.payTimerCountDownEndedBlock = ^{
            @HDStrongify(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.viewModel getOrderDetailSuccess:nil failure:nil];
            });
            [self.checkStandVC dismissAnimated:YES completion:nil];
        };
        _statusView.clickedUrgeOrderBlock = ^{
            @HDStrongify(self);
            [self urgeOrder];
        };
        _statusView.clickedOnceAgainBlock = ^{
            @HDStrongify(self);
            [self onceAgainOrder];
        };
        _statusView.clickedModifyAddressBlock = ^{
            @HDStrongify(self);
            [self modifyAddressAction];
        };
        _statusView.clickedSubmitPickUpBlock = ^{
            @HDStrongify(self);
            [self submitPickUpAction];
        };
    }
    return _statusView;
}

- (SAInfoView *)refundDetailView {
    if (!_refundDetailView) {
        _refundDetailView = SAInfoView.new;
        _refundDetailView.hidden = YES;
        SAInfoViewModel *model = SAInfoViewModel.new;
        model.lineWidth = 0;
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(12), kRealWidth(12), kRealWidth(12));
        model.rightButtonContentEdgeInsets = UIEdgeInsetsZero;
        model.enableTapRecognizer = true;
        model.keyImage = [UIImage imageNamed:@"yn_order_detail_order"];
        model.keyImagePosition = HDUIButtonImagePositionLeft;
        model.keyImageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kRealWidth(6));
        model.keyText = WMLocalizedString(@"refund_detail", @"退款详情");
        model.keyFont = [HDAppTheme.WMFont wm_ForSize:14 weight:UIFontWeightMedium];
        model.keyColor = HDAppTheme.WMColor.B3;
        model.backgroundColor = UIColor.whiteColor;
        model.valueFont = [HDAppTheme.WMFont wm_ForSize:12];
        model.valueColor = HDAppTheme.WMColor.mainRed;
        model.rightButtonImage = [UIImage imageNamed:@"yn_submit_gengd_red"];
        model.backgroundColor = UIColor.whiteColor;
        model.cornerRadius = kRealWidth(8);
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [HDMediator.sharedInstance navigaveToCommonRefundDetailViewController:@{@"aggregateOrderNo": self.viewModel.orderNo}];
        };
        _refundDetailView.model = model;
        [_refundDetailView setNeedsUpdateContent];
    }
    return _refundDetailView;
}

- (SAInfoView *)refundShippDetailView {
    if (!_refundShippDetailView) {
        _refundShippDetailView = SAInfoView.new;
        _refundShippDetailView.hidden = YES;
        SAInfoViewModel *model = SAInfoViewModel.new;
        model.lineWidth = 0;
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(12), kRealWidth(12), kRealWidth(12));
        model.rightButtonContentEdgeInsets = UIEdgeInsetsZero;
        model.enableTapRecognizer = true;
        model.keyImage = [UIImage imageNamed:@"yn_order_detail_deliver"];
        model.keyImagePosition = HDUIButtonImagePositionLeft;
        model.keyImageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kRealWidth(6));
        model.keyText = [NSString stringWithFormat:@"%@%@", WMLocalizedString(@"delivery_fee", @"配送费"), WMLocalizedString(@"refund_detail", @"退款详情")];
        model.keyFont = [HDAppTheme.WMFont wm_ForSize:14 weight:UIFontWeightMedium];
        model.keyColor = HDAppTheme.WMColor.B3;
        model.backgroundColor = UIColor.whiteColor;
        model.valueFont = [HDAppTheme.WMFont wm_ForSize:12];
        model.valueColor = HDAppTheme.WMColor.mainRed;
        model.rightButtonImage = [UIImage imageNamed:@"yn_submit_gengd_red"];
        model.backgroundColor = UIColor.whiteColor;
        model.cornerRadius = kRealWidth(8);
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [HDMediator.sharedInstance navigaveToCommonRefundDetailViewController:@{@"aggregateOrderNo": self.viewModel.orderDetailRspModel.orderDetailForUser.updateAddressRefundInfo.aggregateNo}];
        };
        _refundShippDetailView.model = model;
        [_refundShippDetailView setNeedsUpdateContent];
    }
    return _refundShippDetailView;
}

- (WMOrderDetailMainInfoView *)mainInfoView {
    if (!_mainInfoView) {
        _mainInfoView = [[WMOrderDetailMainInfoView alloc] initWithViewModel:self.viewModel];
    }
    return _mainInfoView;
}

- (WMOrderDetailDeliveryInfoView *)deliveryInfoView {
    if (!_deliveryInfoView) {
        _deliveryInfoView = WMOrderDetailDeliveryInfoView.new;
    }
    return _deliveryInfoView;
}

- (WMOrderDetailOrderInfoView *)orderInfoView {
    if (!_orderInfoView) {
        _orderInfoView = WMOrderDetailOrderInfoView.new;
    }
    return _orderInfoView;
}

- (UIView *)refundView {
    if (!_refundView) {
        _refundView = UIView.new;
        _refundView.layer.backgroundColor = UIColor.whiteColor.CGColor;
        _refundView.layer.cornerRadius = kRealWidth(8);
    }
    return _refundView;
}

- (WMOrderFeedBackView *)feedBackView {
    if (!_feedBackView) {
        @HDWeakify(self);
        _feedBackView = WMOrderFeedBackView.new;
        _feedBackView.hidden = YES;
        _feedBackView.clickedBlock = ^{
            @HDStrongify(self);
            if ([self.feedBackView.postSaleShowType isEqualToString:WMOrderFeedBackStepProgress]) {
                [HDMediator.sharedInstance navigaveToFeedBackHistoryController:@{@"orderNo": self.viewModel.orderNo}];
            } else {
                /// 30分钟内展示换货
                BOOL showChange = NSDate.date.timeIntervalSince1970 - self.viewModel.orderDetailRspModel.orderDetailForUser.finishTime.doubleValue / 1000.0 < 30 * 60;
                [HDMediator.sharedInstance navigaveToFeedBackViewController:@{
                    @"orderNo": self.viewModel.orderNo,
                    @"showChange": @(showChange),
                    @"hasPostSale": @(self.viewModel.orderDetailRspModel.orderDetailForUser.hasPostSale ||
                                      [self.viewModel.orderDetailRspModel.orderDetailForUser.postSaleShowType isEqualToString:WMOrderFeedBackStepResult])
                }];
            }
        };
    }
    return _feedBackView;
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = UIView.new;
        _shadowView.backgroundColor = HDAppTheme.WMColor.bgGray;
        _shadowView.alpha = 0;
    }
    return _shadowView;
}

- (SAOrderListDTO *)orderListDTO {
    if (!_orderListDTO) {
        _orderListDTO = SAOrderListDTO.new;
    }
    return _orderListDTO;
}

- (WMAnnotation *)receiverAnnotation {
    if (!_receiverAnnotation) {
        _receiverAnnotation = WMAnnotation.new;
        _receiverAnnotation.type = SAAnnotationTypeConsignee;
        _receiverAnnotation.logoImage = [UIImage imageNamed:@"yn_order_detail_map_user"];
    }
    return _receiverAnnotation;
}

- (WMAnnotation *)storeAnnotation {
    if (!_storeAnnotation) {
        _storeAnnotation = WMAnnotation.new;
        _storeAnnotation.type = SAAnnotationTypeMerchant;
    }
    return _storeAnnotation;
}

- (WMAnnotation *)riderAnnotation {
    if (!_riderAnnotation) {
        _riderAnnotation = WMAnnotation.new;
        _riderAnnotation.type = SAAnnotationTypeDeliveryMan;
        _riderAnnotation.logoImage = [UIImage imageNamed:@"yn_order_detail_rider"];
    }
    return _riderAnnotation;
}

- (WMOrderRefundDTO *)refundDTO {
    if (!_refundDTO) {
        _refundDTO = WMOrderRefundDTO.new;
    }
    return _refundDTO;
}

- (WMOrderNoticeView *)noticeView {
    if (!_noticeView) {
        _noticeView = WMOrderNoticeView.new;
        _noticeView.hidden = YES;
    }
    return _noticeView;
}

- (WMOrderDetailNaviBar *)naviBar {
    if (!_naviBar) {
        _naviBar = WMOrderDetailNaviBar.new;
        _naviBar.titleLB.text = WMLocalizedString(@"my_order", @"我的订单");
        @HDWeakify(self)[_naviBar.updateBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)
                //重置数据
                self.viewModel.hasGotInitializedData
                = NO;
            [self resetDetailView];
            [self.viewModel getNewData];
        }];
        [_naviBar.contactBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[self.statusView clickedPhoneBTNHandler];
        }];
    }
    return _naviBar;
}

- (UIView *)changeStatusView {
    if (!_changeStatusView) {
        _changeStatusView = UIView.new;
        _changeStatusView.alpha = 0;
        _changeStatusView.backgroundColor = HDAppTheme.WMColor.mainRed;
        _changeStatusView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            CAGradientLayer *gl = [CAGradientLayer layer];
            gl.frame = view.bounds;
            gl.startPoint = CGPointMake(0.54, 1);
            gl.endPoint = CGPointMake(0.54, 0);
            gl.colors = @[(__bridge id)[HDAppTheme.WMColor.mainRed colorWithAlphaComponent:0].CGColor, (__bridge id)HDAppTheme.WMColor.mainRed.CGColor];
            gl.locations = @[@(0), @(1.0f)];
            view.layer.mask = gl;
        };
    }
    return _changeStatusView;
}

- (YYLabel *)changStatusLB {
    if (!_changStatusLB) {
        _changStatusLB = YYLabel.new;
        _changStatusLB.alpha = 0;
        _changStatusLB.numberOfLines = 0;
        _changStatusLB.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(30);
        _changStatusLB.textColor = UIColor.whiteColor;
        _changStatusLB.font = [HDAppTheme.WMFont wm_boldForSize:20];
        UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedStatusTitleHandler)];
        [_changStatusLB addGestureRecognizer:ta];
    }
    return _changStatusLB;
}

- (SAInfoView *)changeAddressView {
    if (!_changeAddressView) {
        _changeAddressView = SAInfoView.new;
        _changeAddressView.hidden = NO;
        SAInfoViewModel *model = SAInfoViewModel.new;
        model.lineWidth = 0;
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(14), kRealWidth(12), kRealWidth(14), kRealWidth(12));
        model.rightButtonContentEdgeInsets = UIEdgeInsetsZero;
        model.enableTapRecognizer = true;
        model.keyImage = [UIImage imageNamed:@"yn_address_editing"];
        model.keyImagePosition = HDUIButtonImagePositionLeft;
        model.keyImageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kRealWidth(6));
        model.keyFont = [HDAppTheme.WMFont wm_ForSize:14 weight:UIFontWeightMedium];
        model.keyColor = HDAppTheme.WMColor.B3;
        model.backgroundColor = UIColor.whiteColor;
        model.cornerRadius = kRealWidth(8);
        model.rightButtonImage = [UIImage imageNamed:@"yn_submit_gengd"];
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [HDMediator.sharedInstance navigaveToModifyOrderAddressHistoryViewController:@{
                @"orderNo": self.viewModel.orderNo,
            }];
        };
        _changeAddressView.model = model;
        [_changeAddressView setNeedsUpdateContent];
    }
    return _changeAddressView;
}

- (WMOrderDetailTelegramView *)telegramView {
    if (!_telegramView) {
        _telegramView = WMOrderDetailTelegramView.new;
        _telegramView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(teleBindAction)];
        [_telegramView addGestureRecognizer:tap];
    }
    return _telegramView;
}
@end
