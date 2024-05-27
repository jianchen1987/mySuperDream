//
//  TNNewIncomeDetailViewModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/9/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNNewIncomeDetailViewModel.h"
#import "HDAppTheme+TinhNow.h"
#import "SAInfoView.h"
#import "SAInfoViewModel.h"
#import "TNNewIncomeDTO.h"


@interface TNNewIncomeDetailViewModel ()
///
@property (strong, nonatomic) TNNewIncomeDTO *incomeDTO;
@end


@implementation TNNewIncomeDetailViewModel
- (void)getDatailData {
    [self.view showloading];
    @HDWeakify(self);
    [self.incomeDTO queryIncomeDeTailWithObjId:self.objId success:^(TNNewIncomeDetailModel *model) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.detailModel = model;
        [self configInfoViewModels:model];
        self.refreshFlag = !self.refreshFlag;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        !self.incomeDetailGetDataFaild ?: self.incomeDetailGetDataFaild();
    }];
}

- (void)configInfoViewModels:(TNNewIncomeDetailModel *)model {
    SAInfoViewModel *infoModel = [self getonfigInfoViewModel];
    infoModel.keyText = TNLocalizedString(@"5ai7F6X6", @"订单状态");
    infoModel.valueText = model.orderStatusStr;
    [self.dataArr addObject:infoModel];

    if (HDIsStringNotEmpty(model.completeTime)) {
        infoModel = [self getonfigInfoViewModel];
        infoModel.keyText = TNLocalizedString(@"tn_order_done_time", @"订单完成时间");
        infoModel.valueText = model.completeTime;
        [self.dataArr addObject:infoModel];
    }
    if (HDIsStringNotEmpty(model.cashInTime)) {
        infoModel = [self getonfigInfoViewModel];
        infoModel.keyText = TNLocalizedString(@"8pF4Tooc", @"到账时间");
        infoModel.valueText = model.cashInTime;
        [self.dataArr addObject:infoModel];
    }
    //预估收益有个下单时间
    if (model.settleStatus != TNIncomeSettleStatusSettled && HDIsStringNotEmpty(model.orderCreateTime)) {
        infoModel = [self getonfigInfoViewModel];
        infoModel.keyText = TNLocalizedString(@"AegA4yhW", @"下单时间");
        infoModel.valueText = model.orderCreateTime;
        [self.dataArr addObject:infoModel];
    }

    infoModel = [self getonfigInfoViewModel];
    infoModel.keyText = TNLocalizedString(@"hP8hNm9Z", @"下单用户昵称");
    infoModel.valueText = model.nickname;
    [self.dataArr addObject:infoModel];

    infoModel = [self getonfigInfoViewModel];
    infoModel.keyText = TNLocalizedString(@"Bm4PvkQ6", @"店铺名称");
    infoModel.valueText = model.shopName;
    infoModel.lineWidth = 0.5;
    [self.dataArr addObject:infoModel];

    if (!HDIsArrayEmpty(model.orderShops)) {
        for (TNIncomeOrderShopsModel *shopModel in model.orderShops) {
            infoModel = [self getonfigInfoViewModel];
            infoModel.keyText = TNLocalizedString(@"tn_productDetail_item", @"商品");
            if (!HDIsArrayEmpty(shopModel.shopSpecs)) {
                infoModel.valueText = [NSString stringWithFormat:@"%@【%@】", shopModel.shopName, [shopModel.shopSpecs componentsJoinedByString:@","]];
            } else {
                infoModel.valueText = shopModel.shopName;
            }

            [self.dataArr addObject:infoModel];

            infoModel = [self getonfigInfoViewModel];
            infoModel.keyText = TNLocalizedString(@"tn_product_quantity", @"数量");
            infoModel.valueText = shopModel.shopQuantity;
            infoModel.lineWidth = 0.5;
            [self.dataArr addObject:infoModel];
        }
    }

    infoModel = [self getonfigInfoViewModel];
    infoModel.keyText = TNLocalizedString(@"2XDF1h9C", @"商品金额合计($)");
    infoModel.valueText = model.totalAmount.thousandSeparatorAmountNoCurrencySymbol;
    [self.dataArr addObject:infoModel];

    infoModel = [self getonfigInfoViewModel];
    infoModel.keyText = TNLocalizedString(@"LA2A7zZs", @"收益类型");
    if (model.type == TNSellerIdentityTypePartTime) {
        infoModel.valueText = TNLocalizedString(@"UYkt3Raq", @"兼职收益");
    } else {
        infoModel.valueText = TNLocalizedString(@"3Rg5syJS", @"普通收益");
    }

    [self.dataArr addObject:infoModel];

    infoModel = [self getonfigInfoViewModel];
    infoModel.keyText = TNLocalizedString(@"B1a17lZE", @"卖家收益($)");
    infoModel.valueText = model.commissionAmount.thousandSeparatorAmountNoCurrencySymbol;
    [self.dataArr addObject:infoModel];

    infoModel = [self getonfigInfoViewModel];
    infoModel.keyText = TNLocalizedString(@"nL435bnw", @"平台服务费($)");
    infoModel.valueText = model.platformServiceFee.thousandSeparatorAmountNoCurrencySymbol;
    [self.dataArr addObject:infoModel];

    infoModel = [self getonfigInfoViewModel];
    infoModel.keyText = TNLocalizedString(@"OIV4NUIZ", @"实际收益($)");
    infoModel.valueText = model.actualIncome.thousandSeparatorAmountNoCurrencySymbol;
    [self.dataArr addObject:infoModel];

    infoModel = [self getonfigInfoViewModel];
    infoModel.keyText = TNLocalizedString(@"PhZAhu0l", @"收益状态");
    infoModel.valueText = model.settleStatusStr;
    infoModel.valueColor = HDAppTheme.TinhNowColor.cFF2323;
    [self.dataArr addObject:infoModel];

    //分割线  如果收益状态隐藏了  就是上个info的分割线
    infoModel.lineWidth = 0.5;
}
// configInfoViewModel
- (SAInfoViewModel *)getonfigInfoViewModel {
    SAInfoViewModel *infoModel = [[SAInfoViewModel alloc] init];
    infoModel.keyFont = HDAppTheme.TinhNowFont.standard12;
    infoModel.keyColor = HDAppTheme.TinhNowColor.G3;
    infoModel.valueFont = HDAppTheme.TinhNowFont.standard12M;
    infoModel.valueColor = HDAppTheme.TinhNowColor.G1;
    infoModel.lineWidth = 0;
    return infoModel;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
/** @lazy incomeDTO */
- (TNNewIncomeDTO *)incomeDTO {
    if (!_incomeDTO) {
        _incomeDTO = [[TNNewIncomeDTO alloc] init];
    }
    return _incomeDTO;
}
@end
