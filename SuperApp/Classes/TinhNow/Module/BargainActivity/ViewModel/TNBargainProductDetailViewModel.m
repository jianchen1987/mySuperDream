//
//  TNBargainProductDetailViewModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/7/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNBargainProductDetailViewModel.h"
#import "HDAppTheme+TinhNow.h"
#import "SAAppEnvManager.h"
#import "SAInfoViewModel.h"
#import "SAMoneyModel.h"
#import "SANoDataCellModel.h"
#import "TNAddItemToShoppingCarRspModel.h"
#import "TNBargainDTO.h"
#import "TNDecimalTool.h"
#import "TNDeliverFlowModel.h"
#import "TNExplanationAlertView.h"
#import "TNHostUrlConst.h"
#import "TNItemModel.h"

#import "TNProductDetailExpressCell.h"
#import "TNProductDetailPublicImgCell.h"
#import "TNProductDetailServiceCell.h"
#import "TNProductDetailsActivityCell.h"
#import "TNProductDetailsIntroTableViewCell.h"
#import "TNProductDetailsIntroductionTableViewCell.h"
#import "TNProductDetailsRspModel.h"
#import "TNProductReviewModel.h"
#import "TNProductReviewTableViewCell.h"
#import "TNProductSaleRegionModel.h"
#import "TNProductSepcInfoModel.h"
#import "TNProductServiceInfoModel.h"
#import "TNProductSkuModel.h"
#import "TNProductSpecificationModel.h"


@interface TNBargainProductDetailViewModel ()
///
@property (strong, nonatomic) TNBargainDTO *bargainDto;
/// 商品基础信息
@property (nonatomic, strong) HDTableViewSectionModel *productIntroSection;
/// 商品运送相关
@property (nonatomic, strong) HDTableViewSectionModel *productExpressSection;
/// 商品服务
@property (nonatomic, strong) HDTableViewSectionModel *productServiceSection;
/// 商品详情
@property (nonatomic, strong) HDTableViewSectionModel *productInfoSection;
/// 公共详情图片
@property (nonatomic, strong) HDTableViewSectionModel *publicImgSection;
@end


