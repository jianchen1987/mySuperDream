//
//  WMOrderModifyAddressViewController.m
//  SuperApp
//
//  Created by wmz on 2022/10/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMOrderModifyAddressViewController.h"
#import "SAShoppingAddressDTO.h"
#import "WMCustomViewActionView.h"
#import "WMModifyAddressDTO.h"
#import "WMModifyAddressPopView.h"
#import "WMOrderDetailDTO.h"
#import "WMOrderDetailRspModel.h"
#import "WMTableView.h"


@interface WMOrderModifyAddressViewController () <GNTableViewProtocol>
/// tableView
@property (nonatomic, strong) WMTableView *tableView;
///数据源
@property (nonatomic, strong) NSMutableArray<GNSectionModel *> *dataSource;
/// DTO
@property (nonatomic, strong) SAShoppingAddressDTO *addressDTO;
/// modifyDTO
@property (nonatomic, strong) WMModifyAddressDTO *modifyDTO;
/// orderDetailDTO
@property (nonatomic, strong) WMOrderDetailDTO *orderDetailDTO;
/// 提交按钮
@property (nonatomic, strong) SAOperationButton *submitBTN;
/// bottomView
@property (nonatomic, strong) UIView *bottomView;
/// 已选地址编号
@property (nonatomic, copy) NSString *chooseAddressNo;
/// 选中的要改变的地址
@property (nonatomic, strong, nullable) GNCellModel *selectChangeAddressModel;
/// 当前地址
@property (nonatomic, strong) GNSectionModel *currentAddressListSectionModel;
/// 公告
@property (nonatomic, strong) HDAnnouncementView *announcementView;
/// 进入页面时候的订单model
@property (nonatomic, strong) WMOrderDetailRspModel *orderDetailRspModel;
/// 新增地址
@property (nonatomic, strong) HDUIButton *addBTN;

@end


@implementation WMOrderModifyAddressViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    self.orderDetailRspModel = parameters[@"orderDetailRspModel"];
    self.parentOrderNo = parameters[@"orderNo"];
    self.chooseAddressNo = self.orderDetailRspModel.orderDetailForUser.receiver.addressNo;
    return self;
}

- (void)hd_setupViews {
    self.boldTitle = WMLocalizedString(@"wm_modify_address_name", @"Modify shipping address");
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.submitBTN];
    [self.view addSubview:self.announcementView];
    NSString *key = [NSString stringWithFormat:@"yumnow_modify_address_tip_%@", SAUser.shared.operatorNo];
    if (![NSUserDefaults.standardUserDefaults objectForKey:key]) {
        [self showTipAlert:self.announcementView.config.text handler:nil];
    }
    self.hd_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addBTN];
}

