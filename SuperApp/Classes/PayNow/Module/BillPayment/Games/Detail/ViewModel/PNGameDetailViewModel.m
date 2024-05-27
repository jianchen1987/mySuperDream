//
//  PNGameDetailViewModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/12/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGameDetailViewModel.h"
#import "HDAppTheme+PayNow.h"
#import "PNGameDetailDTO.h"
#import "PNGameSubmitOderRequestModel.h"
#import "PNTransferFormConfig.h"
#import "SAInfoViewModel.h"
#import "SAOrderDTO.h"
#import "VipayUser.h"


@interface PNGameDetailViewModel ()
///
@property (strong, nonatomic) PNGameDetailDTO *detailDTO;
///< 订单
@property (nonatomic, strong) SAOrderDTO *orderDTO;
///
@property (strong, nonatomic) PNGameDetailRspModel *rspModel;
/// 产品信息
@property (strong, nonatomic) HDTableViewSectionModel *infoSectionModel;
/// 游戏账号
@property (strong, nonatomic) HDTableViewSectionModel *accoutSectionModel;
/// 金额选项
@property (strong, nonatomic) HDTableViewSectionModel *cardsSectionModel;
/// 账单
@property (strong, nonatomic) HDTableViewSectionModel *billSectionModel;
/// 选中的模型
@property (strong, nonatomic) PNGameItemModel *selectedItem;
/// 用户账户信息模型
@property (strong, nonatomic) TNGameBalanceAccountModel *accountModel;
/// 营销费用
@property (strong, nonatomic) PNGameFeeModel *feeModel;
/// 提交订单模型
@property (strong, nonatomic) PNGameSubmitOderRequestModel *submitModel;
///游戏id输入
@property (strong, nonatomic) PNTransferFormConfig *userIdConfig;
///游戏zone输入
@property (strong, nonatomic) PNTransferFormConfig *zoneIdConfig;
@end