@implementation TNBargainProductDetailViewModel
/// 获取砍价商品详情
- (void)queryBargainProductDetailsData {
    [self.view showloading];
    @HDWeakify(self);
    [self.bargainDto queryBargainProductDetailsWithActivityId:self.activityId success:^(TNProductDetailsRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.productDetailsModel = rspModel;
        [self generateProductDetailsDataWithRspModel:self.productDetailsModel];
        self.refreshFlag = !self.refreshFlag;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        !self.failGetProductDetaulDataCallBack ?: self.failGetProductDetaulDataCallBack(rspModel);
    }];
}
- (void)generateProductDetailsDataWithRspModel:(TNProductDetailsRspModel *)rspModel {
    if (HDIsObjectNil(rspModel)) {
        return;
    }
    NSMutableArray<HDTableViewSectionModel *> *dataSource = NSMutableArray.new;
    [self.titleArr removeAllObjects];

    TNProductDetailsIntroTableViewCellModel *model = TNProductDetailsIntroTableViewCellModel.new;
    model.images = [NSArray arrayWithArray:rspModel.productImages];
    model.productName = rspModel.name;
    //    model.priceRange = [rspModel getPriceRange];
    model.isCollected = rspModel.collectFlag;
    model.productId = rspModel.productId;
    model.sn = rspModel.sn;
    model.videoList = [NSArray arrayWithArray:rspModel.videoList];

    //砍价， 默认取市场价， 如果路由有传price则取price
    NSString *priceStr = TNLocalizedString(@"tn_bargain_price_k", @"价值");
    NSString *newPriceStr = @"";
    newPriceStr = [priceStr stringByAppendingFormat:@" %@", rspModel.marketPrice.thousandSeparatorAmount];
    if (HDIsStringNotEmpty(self.bargainPrice)) {
        newPriceStr = [priceStr stringByAppendingFormat:@" %@", self.bargainPrice];
    }
    model.price = newPriceStr;

    model.goodsLimitBuy = rspModel.goodsLimitBuy;
    model.maxLimit = rspModel.maxLimit;
    model.salesLabel = rspModel.salesLabel;
    model.detailViewType = TNProductDetailViewTypeBargain;
    model.announcement = rspModel.announcement;
    model.type = rspModel.type;
    model.revenue = !HDIsObjectNil(rspModel.revenue) ? rspModel.revenue.thousandSeparatorAmount : @"";
    model.tradePrice = !HDIsObjectNil(rspModel.tradePrice) ? rspModel.tradePrice.thousandSeparatorAmount : @"";
    model.isJoinSales = rspModel.isJoinSales;
    model.isHonor = rspModel.isHonor;
    if ([rspModel.type isEqualToString:TNGoodsTypeOverseas]) {
        model.isFreeShipping = rspModel.freightSetting;
    }
    NSComparisonResult result = [[TNDecimalTool toDecimalNumber:rspModel.marketPrice.cent] compare:[TNDecimalTool toDecimalNumber:rspModel.price.cent]]; //市场价小于售价的不显示市场价
    if (rspModel.marketPrice.cent.doubleValue > 0 && result == NSOrderedDescending) {
        model.originalPrice = rspModel.marketPrice.thousandSeparatorAmount;
    }
    //显示折扣
    if (HDIsStringNotEmpty(rspModel.showDisCount)) {
        model.discount = rspModel.showDisCount;
    }
    self.productIntroSection.list = @[model];
    [dataSource addObject:self.productIntroSection];

    //添加商品标题
    [self.titleArr addObject:[self createTitleModel:TNLocalizedString(@"tn_productDetail_item", @"商品") section:(dataSource.count - 1) sectionHeader:NO]];

    // 商品服务
    NSMutableArray *infoArray = NSMutableArray.new;
    {
        if (HDIsStringNotEmpty(rspModel.khrExchangeRate)) {
            SAInfoViewModel *exchangeInfoModel = SAInfoViewModel.new;
            exchangeInfoModel.valueAlignmentToOther = NSTextAlignmentLeft;
            exchangeInfoModel.keyToValueWidthRate = 0.4;
            exchangeInfoModel.valueNumbersOfLines = 1;
            exchangeInfoModel.keyFont = HDAppTheme.TinhNowFont.standard15;
            exchangeInfoModel.keyColor = HDAppTheme.TinhNowColor.G3;
            exchangeInfoModel.valueColor = HDAppTheme.TinhNowColor.G1;
            exchangeInfoModel.keyText = TNLocalizedString(@"tn_exchange_rate_k", @"汇率");
            exchangeInfoModel.valueText = rspModel.khrExchangeRate;
            [infoArray addObject:exchangeInfoModel];
        }

        //发货 saleRegoin
        TNProductSaleRegionCellModel *saleAreaModel = TNProductSaleRegionCellModel.new;
        saleAreaModel.keyText = TNLocalizedString(@"tn_product_details_saleArea", @"配送");
        saleAreaModel.valueAlignmentToOther = NSTextAlignmentLeft;
        saleAreaModel.keyToValueWidthRate = 0.4;
        saleAreaModel.valueNumbersOfLines = 1;
        saleAreaModel.keyFont = HDAppTheme.TinhNowFont.standard15;
        saleAreaModel.keyColor = HDAppTheme.TinhNowColor.G3;
        saleAreaModel.valueColor = HDAppTheme.TinhNowColor.G1;

        //显示 配送至全国 --- 不能点击，就不显示箭头
        NSString *saleRegionStr = [NSString stringWithFormat:@"%@ %@", TNLocalizedString(@"tn_product_detail_ship_to", @"配送至"), TNLocalizedString(@"tn_product_detail_Cambodia", @"全国")];
        saleAreaModel.rightButtonImage = nil;
        if (rspModel.storeRegion.regionType == TNRegionTypeSpecifiedArea) { //指定区域
            saleRegionStr = [NSString stringWithFormat:@"%@ %@", TNLocalizedString(@"tn_product_detail_only_regoin", @"仅配送至"), rspModel.storeRegion.regionNames];
            saleAreaModel.rightButtonImage = [UIImage imageNamed:@"arrow_gray_small"];
        } else if (rspModel.storeRegion.regionType == 2) { //指定范围
            saleRegionStr = rspModel.storeRegion.regionNames;
            if (rspModel.canOpenMap) { //需要打开配送区域的
                saleAreaModel.rightButtonImage = [UIImage imageNamed:@"arrow_gray_small"];
            }
        }

        saleAreaModel.valueText = saleRegionStr;
        saleAreaModel.saleRegionModel = rspModel.storeRegion;
        saleAreaModel.lineWidth = 0;
        [infoArray addObject:saleAreaModel];
        //如果是海外购商品 全部要显示右箭头
        if ([rspModel.type isEqualToString:TNGoodsTypeOverseas]) {
            saleAreaModel.rightButtonImage = [UIImage imageNamed:@"arrow_gray_small"];
            //海外购 显示国际物流提示
            TNDeliverFlowModel *fModel = [TNDeliverFlowModel modelWithDepartTxt:rspModel.departTxt interShippingTxt:rspModel.interShippingTxt arriveTxt:rspModel.arriveTxt];
            [infoArray addObject:fModel];
        }
    }

    self.productExpressSection.list = [NSArray arrayWithArray:infoArray];
    [dataSource addObject:self.productExpressSection];

    //服务保障
    if (!HDIsArrayEmpty(rspModel.servicesGuaranteeList)) {
        NSArray *serviceArr = rspModel.servicesGuaranteeList;
        if (serviceArr.count > 4) {
            serviceArr = [serviceArr subarrayWithRange:NSMakeRange(0, 4)];
        }
        TNProductDetailServiceCellModel *cellModel = [[TNProductDetailServiceCellModel alloc] init];
        cellModel.servicesList = serviceArr;
        cellModel.notSetCellInset = YES;
        self.productServiceSection.list = @[cellModel];
        [dataSource addObject:self.productServiceSection];
    }

    // 公共详情图片
    if (!HDIsObjectNil(rspModel.productDetailPublicImgDTO)) {
        TNProductDetailPublicImgCellModel *publicImgCellModel = TNProductDetailPublicImgCellModel.new;
        publicImgCellModel.publicDetailImgUrl = rspModel.productDetailPublicImgDTO.publicDetailImgUrl;
        publicImgCellModel.publicDetailAppLink = rspModel.productDetailPublicImgDTO.publicDetailAppLink;
        publicImgCellModel.publicDetailH5Link = rspModel.productDetailPublicImgDTO.publicDetailH5Link;
        publicImgCellModel.notSetCellInset = YES;
        self.publicImgSection.list = @[publicImgCellModel];
        [dataSource addObject:self.publicImgSection];
    }

    // 商品介绍
    TNProductDetailsIntroductionTableViewCellModel *introductionMoel = TNProductDetailsIntroductionTableViewCellModel.new;
    introductionMoel.htmlStr = rspModel.introduction;
    introductionMoel.storeId = rspModel.storeNo;
    self.productInfoSection.list = @[introductionMoel];
    [dataSource addObject:self.productInfoSection];

    // 添加商品详情
    [self.titleArr addObject:[self createTitleModel:TNLocalizedString(@"tn_productDetail_detail", @"详情") section:(dataSource.count - 1)
                                      sectionHeader:self.productInfoSection.headerModel ? YES : NO]];

    self.dataSource = [NSArray arrayWithArray:dataSource];
}
- (TNProductNavTitleModel *)createTitleModel:(NSString *)title section:(NSInteger)section sectionHeader:(BOOL)isHaveSectionHeader {
    TNProductNavTitleModel *pTitleModel = TNProductNavTitleModel.new;
    pTitleModel.title = title;
    pTitleModel.section = section;
    pTitleModel.isSectionHeader = isHaveSectionHeader;
    return pTitleModel;
}