- (void)hd_getNewData {
    if (!self.tableView.hd_hasData) {
        self.tableView.delegate = self.tableView.provider;
        self.tableView.dataSource = self.tableView.provider;
        self.bottomView.hidden = self.submitBTN.hidden = YES;
        [self.view setNeedsUpdateConstraints];
    }
    @HDWeakify(self)[self.addressDTO getUserAccessableShoppingAddressWithStoreNo:self.parameters[@"storeNo"] success:^(NSArray<SAShoppingAddressModel *> *_Nonnull list) {
        @HDStrongify(self);
        if (!HDIsArrayEmpty(list)) {
            self.announcementView.hidden = self.bottomView.hidden = self.submitBTN.hidden = NO;
            self.view.backgroundColor = HDAppTheme.WMColor.bgGray;
            [self.view setNeedsUpdateConstraints];
        }
        self.tableView.GNdelegate = self;
        self.dataSource = NSMutableArray.new;
        NSMutableArray<GNCellModel *> *availableAddressList = NSMutableArray.new;
        NSMutableArray<GNCellModel *> *unAvailableAddressList = NSMutableArray.new;
        NSMutableArray<GNCellModel *> *currentAddressList = NSMutableArray.new;
        [list enumerateObjectsUsingBlock:^(SAShoppingAddressModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            GNCellModel *cellModel = [GNCellModel createClass:@"WMOrderModifyAddressTableViewCell"];
            cellModel.businessData = obj;
            cellModel.notCacheHeight = YES;
            if ([obj.inRange isEqualToString:SABoolValueTrue]) {
                if (![obj.addressNo isEqualToString:self.chooseAddressNo]) {
                    [availableAddressList addObject:cellModel];
                }
            } else {
                [unAvailableAddressList addObject:cellModel];
            }
            if ([obj.addressNo isEqualToString:self.chooseAddressNo] && HDIsArrayEmpty(currentAddressList)) {
                ///重新创建一份
                cellModel = [GNCellModel createClass:@"WMOrderModifyAddressTableViewCell"];
                cellModel.businessData = obj;
                cellModel.notCacheHeight = YES;
                cellModel.tag = @"current";
                cellModel.last = YES;
                [currentAddressList addObject:cellModel];
            }
        }];

        if (!HDIsArrayEmpty(currentAddressList)) {
            [self.dataSource addObject:[self sectionHeadWithTitle:WMLocalizedString(@"wm_modify_address_order_current", @"Current order addres")]];
            [self.dataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                                 sectionModel.cornerRadios = kRealWidth(8);
                                 [sectionModel.rows addObjectsFromArray:currentAddressList];
                                 self.currentAddressListSectionModel = sectionModel;
                             })];
        }

        if (!HDIsArrayEmpty(availableAddressList)) {
            [availableAddressList enumerateObjectsUsingBlock:^(GNCellModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                obj.last = (idx == availableAddressList.count - 1);
            }];
            [self.dataSource addObject:[self sectionHeadWithTitle:WMLocalizedString(@"wm_modify_address_order_changed", @"Can change address")]];
            [self.dataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                                 sectionModel.cornerRadios = kRealWidth(8);
                                 [sectionModel.rows addObjectsFromArray:availableAddressList];
                             })];
            ///改了地址重新算配送费和时长
            if (self.selectChangeAddressModel) {
                SAShoppingAddressModel *addressModel = self.selectChangeAddressModel.businessData;
                [availableAddressList enumerateObjectsUsingBlock:^(GNCellModel *obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    SAShoppingAddressModel *tmpModel = obj.businessData;
                    if ([addressModel.addressNo isEqualToString:tmpModel.addressNo]) {
                        self.selectChangeAddressModel = nil;
                        [self respondEvent:[GNEvent eventKey:@"selectAction" info:@{@"model": obj}]];
                        *stop = YES;
                        return;
                    }
                }];
            }
        }
        if (!HDIsArrayEmpty(unAvailableAddressList)) {
            [unAvailableAddressList enumerateObjectsUsingBlock:^(GNCellModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                obj.last = (idx == unAvailableAddressList.count - 1);
            }];
            [self.dataSource addObject:[self sectionHeadWithTitle:WMLocalizedString(@"wm_modify_address_order_cannot_changed", @"Exceeds the addressable range")]];
            [self.dataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                                 sectionModel.cornerRadios = kRealWidth(8);
                                 [sectionModel.rows addObjectsFromArray:unAvailableAddressList];
                             })];
        }

        [self.tableView reloadData:YES];
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        @HDStrongify(self);
        self.tableView.GNdelegate = self;
        [self.tableView reloadFail];
    }];
}

- (GNSectionModel *)sectionHeadWithTitle:(NSString *)title {
    return addSection(^(GNSectionModel *_Nonnull sectionModel) {
        GNCellModel *cellModel = [GNCellModel createClass:@"GNOrderTitleSectionTitleCell"];
        cellModel.title = title;
        cellModel.outInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(4), kRealWidth(8), kRealWidth(12));
        cellModel.backgroundColor = HDAppTheme.WMColor.bgGray;
        [sectionModel.rows addObject:cellModel];
    });
}