@implementation PNGameDetailViewModel
- (void)getNewData {
    [self.view showloading];
    @HDWeakify(self);
    [self.detailDTO queryGameItemDetailWithCategoryId:self.categoryId success:^(PNGameDetailRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.rspModel = rspModel;

        [self processData];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}
///处理数据
- (void)processData {
    [self.dataArr removeAllObjects];
    //产品图片信息
    self.infoSectionModel.list = @[self.rspModel.category];
    [self.dataArr addObject:self.infoSectionModel];

    if (!HDIsArrayEmpty(self.rspModel.item)) {
        // game游戏
        PNGameItemModel *itemModel = self.rspModel.item.firstObject;
        itemModel.isSelected = YES; //第一个默认选中
        self.selectedItem = itemModel;
        [self checkBtnEnable];
        if (itemModel.isPinless) {
            NSMutableArray *temp = [NSMutableArray array];
            PNTransferFormConfig *config = [[PNTransferFormConfig alloc] init];
            config.keyText = PNLocalizedString(@"pn_user_id", @"游戏ID");
            config.valuePlaceHold = PNLocalizedString(@"pn_input_user_id", @"请输入游戏ID");
            config.editType = PNSTransferFormValueEditTypeEnter;
            config.useWOWNOWKeyboard = YES;
            config.valueText = self.submitModel.userId;
            config.wownowKeyBoardType = HDKeyBoardTypeNumberPadCanSwitchToLetter;
            config.lineHeight = 0;
            @HDWeakify(self);
            config.valueChangedCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
                @HDStrongify(self);
                self.submitModel.userId = targetConfig.valueText;
                [self checkBtnEnable];
            };
            config.textFiledShouldEndEditCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
                @HDStrongify(self);
                if (!self.zoneIdConfig.isEditing && HDIsStringNotEmpty(self.submitModel.userId) && HDIsStringNotEmpty(self.submitModel.zoneId)) {
                    [self queryUserGameAccountData];
                }
            };
            [temp addObject:config];
            self.userIdConfig = config;

            config = [[PNTransferFormConfig alloc] init];
            config.keyText = PNLocalizedString(@"pn_zone_id", @"游戏区域");
            config.valuePlaceHold = PNLocalizedString(@"pn_input_zone_id", @"请输入游戏区域");
            config.editType = PNSTransferFormValueEditTypeEnter;
            config.valueText = self.submitModel.zoneId;
            config.useWOWNOWKeyboard = YES;
            config.lineHeight = 0;
            config.wownowKeyBoardType = HDKeyBoardTypeNumberPadCanSwitchToLetter;
            config.valueChangedCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
                @HDStrongify(self);
                self.submitModel.zoneId = targetConfig.valueText;
                [self checkBtnEnable];
            };
            config.textFiledShouldEndEditCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
                @HDStrongify(self);
                if (!self.userIdConfig.isEditing && HDIsStringNotEmpty(self.submitModel.userId) && HDIsStringNotEmpty(self.submitModel.zoneId)) {
                    [self queryUserGameAccountData];
                }
            };
            [temp addObject:config];
            self.zoneIdConfig = config;
            self.accoutSectionModel.list = temp;
            [self.dataArr addObject:self.accoutSectionModel];
        }
        //卡片区域
        self.cardsSectionModel.list = @[self.rspModel];
        [self.dataArr addObject:self.cardsSectionModel];

        //账单区域

        [self.dataArr addObject:self.billSectionModel];
    }
    //请求账户数据
    [self queryUserGameAccountData];
    //先展示
    [self processBillSectionData];
    self.refreshFlag = !self.refreshFlag;
}
//处理选中的bill数据
- (void)processBillSectionData {
    //设置code
    self.submitModel.billerCode = self.selectedItem.code;
    self.submitModel.billGroup = self.selectedItem.group;

    NSMutableArray *temp = [NSMutableArray array];
    if (self.selectedItem.isPinless && HDIsStringNotEmpty(self.submitModel.userId) && HDIsStringNotEmpty(self.submitModel.zoneId) && !HDIsObjectNil(self.accountModel)
        && HDIsStringNotEmpty(self.accountModel.customer.name)) {
        SAInfoViewModel *infoModel = [self getDefalutInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"pn_customer_name", @"客户名称");
        infoModel.valueText = self.accountModel.customer.name;
        [temp addObject:infoModel];
    }

    //金额
    SAInfoViewModel *infoModel = [self getDefalutInfoViewModel];
    infoModel.keyText = PNLocalizedString(@"bill_amount", @"Bill amount");
    infoModel.valueText = self.selectedItem.amount.thousandSeparatorAmount;
    [temp addObject:infoModel];

    // fee
    if (!HDIsObjectNil(self.feeModel.fee)) {
        infoModel = [self getDefalutInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"Service_Charge", @"手续费");
        infoModel.valueText = self.feeModel.fee.thousandSeparatorAmount;
        [temp addObject:infoModel];
    }

    // Promotion
    if (!HDIsObjectNil(self.feeModel.promotion)) {
        infoModel = [self getDefalutInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"promotion", @"营销优惠");
        infoModel.valueText = self.feeModel.promotion.thousandSeparatorAmount;
        [temp addObject:infoModel];
    }
    if (!HDIsObjectNil(self.submitModel.billAmount)) {
        // Total
        infoModel = [self getDefalutInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"total_amount", @"Total");
        infoModel.valueText = self.submitModel.billAmount.thousandSeparatorAmount;
        [temp addObject:infoModel];
    }

    // account
    infoModel = [self getDefalutInfoViewModel];
    infoModel.keyText = PNLocalizedString(@"pn_payer_account", @"Payer Account");
    infoModel.valueText = [VipayUser shareInstance].loginName;
    [temp addObject:infoModel];
    self.billSectionModel.list = temp;
}
#pragma mark -拉取账户信息数据
- (void)queryUserGameAccountData {
    //设置code
    self.submitModel.billerCode = self.selectedItem.code;
    [self.view showloading];
    @HDWeakify(self);
    [self.detailDTO queryGameBalanceInquiryWithBillCode:self.submitModel.billCode currency:self.selectedItem.currency success:^(TNGameBalanceAccountModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.accountModel = rspModel;
        [self queryFeeAndPromotionData];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}
#pragma mark -拉取手续费和营销优惠
- (void)queryFeeAndPromotionData {
    [self.view showloading];
    if (!HDIsObjectNil(self.accountModel) && !HDIsArrayEmpty(self.accountModel.balances)) {
        TNGameBalancesModel *balanceModel = self.accountModel.balances.firstObject;
        self.submitModel.customerPhone = balanceModel.customerPhone;
        @HDWeakify(self);
        [self.detailDTO queryGameFeeAndPromotionWithAmt:self.selectedItem.amount.amount currency:self.selectedItem.currency chargeType:balanceModel.chargeType
            supplierCode:self.accountModel.supplier.code
            billCode:self.submitModel.billCode success:^(PNGameFeeModel *_Nonnull feeModel) {
                @HDStrongify(self);
                [self.view dismissLoading];
                self.feeModel = feeModel;
                //总计金额
                self.submitModel.billAmount = feeModel.totalAmount;
                [self processBillSectionData];
                self.refreshFlag = !self.refreshFlag;
            } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
                @HDStrongify(self);
                [self.view dismissLoading];
            }];
    } else {
        [self.view dismissLoading];
        [self processBillSectionData];
        self.refreshFlag = !self.refreshFlag;
    }
}
- (void)queryBalanceAndExchangeCompletion:(void (^)(PNBalanceAndExchangeModel *_Nullable))completion {
    @HDWeakify(self);
    [self.detailDTO queryUserBalanceAndExchangeWithTotalAmount:self.submitModel.billAmount.amount success:^(PNBalanceAndExchangeModel *_Nonnull model) {
        @HDStrongify(self);
        self.balanceModel = model;
        !completion ?: completion(model);
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        !completion ?: completion(nil);
    }];
}
- (void)createGameOrderByType:(BOOL)isWalletType completion:(void (^)(PNGameSubmitOrderResponseModel *_Nullable))completion {
    if (isWalletType) {
        [self.detailDTO createGameWalletOrderWithSubmitModel:self.submitModel success:^(PNGameSubmitOrderResponseModel *_Nonnull responseModel) {
            !completion ?: completion(responseModel);
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            !completion ?: completion(nil);
        }];
    } else {
        [self.detailDTO createGameAggregateOrderWithSubmitModel:self.submitModel success:^(PNGameSubmitOrderResponseModel *_Nonnull responseModel) {
            !completion ?: completion(responseModel);
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            !completion ?: completion(nil);
        }];
    }
}
- (void)queryOrderInfoWithAggregationOrderNo:(NSString *_Nonnull)aggregationOrderNo completion:(void (^)(SAQueryOrderInfoRspModel *_Nullable rspModel))completion {
    [self.orderDTO queryOrderInfoWithOrderNo:aggregationOrderNo outPayOrderNo:nil success:^(SAQueryOrderInfoRspModel *_Nonnull rspModel) {
        !completion ?: completion(rspModel);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion(nil);
    }];
}

//严重按钮是否可以点击
- (void)checkBtnEnable {
    if (!HDIsObjectNil(self.selectedItem)) {
        if (self.selectedItem.isPinless) {
            if (HDIsStringNotEmpty(self.submitModel.userId) && HDIsStringNotEmpty(self.submitModel.zoneId)) {
                self.btnEnable = YES;
            } else {
                self.btnEnable = NO;
            }
        } else {
            self.btnEnable = YES;
        }
    } else {
        self.btnEnable = NO;
    }
}
#pragma mark -更新选中的数据
- (void)updateSelectedItem:(PNGameItemModel *)item {
    self.selectedItem = item;
    [self processBillSectionData];
    [self queryFeeAndPromotionData];
    self.refreshFlag = !self.refreshFlag;
}
- (SAInfoViewModel *)getDefalutInfoViewModel {
    SAInfoViewModel *infoModel = [[SAInfoViewModel alloc] init];
    infoModel.keyFont = [HDAppTheme.PayNowFont fontBold:14];
    infoModel.keyColor = HDAppTheme.PayNowColor.c333333;
    infoModel.valueFont = [HDAppTheme.PayNowFont fontRegular:14];
    infoModel.valueColor = HDAppTheme.PayNowColor.c333333;
    return infoModel;
}
/** @lazy detailDTO */
- (PNGameDetailDTO *)detailDTO {
    if (!_detailDTO) {
        _detailDTO = [[PNGameDetailDTO alloc] init];
    }
    return _detailDTO;
}
/** @lazy infoSectionModel */
- (HDTableViewSectionModel *)infoSectionModel {
    if (!_infoSectionModel) {
        _infoSectionModel = [[HDTableViewSectionModel alloc] init];
    }
    return _infoSectionModel;
}
/** @lazy accoutSectionModel */
- (HDTableViewSectionModel *)accoutSectionModel {
    if (!_accoutSectionModel) {
        _accoutSectionModel = [[HDTableViewSectionModel alloc] init];
    }
    return _accoutSectionModel;
}
/** @lazy cardsSectionModel */
- (HDTableViewSectionModel *)cardsSectionModel {
    if (!_cardsSectionModel) {
        _cardsSectionModel = [[HDTableViewSectionModel alloc] init];
    }
    return _cardsSectionModel;
}
/** @lazy billSectionModel */
- (HDTableViewSectionModel *)billSectionModel {
    if (!_billSectionModel) {
        _billSectionModel = [[HDTableViewSectionModel alloc] init];
    }
    return _billSectionModel;
}
/** @lazy dataArr */
- (NSMutableArray<HDTableViewSectionModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
/** @lazy gameInfoModel */
//- (PNGameCategoryModel *)gameInfoModel {
//    if (!_gameInfoModel) {
//        _gameInfoModel = [[PNGameCategoryModel alloc] init];
//    }
//    return _gameInfoModel;
//}
/** @lazy submitModel */
- (PNGameSubmitOderRequestModel *)submitModel {
    if (!_submitModel) {
        _submitModel = [[PNGameSubmitOderRequestModel alloc] init];
        _submitModel.categoryId = self.categoryId;
    }
    return _submitModel;
}
- (SAOrderDTO *)orderDTO {
    return _orderDTO ?: ({ _orderDTO = [[SAOrderDTO alloc] init]; });
}

@end