/** @lazy productIntroSection */
- (HDTableViewSectionModel *)productIntroSection {
    if (!_productIntroSection) {
        _productIntroSection = [[HDTableViewSectionModel alloc] init];
    }
    return _productIntroSection;
}

/** @lazy productServiceSection */
- (HDTableViewSectionModel *)productServiceSection {
    if (!_productServiceSection) {
        _productServiceSection = [[HDTableViewSectionModel alloc] init];
    }
    return _productServiceSection;
}
/** @lazy productExpressSection */
- (HDTableViewSectionModel *)productExpressSection {
    if (!_productExpressSection) {
        _productExpressSection = [[HDTableViewSectionModel alloc] init];
    }
    return _productExpressSection;
}
/** @lazy productDetailSection */
- (HDTableViewSectionModel *)productInfoSection {
    if (!_productInfoSection) {
        _productInfoSection = [[HDTableViewSectionModel alloc] init];
        HDTableHeaderFootViewModel *headModel = HDTableHeaderFootViewModel.new;
        headModel.title = TNLocalizedString(@"tn_product_details", @"Details");
        _productInfoSection.headerModel = headModel;
    }
    return _productInfoSection;
}

- (HDTableViewSectionModel *)publicImgSection {
    if (!_publicImgSection) {
        _publicImgSection = [[HDTableViewSectionModel alloc] init];
    }
    return _publicImgSection;
}

- (NSMutableArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [NSMutableArray array];
    }
    return _titleArr;
}
/** @lazy bargainDto */
- (TNBargainDTO *)bargainDto {
    if (!_bargainDto) {
        _bargainDto = [[TNBargainDTO alloc] init];
    }
    return _bargainDto;
}
@end
