//
//  TNIncomeDetailViewModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/17.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNIncomeDetailViewModel.h"
#import "HDAppTheme+TinhNow.h"
#import "SAInfoView.h"
#import "TNIncomeDTO.h"


@interface TNIncomeDetailViewModel ()
@property (strong, nonatomic) TNIncomeDTO *incomeDto; ///<
@end


@implementation TNIncomeDetailViewModel

- (void)getDatailData {
    [self.view showloading];
    @HDWeakify(self);
    [self.incomeDto queryIncomeDeTailWithObjId:self.objId commissionLogType:self.type success:^(TNIncomeDetailModel *model) {
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

- (void)configInfoViewModels:(TNIncomeDetailModel *)model {
    SAInfoViewModel *infoModel = [self getonfigInfoViewModel];
    if (HDIsStringNotEmpty(model.completeTime)) {
        infoModel.keyText = TNLocalizedString(@"tn_order_done_time", @"订单完成时间");
        infoModel.valueText = model.completeTime;
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
                ;
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
    infoModel.valueText = model.totalAmountMoney.thousandSeparatorAmountNoCurrencySymbol;
    [self.dataArr addObject:infoModel];

    infoModel = [self getonfigInfoViewModel];
    infoModel.keyText = TNLocalizedString(@"B1a17lZE", @"卖家收益($)");
    infoModel.valueText = model.commissionAmountMoney.thousandSeparatorAmountNoCurrencySymbol;
    [self.dataArr addObject:infoModel];

    infoModel = [self getonfigInfoViewModel];
    infoModel.keyText = TNLocalizedString(@"nL435bnw", @"平台服务费($)");
    infoModel.valueText = model.platformServiceFeeMoney.thousandSeparatorAmountNoCurrencySymbol;
    [self.dataArr addObject:infoModel];

    infoModel = [self getonfigInfoViewModel];
    infoModel.keyText = TNLocalizedString(@"OIV4NUIZ", @"实际收益($)");
    infoModel.valueText = model.actualIncomeMoney.thousandSeparatorAmountNoCurrencySymbol;
    [self.dataArr addObject:infoModel];

    if (!HDIsObjectNil(model.actualIncomeMoney) && [model.actualIncomeMoney.cent integerValue] >= 0) {
        infoModel = [self getonfigInfoViewModel];
        infoModel.keyText = TNLocalizedString(@"PhZAhu0l", @"收益状态");
        if (model.status == 1) {
            infoModel.valueText = TNLocalizedString(@"rwVSz8v3", @"可提现");
            infoModel.valueColor = HexColor(0x14B96D);
        } else {
            infoModel.valueText = TNLocalizedString(@"Ck5mgja4", @"不可提现");
            infoModel.valueColor = HDAppTheme.TinhNowColor.cFF2323;
        }
        [self.dataArr addObject:infoModel];
    }
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
/** @lazy incomeDto */
- (TNIncomeDTO *)incomeDto {
    if (!_incomeDto) {
        _incomeDto = [[TNIncomeDTO alloc] init];
    }
    return _incomeDto;
}
@end