- (void)updateViewConstraints {
    [self.announcementView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.announcementView.isHidden) {
            make.top.mas_equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(12));
            make.left.mas_equalTo(kRealWidth(8));
            make.right.mas_equalTo(-kRealWidth(8));
            make.height.mas_equalTo(kRealWidth(42));
        }
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.announcementView.mas_bottom);
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        if (self.submitBTN.isHidden) {
            make.bottom.mas_equalTo(0);
        } else {
            make.bottom.equalTo(self.submitBTN.mas_top).offset(-kRealWidth(12));
        }
    }];

    [self.submitBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.submitBTN.isHidden) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-kRealWidth(8));
            make.left.mas_equalTo(kRealWidth(12));
            make.right.mas_equalTo(-kRealWidth(12));
            make.height.mas_offset(kRealWidth(44));
        }
    }];

    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.bottomView.isHidden) {
            make.top.equalTo(self.tableView.mas_bottom);
            make.bottom.left.right.mas_equalTo(0);
        }
    }];
    [super updateViewConstraints];
}

- (void)respondEvent:(NSObject<GNEvent> *)event {
    ///选中
    if ([event.key isEqualToString:@"selectAction"] && [event.info[@"model"] isKindOfClass:GNCellModel.class]) {
        GNCellModel *model = event.info[@"model"];
        if (model == self.selectChangeAddressModel)
            return;
        if (self.selectChangeAddressModel) {
            self.selectChangeAddressModel.select = NO;
            self.selectChangeAddressModel.object = nil;
        }
        self.submitBTN.enabled = YES;
        model.select = YES;
        self.selectChangeAddressModel = model;
        [self requestFee];
        [self.tableView reloadData];
    }
}

///计算额外费用
- (void)requestFee {
    if (!self.selectChangeAddressModel)
        return;
    @HDWeakify(self) SAShoppingAddressModel *addressModel = self.selectChangeAddressModel.businessData;
    if ([addressModel isKindOfClass:SAShoppingAddressModel.class]) {
        [self.view showloading];
        [self.modifyDTO getOrderUpdateAddressWithAddressNo:addressModel.addressNo orderNo:self.parentOrderNo success:^(WMModifyFeeModel *_Nonnull rspModel) {
            @HDStrongify(self)[self.view dismissLoading];
            self.selectChangeAddressModel.object = rspModel;
            [self.tableView reloadData];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self) self.selectChangeAddressModel.select = NO;
            self.selectChangeAddressModel.object = nil;
            self.submitBTN.enabled = NO;
            [self.tableView reloadData];
            [self.view dismissLoading];
        }];
    }
}

- (NSArray<GNSectionModel *> *)numberOfSectionsInGNTableView:(GNTableView *)tableView {
    return self.dataSource;
}

///选中确认
- (void)clickedSubmitButtonHandler {
    if (!self.selectChangeAddressModel)
        return;
    [self.view showloading];
    @HDWeakify(self)[self getOrderDetailSuccess:^(WMOrderDetailRspModel *rspModel) {
        @HDStrongify(self)[self.view dismissLoading];
        ///骑手未取餐变成已取餐
        if (self.orderDetailRspModel.orderDetailForUser.deliveryInfo.deliveryStatus == WMDeliveryStatusAccepted
            && rspModel.orderDetailForUser.deliveryInfo.deliveryStatus != WMDeliveryStatusAccepted) {
            @HDWeakify(self) self.orderDetailRspModel = rspModel;
            [self showTipAlert:WMLocalizedString(@"wm_modify_address_modify_status_change", @"订单状态发生变更，请重新选择")
                       handler:^(WMNormalAlertView *_Nonnull alertView, HDUIButton *_Nonnull button) {
                           @HDStrongify(self)[alertView dismiss];
                           [self hd_getNewData];
                       }];
            return;
        }
        ///骑手配送中，点击确认状态已送达
        if (rspModel.orderDetailForUser.bizState == WMBusinessStatusDeliveryArrived) {
            [self showTipAlert:WMLocalizedString(@"wm_modify_address_cannot_change_address", @"该订单已送达不可更改地址，如需处理请联系客服") handler:nil];
            [self hd_getNewData];
            return;
        }
        [self confirmAlert];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self)[self.view dismissLoading];
        [self hd_getNewData];
    }];
}

///确认订单弹窗
- (void)confirmAlert {
    SAShoppingAddressModel *addressModel = self.selectChangeAddressModel.businessData;
    WMModifyFeeModel *feeModel = self.selectChangeAddressModel.object;
    if (![addressModel isKindOfClass:SAShoppingAddressModel.class] || ![feeModel isKindOfClass:WMModifyFeeModel.class])
        return;
    ///当前地址
    GNCellModel *currentAddressModel = self.currentAddressListSectionModel.rows.firstObject;
    SAShoppingAddressModel *currentModel = currentAddressModel.businessData;
    @HDWeakify(self) WMModifyAddressPopModel *popModel = WMModifyAddressPopModel.new;
    popModel.feeModel = feeModel;
    popModel.neAddress = addressModel;
    popModel.oldAddress = currentModel;
    popModel.oldDeliveryFee = self.parameters[@"fee"];
    popModel.actualAmount = self.orderDetailRspModel.orderDetailForUser.actualAmount;
    popModel.paymentMethod = self.orderDetailRspModel.orderDetailForUser.paymentMethod;
    WMModifyAddressPopView *popView = [[WMModifyAddressPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    popView.model = popModel;
    [popView layoutyImmediately];
    WMCustomViewActionView *action = [WMCustomViewActionView actionViewWithContentView:popView block:^(HDCustomViewActionViewConfig *_Nullable config) {
        config.title = WMLocalizedString(@"wm_modify_address_information", @"Edit address information");
        config.shouldAddScrollViewContainer = YES;
    }];
    @HDWeakify(action) popView.clickedConfirmBlock = ^{
        @HDStrongify(action) @HDStrongify(self)[self submitOrder:popModel popView:action];
    };
    [action show];
}

///提交订单
- (void)submitOrder:(WMModifyAddressPopModel *)model popView:(nullable WMCustomViewActionView *)popView {
    @HDWeakify(self) @HDWeakify(popView)[self showloading];
    [self.modifyDTO createOrderUpdateAddressWithAddressNo:model.neAddress.addressNo orderNo:self.parentOrderNo distance:model.feeModel.distance time:model.feeModel.inTime
        fee:model.feeModel.deliveryFee success:^(WMModifyAddressSubmitOrderModel *_Nonnull rspModel) {
            @HDStrongify(self) @HDStrongify(popView)[self dismissLoading];
            if (popView)
                [popView dismiss];
            if (model.paymentMethod == SAOrderPaymentTypeOnline && rspModel.payOrderResp.actualPayAmount.cent.integerValue) {
                [self payActionWithOrderNo:rspModel.payOrderResp.orderNo merchantNo:rspModel.payOrderResp.merchantNo storeNo:self.parameters[@"storeNo"]
                             payableAmount:rspModel.payOrderResp.actualPayAmount];
            } else {
                [self dismissAnimated:YES completion:^{
                    [HDTips showSuccess:WMLocalizedString(@"wm_modify_address_successfully", @"成功修改地址") hideAfterDelay:1];
                }];
            }
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self)[self dismissLoading];
            if (popView)
                [popView dismiss];
            [self hd_getNewData];
        }];
}

///获取订单详情
- (void)getOrderDetailSuccess:(void (^)(WMOrderDetailRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    [self.orderDetailDTO getOrderDetailWithOrderNo:self.parentOrderNo success:^(WMOrderDetailRspModel *_Nonnull rspModel) {
        !successBlock ?: successBlock(rspModel);
    } failure:failureBlock];
}

- (void)showTipAlert:(NSString *)text handler:(WMAlertViewButtonHandler)handler {
    [WMCustomViewActionView WMAlertWithContent:text handle:handler];
    NSString *key = [NSString stringWithFormat:@"yumnow_modify_address_tip_%@", SAUser.shared.operatorNo];
    [NSUserDefaults.standardUserDefaults setObject:@"true" forKey:key];
}

- (WMTableView *)tableView {
    if (!_tableView) {
        _tableView = [[WMTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.needShowErrorView = YES;
        _tableView.needShowNoDataView = YES;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, kRealWidth(12), 0);
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (SAShoppingAddressDTO *)addressDTO {
    if (!_addressDTO) {
        _addressDTO = SAShoppingAddressDTO.new;
    }
    return _addressDTO;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = UIView.new;
        _bottomView.hidden = YES;
        _bottomView.backgroundColor = UIColor.whiteColor;
    }
    return _bottomView;
}

- (SAOperationButton *)submitBTN {
    if (!_submitBTN) {
        _submitBTN = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        _submitBTN.layer.cornerRadius = kRealWidth(22);
        _submitBTN.layer.masksToBounds = YES;
        _submitBTN.enabled = NO;
        _submitBTN.hidden = YES;
        [_submitBTN applyPropertiesWithBackgroundColor:HDAppTheme.color.mainColor];
        [_submitBTN addTarget:self action:@selector(clickedSubmitButtonHandler) forControlEvents:UIControlEventTouchUpInside];
        [_submitBTN setTitle:WMLocalizedString(@"wm_button_confirm", @"确认") forState:UIControlStateNormal];
    }
    return _submitBTN;
}

- (WMModifyAddressDTO *)modifyDTO {
    if (!_modifyDTO) {
        _modifyDTO = WMModifyAddressDTO.new;
    }
    return _modifyDTO;
}

- (WMOrderDetailDTO *)orderDetailDTO {
    if (!_orderDetailDTO) {
        _orderDetailDTO = WMOrderDetailDTO.new;
    }
    return _orderDetailDTO;
}

- (HDAnnouncementView *)announcementView {
    if (!_announcementView) {
        NSString *text = WMLocalizedString(@"wm_modify_address_tip", @"一个订单只能修改1次收货地址；只能修改商家配送范围内的地址；修改后配送费和配送金额会重新计算");
        _announcementView = HDAnnouncementView.new;
        _announcementView.layer.cornerRadius = kRealWidth(8);
        @HDWeakify(self);
        _announcementView.tappedHandler = ^{
            @HDStrongify(self);
            [self showTipAlert:text handler:nil];
        };
        HDAnnouncementViewConfig *config = HDAnnouncementViewConfig.new;
        config.trumpetImage = [UIImage imageNamed:@"yn_store_no"];
        config.text = text;
        config.backgroundColor = [[HDAppTheme.color gn_ColorGradientChangeWithSize:CGSizeMake(kScreenWidth - kRealWidth(16), kRealWidth(42)) direction:GNGradientChangeDirectionLevel
                                                                            colors:@[HDAppTheme.WMColor.mainRed, [HexColor(0xFF5129) colorWithAlphaComponent:0.71]]] colorWithAlphaComponent:0.1];
        config.textColor = HDAppTheme.WMColor.mainRed;
        config.textFont = [HDAppTheme.WMFont wm_ForSize:12];
        config.trumpetToTextMargin = kRealWidth(4);
        config.contentInsets = UIEdgeInsetsMake(kRealWidth(8), kRealWidth(12), kRealWidth(8), kRealWidth(32));
        _announcementView.config = config;
        UIImageView *rightIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yn_icon_enter_red"]];
        [_announcementView addSubview:rightIV];
        [rightIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-kRealWidth(8));
        }];
    }
    return _announcementView;
}

- (HDUIButton *)addBTN {
    if (!_addBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:12];
        [button setTitle:WMLocalizedString(@"add_new_address", @"添加地址") forState:UIControlStateNormal];
        [button sizeToFit];
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToAddOrModifyAddressViewController:@{}];
        }];
        _addBTN = button;
    }
    return _addBTN;
}

@end
