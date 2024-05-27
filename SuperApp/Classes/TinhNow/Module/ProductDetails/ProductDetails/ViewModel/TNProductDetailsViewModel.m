//
//  TNSectionTableViewSceneViewModel.m
//  SuperApp
//
//  Created by seeu on 2020/7/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNProductDetailsViewModel.h"
#import "HDAppTheme+TinhNow.h"
#import "SAAppEnvManager.h"
#import "SAInfoViewModel.h"
#import "SAMoneyModel.h"
#import "SANoDataCellModel.h"
#import "TNAddItemToShoppingCarRspModel.h"
#import "TNDecimalTool.h"
#import "TNDeliverFlowModel.h"
#import "TNExplanationAlertView.h"
#import "TNHostUrlConst.h"
#import "TNItemModel.h"
#import "TNMarkupPriceSettingAlertView.h"
#import "TNMicroShopDTO.h"
#import "TNProductBannerCell.h"
#import "TNProductBaseInfoCell.h"
#import "TNProductBatchBuyPriceCell.h"
#import "TNProductBatchToggleCell.h"
#import "TNProductDTO.h"
#import "TNProductDetailCardCell.h"
#import "TNProductDetailExpressCell.h"
#import "TNProductDetailPublicImgCell.h"
#import "TNProductDetailRecommendCell.h"
#import "TNProductDetailServiceCell.h"
#import "TNProductDetailsActivityCell.h"
#import "TNProductDetailsIntroTableViewCell.h"
#import "TNProductDetailsIntroductionTableViewCell.h"
#import "TNProductDetailsRspModel.h"
#import "TNProductDetailsStoreCell.h"
#import "TNProductReviewModel.h"
#import "TNProductReviewTableViewCell.h"
#import "TNProductSaleRegionModel.h"
#import "TNProductSepcInfoModel.h"
#import "TNProductServiceInfoModel.h"
#import "TNProductSingleBuyPriceCell.h"
#import "TNProductSkuModel.h"
#import "TNProductSpecificationModel.h"
#import "TNQueryGoodsRspModel.h"
#import "TNQueryProductReviewListRspModel.h"
#import "TNReviewDTO.h"
#import "TNShoppingCarDTO.h"
#import "TNDeliveryComponyAlertView.h"


@interface TNProductDetailsViewModel ()
/// dto
@property (nonatomic, strong) TNProductDTO *productDTO;
/// 评论DTO
@property (nonatomic, strong) TNReviewDTO *reviewDTO;
/// 购物车DTO
@property (nonatomic, strong) TNShoppingCarDTO *shoppingCartDTO;
/// banner
@property (nonatomic, strong) HDTableViewSectionModel *bannerSection;
/// 商品基础信息
@property (nonatomic, strong) HDTableViewSectionModel *productIntroSection;
/// 商品运送相关
@property (nonatomic, strong) HDTableViewSectionModel *productExpressSection;
/// 商品服务
@property (nonatomic, strong) HDTableViewSectionModel *productServiceSection;
/// 商品评论
@property (nonatomic, strong) HDTableViewSectionModel *productReviewSection;
/// 商品详情
@property (nonatomic, strong) HDTableViewSectionModel *productInfoSection;
/// 店铺信息
@property (nonatomic, strong) HDTableViewSectionModel *storeInfoSection;
/// 活动（砍价、拼团）
@property (nonatomic, strong) HDTableViewSectionModel *activitySection;
/// 新品推荐
@property (nonatomic, strong) HDTableViewSectionModel *recommenSection;
/// TG获取优惠
@property (nonatomic, strong) HDTableViewSectionModel *telegramSection;
/// 计费标准数据
@property (nonatomic, strong) NSArray<TNDeliveryComponyModel *> *deliveryComponylist;
/// 公共详情图片
@property (nonatomic, strong) HDTableViewSectionModel *publicImgSection;
/// 电商卖家DTO
@property (strong, nonatomic) TNMicroShopDTO *microShopDTO;
/// 店铺热卖推荐
@property (strong, nonatomic) NSArray *storeHotProductList;

/// 评论模型
@property (strong, nonatomic) TNProductReviewTableViewCellModel *reviewCellModel;
@end


@implementation TNProductDetailsViewModel
/// 获取普通商品详情
- (void)queryNomalProductDetailsData {
    @HDWeakify(self);
    [self.view showloading];
    [self.productDTO queryProductDetailsWithProductId:self.productId sp:self.detailViewStyle == TNProductDetailViewTypeMicroShop ? self.sp : @""
        detailType:self.detailViewStyle == TNProductDetailViewTypeSupplyAndMarketing ? 1 : 0
        sn:self.sn
        channel:self.channel
        supplierId:self.supplierId success:^(TNProductDetailsRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            if (self == nil) {
                return;
            }
            self.productDetailsModel = rspModel;
            self.productId = rspModel.productId;
            if ([rspModel.type isEqualToString:TNGoodsTypeOverseas]) {
                self.trackPrefixName = TNTrackEventPrefixNameOverseas;
            } else if ([rspModel.type isEqualToString:TNGoodsTypeGeneral]) {
                self.trackPrefixName = TNTrackEventPrefixNameFastConsume;
            } else {
                self.trackPrefixName = TNTrackEventPrefixNameOther;
            }
            if (HDIsStringEmpty(self.funnel) || ![self.funnel containsString:@"电商-"]) { //包含是为了过滤2.9.5版本之前的漏斗
                self.funnel = [self.trackPrefixName stringByAppendingString:@"商品详情_"];
            }

            if ([SAUser hasSignedIn] && rspModel.isSupplier == YES && HDIsStringEmpty([TNGlobalData shared].seller.supplierId)) {
                //是卖家身份  但是卖家身份信息没有拿到 先去拉取卖家数据
                [self reloadSellerData];
            } else if ([SAUser hasSignedIn] && rspModel.isSupplier == NO && HDIsStringNotEmpty([TNGlobalData shared].seller.supplierId)) {
                [self.view dismissLoading];
                //卖家身份被禁用了  但是没有清理掉卖家信息
                [TNGlobalData shared].seller = nil;
                [self generateProductDetailsDataWithRspModel:self.productDetailsModel];
                self.refreshFlag = !self.refreshFlag;
            } else {
                [self.view dismissLoading];
                [self generateProductDetailsDataWithRspModel:self.productDetailsModel];
                self.refreshFlag = !self.refreshFlag;
            }
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
            !self.failGetProductDetaulDataCallBack ?: self.failGetProductDetaulDataCallBack(rspModel);
        }];
}
///重新刷新卖家数据
- (void)reloadSellerData {
    @HDWeakify(self);
    [self.microShopDTO queryMyMicroShopInfoDataSuccess:^(TNSeller *_Nonnull info) {
        @HDStrongify(self);
        [self.view dismissLoading];
        [self generateProductDetailsDataWithRspModel:self.productDetailsModel];
        self.refreshFlag = !self.refreshFlag;
        if (HDIsStringNotEmpty(info.supplierId)) {
            //获取加价策略
            [self.microShopDTO querySellPricePolicyWithSupplierId:info.supplierId success:^(TNMicroShopPricePolicyModel *_Nonnull policyModel) {
                [TNGlobalData shared].seller.pricePolicyModel = policyModel;
            } failure:nil];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        [self.view dismissLoading];
        !self.failGetProductDetaulDataCallBack ?: self.failGetProductDetaulDataCallBack(rspModel);
    }];
}
- (void)addProductToShoppingCartWithItemModel:(TNItemModel *)itemModel
                                      success:(void (^_Nullable)(TNAddItemToShoppingCarRspModel *rspModel))successBlock
                                      failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    [self.shoppingCartDTO addItem:itemModel toShoppingCarSuccess:^(TNAddItemToShoppingCarRspModel *_Nonnull addItemToCartRspModel) {
        successBlock(addItemToCartRspModel);
    } failure:failureBlock];
}
/// 获取评价数据
- (void)queryReviewDataComplete:(void (^)(NSIndexPath *indexPath))complete {
    @HDWeakify(self);
    [self.reviewDTO queryProductReviewListWithProductId:self.productDetailsModel.productId pageNum:1 pageSize:1 success:^(TNQueryProductReviewListRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        if (self == nil) {
            return;
        }
        NSMutableArray<TNProductReviewTableViewCellModel *> *tmp = NSMutableArray.new;
        if (!HDIsArrayEmpty(rspModel.content)) {
            for (TNProductReviewModel *model in rspModel.content) {
                self.reviewCellModel = [TNProductReviewTableViewCellModel modelWithProductReviewModel:model];
                self.reviewCellModel.totalReviews = rspModel.total;
                [tmp addObject:self.reviewCellModel];
            }
        } else {
            self.reviewCellModel = [[TNProductReviewTableViewCellModel alloc] init];
            self.reviewCellModel.totalReviews = 0;
            [tmp addObject:self.reviewCellModel];
        }

        self.productReviewSection.list = [NSArray arrayWithArray:tmp];
        if (self.dataSource > 0 && [self.dataSource containsObject:self.productReviewSection]) {
            NSInteger section = [self.dataSource indexOfObject:self.productReviewSection];
            !complete ?: complete([NSIndexPath indexPathForRow:0 inSection:section]);
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];
}

- (void)queryStoreHotProductRecommendComplete:(void (^)(NSIndexPath *_Nonnull))complete {
    @HDWeakify(self);
    [self.productDTO queryProductRecommondWithProductId:self.productDetailsModel.productId type:1 sp:self.detailViewStyle == TNProductDetailViewTypeSupplyAndMarketing ? @"" : self.sp pageNo:1
                                               pageSize:6 success:^(TNQueryGoodsRspModel *_Nonnull rspModel) {
                                                   @HDStrongify(self);
                                                   if (self == nil) {
                                                       return;
                                                   }
                                                   self.storeHotProductList = rspModel.list;
                                                   if (!HDIsArrayEmpty(self.storeInfoSection.list)) {
                                                       TNProductDetailsStoreCellModel *cellModel = self.storeInfoSection.list.firstObject;
                                                       cellModel.goodsArray = rspModel.list;
                                                       if (self.dataSource > 0 && [self.dataSource containsObject:self.storeInfoSection]) {
                                                           NSInteger section = [self.dataSource indexOfObject:self.storeInfoSection];
                                                           !complete ?: complete([NSIndexPath indexPathForRow:0 inSection:section]);
                                                       }
                                                   }
                                               } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

                                               }];
}

- (void)queryNewProductRecommendComplete:(void (^)(NSIndexPath *_Nonnull))complete {
    @HDWeakify(self);
    [self.productDTO queryProductRecommondWithProductId:self.productDetailsModel.productId type:2 sp:self.detailViewStyle == TNProductDetailViewTypeSupplyAndMarketing ? @"" : self.sp pageNo:1
                                               pageSize:10 success:^(TNQueryGoodsRspModel *_Nonnull rspModel) {
                                                   @HDStrongify(self);
                                                   if (self == nil) {
                                                       return;
                                                   }
                                                   if (!HDIsArrayEmpty(rspModel.list)) {
                                                       self.recommendNewProductList = rspModel.list;
                                                       TNProductDetailRecommendCellModel *recommendModel = [[TNProductDetailRecommendCellModel alloc] init];
                                                       recommendModel.goodsArray = rspModel.list;
                                                       recommendModel.sp = self.sp;
                                                       self.recommenSection.list = @[recommendModel];
                                                       if (!HDIsArrayEmpty(self.titleArr)) {
                                                           [self.titleArr addObject:[self createTitleModel:TNLocalizedString(@"tn_recommend", @"推荐") section:(self.dataSource.count - 1)
                                                                                             sectionHeader:YES]];
                                                       }
                                                   }
                                                   if (self.dataSource > 0 && [self.dataSource containsObject:self.recommenSection]) {
                                                       NSInteger section = [self.dataSource indexOfObject:self.recommenSection];
                                                       !complete ?: complete([NSIndexPath indexPathForRow:0 inSection:section]);
                                                   }
                                               } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

                                               }];
}
#pragma mark -组装数据源
- (void)generateProductDetailsDataWithRspModel:(TNProductDetailsRspModel *)rspModel {
    if (HDIsObjectNil(rspModel)) {
        return;
    }

    //如果选品店铺有模型过来更新对应选品店铺的数据
    if (!HDIsObjectNil(self.sellerProductModel)) {
        self.sellerProductModel.sale = rspModel.isJoinSales;
        self.sellerProductModel.bulkPrice = rspModel.tradePrice;
        self.sellerProductModel.profit = rspModel.revenue;
        self.sellerProductModel.price = rspModel.price;
    }
    NSMutableArray<HDTableViewSectionModel *> *dataSource = NSMutableArray.new;
    [self.titleArr removeAllObjects];

    // banner图
    TNProductBannerCellModel *bannerModel = [[TNProductBannerCellModel alloc] init];
    bannerModel.images = [NSArray arrayWithArray:rspModel.productImages];
    bannerModel.videoList = [NSArray arrayWithArray:rspModel.videoList];

    if ([rspModel.type isEqualToString:TNGoodsTypeOverseas]) {
        bannerModel.isFreeShipping = rspModel.freightSetting;
    }
    self.bannerSection.list = @[bannerModel];
    [dataSource addObject:self.bannerSection];

    //添加商品标题
    [self.titleArr addObject:[self createTitleModel:TNLocalizedString(@"tn_productDetail_item", @"商品") section:(dataSource.count - 1) sectionHeader:NO]];

    NSMutableArray *sectionList = [NSMutableArray array];
    @HDWeakify(self);
    if (!HDIsObjectNil(rspModel.batchPriceInfo) && rspModel.batchPriceInfo.enabledStagePrice) {
        //批量切换视图
        TNProductBatchToggleCellModel *toggleModel = [[TNProductBatchToggleCellModel alloc] init];
        toggleModel.salesType = self.salesType;
        toggleModel.toggleCallBack = ^(TNSalesType _Nonnull salesType) {
            @HDStrongify(self);
            [self singleAndBatchToggleByType:salesType];
        };
        toggleModel.buyQustionCallBack = ^(TNSalesType _Nonnull salesType) {
            @HDStrongify(self);
            [self showBuyQuestionAlertView:salesType];
        };
        [sectionList addObject:toggleModel];
        if ([self.salesType isEqualToString:TNSalesTypeBatch]) {
            [sectionList addObject:[self getBatchBuyPriceCellModel]];
        } else {
            [sectionList addObject:[self getSingleBuyPriceCellModel]];
        }
    } else {
        ///只有单买样式
        [sectionList addObject:[self getSingleBuyPriceCellModel]];
    }

    //商品基本信息
    TNProductBaseInfoCellModel *baseModel = [[TNProductBaseInfoCellModel alloc] init];
    baseModel.productName = rspModel.name;
    baseModel.isCollected = rspModel.collectFlag;
    baseModel.salesLabel = rspModel.salesLabel;
    baseModel.announcement = rspModel.announcement;
    baseModel.type = rspModel.type;
    baseModel.isHonor = rspModel.isHonor;
    baseModel.storeType = rspModel.storeType;
    baseModel.detailViewStyle = self.detailViewStyle;
    baseModel.isJoinSales = rspModel.isJoinSales;
    if (!HDIsObjectNil(rspModel.batchPriceInfo) && rspModel.batchPriceInfo.enabledStagePrice && [self.salesType isEqualToString:TNSalesTypeBatch]) {
        baseModel.mixWholeSale = rspModel.batchPriceInfo.mixWholeSale;
    }
    @HDWeakify(baseModel);
    baseModel.favoriteClickCallBack = ^(BOOL isCollected) {
        @HDStrongify(self);
        @HDStrongify(baseModel);
        [self productFavoriteClick:isCollected baseInfoModel:baseModel];
    };
    baseModel.addOrCancelSalesClickCallBack = ^(BOOL isAdd) {
        @HDStrongify(self);
        @HDStrongify(baseModel);
        if (isAdd) { //加入销售
            if (!HDIsObjectNil([TNGlobalData shared].seller.pricePolicyModel) && [TNGlobalData shared].seller.pricePolicyModel.operationType != TNMicroShopPricePolicyTypeNone) {
                [self addOrCancelProductSales:isAdd baseInfoModel:baseModel];
            } else {
                [NAT showAlertWithMessage:TNLocalizedString(@"AKccELBK", @"暂未设置店铺加价，请先设置") confirmButtonTitle:TNLocalizedString(@"tn_button_confirm_title", @"确定")
                    confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        [self showSettingPricePolicyAlertViewWithSales:isAdd baseInfoModel:baseModel];
                        [alertView dismiss];
                    }
                    cancelButtonTitle:TNLocalizedString(@"tn_button_cancel_title", @"取消") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        [alertView dismiss];
                    }];
            }

        } else { //取消销售
            [NAT showAlertWithMessage:TNLocalizedString(@"SZwLu50L", @"确定移除所选商品？") confirmButtonTitle:TNLocalizedString(@"tn_button_confirm_title", @"确定")
                confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                    [self addOrCancelProductSales:isAdd baseInfoModel:baseModel];
                    [alertView dismiss];
                }
                cancelButtonTitle:TNLocalizedString(@"tn_button_cancel_title", @"取消") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                    [alertView dismiss];
                }];
        }
    };
    [sectionList addObject:baseModel];
    self.productIntroSection.list = sectionList;

    [dataSource addObject:self.productIntroSection];

    ///海外购加入TG section
    if ([rspModel.type isEqualToString:TNGoodsTypeOverseas]) {
        SAInfoViewModel *tgModel = [[SAInfoViewModel alloc] init];
        tgModel.leftImage = [UIImage imageNamed:@"tn_telegram_k"];
        tgModel.keyFont = [HDAppTheme.TinhNowFont fontMedium:12];
        tgModel.keyColor = HDAppTheme.TinhNowColor.G1;
        tgModel.keyText = TNLocalizedString(@"tn_jion_telegram", @"加入Telegram群获取更多优惠");
        tgModel.rightButtonImage = [UIImage imageNamed:@"arrow_gray_small"];
        tgModel.enableTapRecognizer = YES;
        tgModel.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(10), kRealWidth(12), kRealWidth(10));
        tgModel.eventHandler = ^{
            [[HDMediator sharedInstance] navigaveTinhNowTelegramGroupViewController:@{}];
        };
        self.telegramSection.list = @[tgModel];
        [dataSource addObject:self.telegramSection];
    }

    //活动信息显示
    if (self.detailViewStyle == TNProductDetailViewTypeNomal) {
        if (rspModel.productActivityList.count > 0) {
            NSMutableArray *acList = [NSMutableArray array];
            [rspModel.productActivityList enumerateObjectsUsingBlock:^(TNProductActivityModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                // v2.4.5 目前只有砍价才需要显示，其他的暂时过滤掉
                if (obj && obj.type == 0) {
                    TNProductDetailsActivityCellModel *cellModel = TNProductDetailsActivityCellModel.new;
                    cellModel.model = obj;
                    [acList addObject:cellModel];
                }
            }];
            self.activitySection.list = [NSArray arrayWithArray:acList];
            [dataSource addObject:self.activitySection];
        }
    }

    void (^setInfoViewModelProperty)(SAInfoViewModel *infoModel) = ^(SAInfoViewModel *infoModel) {
        infoModel.valueAlignmentToOther = NSTextAlignmentLeft;
        infoModel.keyToValueWidthRate = 0.4;
        infoModel.valueNumbersOfLines = 1;
        infoModel.keyFont = [HDAppTheme.TinhNowFont fontMedium:14];
        infoModel.keyColor = HDAppTheme.TinhNowColor.G1;
        infoModel.valueColor = HDAppTheme.TinhNowColor.G1;
        infoModel.valueFont = HDAppTheme.TinhNowFont.standard14;
        infoModel.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(10), kRealWidth(12), kRealWidth(10));
    };

    ///指定宽度
    CGFloat infoKeyWidth = kRealWidth(63);
    // 商品服务
    NSMutableArray *infoArray = NSMutableArray.new;
    if (HDIsStringNotEmpty(rspModel.khrExchangeRate)) {
        SAInfoViewModel *exchangeInfoModel = SAInfoViewModel.new;
        setInfoViewModelProperty(exchangeInfoModel);
        exchangeInfoModel.keyText = TNLocalizedString(@"tn_exchange_rate_k", @"汇率");
        exchangeInfoModel.valueText = rspModel.khrExchangeRate;
        exchangeInfoModel.keyWidth = infoKeyWidth;
        [infoArray addObject:exchangeInfoModel];
    }

    if (rspModel.skus.count > 1 && self.detailViewStyle != TNProductDetailViewTypeBargain) { //砍价页面来的也不显示规格选择
        TNProductSepcInfoModel *specInfoModel = TNProductSepcInfoModel.new;
        setInfoViewModelProperty(specInfoModel);
        specInfoModel.keyText = TNLocalizedString(@"tn_choose_sku", @"选择");
        NSString *specs = @"";
        for (TNProductSpecificationModel *spe in rspModel.specs) {
            if (specs.length > 0) {
                specs = [specs stringByAppendingFormat:@",%@", spe.specName];
            } else {
                specs = [specs stringByAppendingFormat:@"%@", spe.specName];
            }
        }
        specInfoModel.valueText = specs;
        specInfoModel.rightButtonImage = [UIImage imageNamed:@"arrow_gray_small"];
        specInfoModel.keyWidth = infoKeyWidth;
        [infoArray addObject:specInfoModel];
    }

    // v2.4.5 砍价活动不显示运费
    if (self.detailViewStyle != TNProductDetailViewTypeBargain) {
        SAInfoViewModel *freightInfoModel = SAInfoViewModel.new;
        setInfoViewModelProperty(freightInfoModel);
        freightInfoModel.keyText = TNLocalizedString(@"tn_delivery_fee", @"运费");
        //如果是海外购商品 有海外购运费文案就显示海外文案
        NSString *freight = @"";
        if ([rspModel.type isEqualToString:TNGoodsTypeOverseas]) {
            if (rspModel.freightSetting) {
                //免邮
                freightInfoModel.valueImage = [UIImage imageNamed:@"tn_small_freeshipping"];
                freightInfoModel.valueImageEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
                freight = TNLocalizedString(@"QnZH0Z83", @"免邮");
            } else {
                freight = TNLocalizedString(@"4ENkxCpS", @"运费到付，点击查看物流计费标准");
                freightInfoModel.valueImage = [UIImage imageNamed:@""];
                freightInfoModel.resetValueImage = YES;
                freightInfoModel.rightButtonImage = [UIImage imageNamed:@"arrow_gray_small"];
                freightInfoModel.enableTapRecognizer = YES;
                @HDWeakify(self);
                freightInfoModel.eventHandler = ^{
                    @HDStrongify(self);
                    [self showFreightCostsAlertView];
                };
            }
        } else {
            freight = [NSString stringWithFormat:@"%@%@", rspModel.freightCurrency, rspModel.freightPrice];
        }
        freightInfoModel.valueText = freight;
        freightInfoModel.keyWidth = infoKeyWidth;
        [infoArray addObject:freightInfoModel];

        //运费优惠活动
        if (!HDIsArrayEmpty(self.productDetailsModel.promotionList)) {
            //筛选出 运费相关的活动展示
            TNPromotionModel *pModel = nil;
            for (TNPromotionModel *oModel in self.productDetailsModel.promotionList) {
                if ([oModel.marketingType containsString:TNMarketingTypeFeeReduce]) {
                    pModel = oModel;
                    break;
                }
            }
            if (!HDIsObjectNil(pModel)) {
                SAInfoViewModel *infoModel = SAInfoViewModel.new;
                setInfoViewModelProperty(infoModel);
                infoModel.keyText = pModel.name;
                infoModel.keyNumbersOfLines = 0;
                infoModel.keyFont = HDAppTheme.TinhNowFont.standard14;
                infoModel.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(10), kRealWidth(12), kRealWidth(10));
                [infoArray addObject:infoModel];
                if (HDIsStringNotEmpty(infoModel.keyText)) {
                    freightInfoModel.lineWidth = 0;
                }
            }
        }
    }

    {
        //发货 saleRegoin
        TNProductSaleRegionCellModel *saleAreaModel = TNProductSaleRegionCellModel.new;
        setInfoViewModelProperty(saleAreaModel);
        saleAreaModel.keyText = TNLocalizedString(@"tn_product_details_saleArea", @"配送");
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
        saleAreaModel.keyWidth = infoKeyWidth;
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

        self.productServiceSection.list = @[cellModel];
        [dataSource addObject:self.productServiceSection];
    }

    // 商品评论
    if (!HDIsObjectNil(self.reviewCellModel)) {
        self.productReviewSection.list = @[self.reviewCellModel];
    }
    [dataSource addObject:self.productReviewSection];

    // 店铺info
    TNProductDetailsStoreCellModel *storeCellModel = TNProductDetailsStoreCellModel.new;
    storeCellModel.storeModel = rspModel.storeProductInfo;
    storeCellModel.detailViewStyle = self.detailViewStyle;
    storeCellModel.sp = self.sp;
    storeCellModel.trackPrefixName = self.trackPrefixName;
    storeCellModel.productId = self.productId;
    if (!HDIsArrayEmpty(self.storeHotProductList)) {
        storeCellModel.goodsArray = self.storeHotProductList;
    }
    self.storeInfoSection.list = @[storeCellModel];
    [dataSource addObject:self.storeInfoSection];

    // 公共详情图片
    if (!HDIsObjectNil(rspModel.productDetailPublicImgDTO)) {
        TNProductDetailPublicImgCellModel *publicImgCellModel = TNProductDetailPublicImgCellModel.new;
        publicImgCellModel.publicDetailImgUrl = rspModel.productDetailPublicImgDTO.publicDetailImgUrl;
        publicImgCellModel.publicDetailAppLink = rspModel.productDetailPublicImgDTO.publicDetailAppLink;
        publicImgCellModel.publicDetailH5Link = rspModel.productDetailPublicImgDTO.publicDetailH5Link;
        self.publicImgSection.list = @[publicImgCellModel];
        [dataSource addObject:self.publicImgSection];
    }

    // 商品介绍
    TNProductDetailCardCellModel *introductionMoel = TNProductDetailCardCellModel.new;
    introductionMoel.html = rspModel.introduction;
    introductionMoel.storeId = rspModel.storeNo;
    if (!HDIsArrayEmpty(rspModel.productImages)) {
        introductionMoel.imageStr = rspModel.productImages.firstObject.medium;
    }
    introductionMoel.type = rspModel.type;
    self.productInfoSection.list = @[introductionMoel];
    [dataSource addObject:self.productInfoSection];

    // 添加商品详情标题
    [self.titleArr addObject:[self createTitleModel:TNLocalizedString(@"tn_productDetail_detail", @"详情") section:(dataSource.count - 1)
                                      sectionHeader:self.productInfoSection.headerModel ? YES : NO]];

    //新品推荐
    if (!HDIsArrayEmpty(self.recommendNewProductList)) {
        TNProductDetailRecommendCellModel *recommendModel = [[TNProductDetailRecommendCellModel alloc] init];
        recommendModel.goodsArray = self.recommendNewProductList;
        recommendModel.sp = self.sp;
        self.recommenSection.list = @[recommendModel];
    }
    [dataSource addObject:self.recommenSection];

    //添加新品推荐标题
    if (!HDIsArrayEmpty(self.recommendNewProductList)) {
        [self.titleArr addObject:[self createTitleModel:TNLocalizedString(@"tn_recommend", @"推荐") section:(dataSource.count - 1) sectionHeader:YES]];
    }

    self.dataSource = [NSArray arrayWithArray:dataSource];

    //获取分销客shareCode 用于统计佣金  "https:\/\/tinhnow-sit.wownow.net\/h5\/goodsdetails?productId=32838&f=buyNow&sc=b100a3fb21be4c3dbdbaf9d16330b60b"
    if (HDIsStringNotEmpty(rspModel.shareUrl)) {
        NSArray *compoents = [rspModel.shareUrl componentsSeparatedByString:@"&"];
        NSString *shareCode;
        for (NSString *str in compoents) {
            if ([str containsString:@"sc="]) {
                shareCode = str;
                break;
            }
        }
        if (HDIsStringNotEmpty(shareCode)) {
            NSArray *codeComponts = [shareCode componentsSeparatedByString:@"="];
            if (!HDIsArrayEmpty(codeComponts)) {
                rspModel.shareCode = codeComponts.lastObject;
            }
        }
    }

    // 如果详情数据的shareURL有sc 则不进行覆盖
    if (HDIsStringEmpty(rspModel.shareCode) && HDIsStringNotEmpty(self.shareCode)) {
        rspModel.shareCode = self.shareCode;
    }

    //  如果有sp 且不是选品的
    if (HDIsStringNotEmpty(self.sp) && self.detailViewStyle != TNProductDetailViewTypeSupplyAndMarketing) {
        rspModel.sp = self.sp;
    }

    //将详情类型带过来
    self.productDetailsModel.batchPriceInfo.detailViewType = self.detailViewStyle;
}

/// 批量价格视图cellModel
- (TNProductBatchBuyPriceCellModel *)getBatchBuyPriceCellModel {
    TNProductBatchBuyPriceCellModel *cellModel = [[TNProductBatchBuyPriceCellModel alloc] init];
    TNProductBatchPriceInfoModel *infoModel = self.productDetailsModel.batchPriceInfo;
    infoModel.isJoinSales = self.productDetailsModel.isJoinSales;
    infoModel.detailViewType = self.detailViewStyle;
    infoModel.goodsLimitBuy = self.productDetailsModel.goodsLimitBuy;
    infoModel.maxLimit = self.productDetailsModel.maxLimit;
    cellModel.infoModel = infoModel;
    return cellModel;
}
/// 单买价格视图cellModel
- (TNProductSingleBuyPriceCellModel *)getSingleBuyPriceCellModel {
    TNProductSingleBuyPriceCellModel *singlePriceModel = [[TNProductSingleBuyPriceCellModel alloc] init];
    singlePriceModel.priceMoney = self.productDetailsModel.price;
    singlePriceModel.price = !HDIsObjectNil(self.productDetailsModel.price) ? self.productDetailsModel.price.thousandSeparatorAmount : @"";
    singlePriceModel.tradePrice = !HDIsObjectNil(self.productDetailsModel.tradePrice) ? self.productDetailsModel.tradePrice.thousandSeparatorAmount : @"";
    singlePriceModel.revenue = !HDIsObjectNil(self.productDetailsModel.revenue) ? self.productDetailsModel.revenue.thousandSeparatorAmount : @"";
    singlePriceModel.isJoinSales = self.productDetailsModel.isJoinSales;
    singlePriceModel.showDisCount = self.productDetailsModel.showDisCount;
    singlePriceModel.goodsLimitBuy = self.productDetailsModel.goodsLimitBuy;
    singlePriceModel.maxLimit = self.productDetailsModel.maxLimit;
    singlePriceModel.detailViewType = self.detailViewStyle;
    singlePriceModel.firstImageURL = self.productDetailsModel.productImages.firstObject.source;
    singlePriceModel.storeType = self.productDetailsModel.storeType;
    NSComparisonResult result =
        [[TNDecimalTool toDecimalNumber:self.productDetailsModel.marketPrice.cent] compare:[TNDecimalTool toDecimalNumber:self.productDetailsModel.price.cent]]; //市场价小于售价的不显示市场价
    if (self.productDetailsModel.marketPrice.cent.doubleValue > 0 && result == NSOrderedDescending) {
        singlePriceModel.marketPrice = self.productDetailsModel.marketPrice.thousandSeparatorAmount;
    }
    return singlePriceModel;
}
#pragma mark - 单买 批量切换点击
- (void)singleAndBatchToggleByType:(TNSalesType)buyType {
    if ([self.salesType isEqualToString:buyType]) {
        return;
    }
    self.salesType = buyType;
    NSMutableArray *sectionList = [NSMutableArray arrayWithArray:self.productIntroSection.list];
    __block NSInteger index;
    ///基本信息视图
    __block TNProductBaseInfoCellModel *baseModel;
    if ([buyType isEqualToString:TNSalesTypeBatch]) {
        //添加 批量视图
        [sectionList enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if ([obj isKindOfClass:[TNProductSingleBuyPriceCellModel class]]) {
                index = idx;
            }
            if ([obj isKindOfClass:TNProductBaseInfoCellModel.class]) {
                baseModel = (TNProductBaseInfoCellModel *)obj;
            }
        }];
        baseModel.mixWholeSale = self.productDetailsModel.batchPriceInfo.mixWholeSale;
        [sectionList replaceObjectAtIndex:index withObject:[self getBatchBuyPriceCellModel]];

    } else {
        //添加 单买视图
        [sectionList enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if ([obj isKindOfClass:[TNProductBatchBuyPriceCellModel class]]) {
                index = idx;
            }
            if ([obj isKindOfClass:TNProductBaseInfoCellModel.class]) {
                baseModel = obj;
            }
        }];
        baseModel.mixWholeSale = NO;
        [sectionList replaceObjectAtIndex:index withObject:[self getSingleBuyPriceCellModel]];
    }
    self.productIntroSection.list = sectionList;
    self.reloadData = !self.reloadData;
}

#pragma mark - 展示单买 批量购买 疑问按钮
- (void)showBuyQuestionAlertView:(TNSalesType)buyType {
    @HDWeakify(self);
    void (^showAlert)(void) = ^void {
        @HDStrongify(self);
        NSString *title = [buyType isEqualToString:TNSalesTypeSingle] ? TNLocalizedString(@"6jak19x8", @"单买") : TNLocalizedString(@"d6Te2ndf", @"批量");
        NSString *content = [buyType isEqualToString:TNSalesTypeSingle] ? self.purchaseTypeModel.singlePrice : self.purchaseTypeModel.batchPrice;

        TNExplanationAlertView *alertView = [[TNExplanationAlertView alloc] initWithTitle:title content:content];
        [alertView show];
    };
    if (!HDIsObjectNil(self.purchaseTypeModel)) {
        showAlert();
    } else {
        [self.view showloading];

        [self.productDTO queryBuyPurchaseTypeSuccess:^(TNProductPurchaseTypeModel *_Nonnull model) {
            @HDStrongify(self);
            [self.view dismissLoading];
            self.purchaseTypeModel = model;
            showAlert();
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
        }];
    }
}

#pragma mark -展示物流计费弹窗
- (void)showFreightCostsAlertView {
    if (!HDIsArrayEmpty(self.deliveryComponylist)) {
        TNDeliveryComponyAlertView *alertView = [[TNDeliveryComponyAlertView alloc] initWithTitle:TNLocalizedString(@"5JiVnZRY", @"物流计费标准") list:self.deliveryComponylist showTitle:YES];
        [alertView show];
    } else {
        [self.view showloading];
        @HDWeakify(self);
        [self.productDTO queryFreightStandardCostsByStoreNo:self.productDetailsModel.storeNo success:^(NSArray<TNDeliveryComponyModel *> *_Nonnull list) {
            @HDStrongify(self);
            [self.view dismissLoading];
            self.deliveryComponylist = list;
            TNDeliveryComponyAlertView *alertView = [[TNDeliveryComponyAlertView alloc] initWithTitle:TNLocalizedString(@"5JiVnZRY", @"物流计费标准") list:self.deliveryComponylist showTitle:YES];
            [alertView show];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
        }];
    }
}

#pragma mark -商品收藏
- (void)productFavoriteClick:(BOOL)isCollectioned baseInfoModel:(TNProductBaseInfoCellModel *)cellModel {
    [self.view showloading];
    @HDWeakify(self);
    if (isCollectioned) {
        [self.productDTO removeProdutFromFavoriteWithProductId:self.productDetailsModel.productId sp:self.sp success:^{
            @HDStrongify(self);
            [self.view dismissLoading];
            cellModel.isCollected = NO;
            self.reloadData = !self.reloadData;
            [HDTips showWithText:TNLocalizedString(@"tn_remove_favorite", @"取消收藏成功")];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
        }];
    } else {
        [self.productDTO addProductIntoFavoriteWithProductId:self.productDetailsModel.productId sp:self.sp success:^{
            @HDStrongify(self);
            [self.view dismissLoading];
            cellModel.isCollected = YES;
            self.reloadData = !self.reloadData;
            [HDTips showWithText:TNLocalizedString(@"tn_add_favorite", @"收藏成功")];
            //埋点
            [TNEventTrackingInstance trackEvent:@"favor" properties:@{@"productId": self.productId, @"type": @"1"}];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
        }];
    }
}

#pragma mark -加入 销售 取消销售
- (void)addOrCancelProductSales:(BOOL)isAdd baseInfoModel:(TNProductBaseInfoCellModel *)cellModel {
    [self.view showloading];
    if (isAdd) { //加入销售
        @HDWeakify(self);
        [self.microShopDTO addProductToSaleWithSupplierId:[TNGlobalData shared].seller.supplierId productId:self.productDetailsModel.productId categoryId:self.productDetailsModel.productCategoryId
            policyModel:[TNGlobalData shared].seller.pricePolicyModel success:^(NSArray<TNSellerProductModel *> *list) {
                @HDStrongify(self);
                [self.view dismissLoading];
                cellModel.isJoinSales = isAdd;
                self.reloadData = !self.reloadData;
                [TNGlobalData shared].seller.isNeedRefreshMicroShop = YES;
                //重新加载详情数据
                [self queryNomalProductDetailsData];
                [TNEventTrackingInstance trackEvent:@"buyer_add_product" properties:@{@"buyerId": [TNGlobalData shared].seller.supplierId, @"productId": self.productDetailsModel.productId}];
            } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                @HDStrongify(self);
                [self.view dismissLoading];
            }];

    } else { //取消销售
        @HDWeakify(self);
        [self.microShopDTO cancelProductSaleWithSupplierId:[TNGlobalData shared].seller.supplierId productId:self.productDetailsModel.productId success:^{
            @HDStrongify(self);
            [self.view dismissLoading];
            cellModel.isJoinSales = isAdd;
            self.reloadData = !self.reloadData;
            [TNGlobalData shared].seller.isNeedRefreshMicroShop = YES;
            //重新加载详情数据
            [self queryNomalProductDetailsData];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
        }];
    }
}

///设置加价弹窗
- (void)showSettingPricePolicyAlertViewWithSales:(BOOL)isAdd baseInfoModel:(TNProductBaseInfoCellModel *)cellModel {
    TNMarkupPriceSettingConfig *config = [TNMarkupPriceSettingConfig defaultConfig];
    TNMarkupPriceSettingAlertView *alertView = [[TNMarkupPriceSettingAlertView alloc] initAlertViewWithConfig:config];
    @HDWeakify(self);
    alertView.setPricePolicyCompleteCallBack = ^{
        @HDStrongify(self);
        [self addOrCancelProductSales:isAdd baseInfoModel:cellModel];
    };
    [alertView show];
}
- (TNProductNavTitleModel *)createTitleModel:(NSString *)title section:(NSInteger)section sectionHeader:(BOOL)isHaveSectionHeader {
    TNProductNavTitleModel *pTitleModel = TNProductNavTitleModel.new;
    pTitleModel.title = title;
    pTitleModel.section = section;
    pTitleModel.isSectionHeader = isHaveSectionHeader;
    return pTitleModel;
}

#pragma mark -
/** @lazy productDTO */
- (TNProductDTO *)productDTO {
    if (!_productDTO) {
        _productDTO = [[TNProductDTO alloc] init];
    }
    return _productDTO;
}
/** @lazy reviewDTO */
- (TNReviewDTO *)reviewDTO {
    if (!_reviewDTO) {
        _reviewDTO = [[TNReviewDTO alloc] init];
        _reviewDTO.showAlertErrorMsgExceptSpecCode = NO;
    }
    return _reviewDTO;
}
/** @lazy shoppingCartDTO */
- (TNShoppingCarDTO *)shoppingCartDTO {
    if (!_shoppingCartDTO) {
        _shoppingCartDTO = [[TNShoppingCarDTO alloc] init];
    }
    return _shoppingCartDTO;
}
/** @lazy productIntroSection */
- (HDTableViewSectionModel *)bannerSection {
    if (!_bannerSection) {
        _bannerSection = [[HDTableViewSectionModel alloc] init];
    }
    return _bannerSection;
}
/** @lazy productIntroSection */
- (HDTableViewSectionModel *)productIntroSection {
    if (!_productIntroSection) {
        _productIntroSection = [[HDTableViewSectionModel alloc] init];
    }
    return _productIntroSection;
}
/** @lazy productExpressSection */
- (HDTableViewSectionModel *)productExpressSection {
    if (!_productExpressSection) {
        _productExpressSection = [[HDTableViewSectionModel alloc] init];
    }
    return _productExpressSection;
}
/** @lazy productServiceSection */
- (HDTableViewSectionModel *)productServiceSection {
    if (!_productServiceSection) {
        _productServiceSection = [[HDTableViewSectionModel alloc] init];
    }
    return _productServiceSection;
}
/** @lazy productDetailSection */
- (HDTableViewSectionModel *)productInfoSection {
    if (!_productInfoSection) {
        _productInfoSection = [[HDTableViewSectionModel alloc] init];
    }
    return _productInfoSection;
}
/** @lazy produtViewSection */
- (HDTableViewSectionModel *)productReviewSection {
    if (!_productReviewSection) {
        _productReviewSection = [[HDTableViewSectionModel alloc] init];
    }
    return _productReviewSection;
}

- (HDTableViewSectionModel *)publicImgSection {
    if (!_publicImgSection) {
        _publicImgSection = [[HDTableViewSectionModel alloc] init];
    }
    return _publicImgSection;
}
/** @lazy storeInfoSection */
- (HDTableViewSectionModel *)storeInfoSection {
    if (!_storeInfoSection) {
        _storeInfoSection = [[HDTableViewSectionModel alloc] init];
    }
    return _storeInfoSection;
}

- (HDTableViewSectionModel *)activitySection {
    if (!_activitySection) {
        _activitySection = [[HDTableViewSectionModel alloc] init];
    }
    return _activitySection;
}
- (HDTableViewSectionModel *)recommenSection {
    if (!_recommenSection) {
        _recommenSection = [[HDTableViewSectionModel alloc] init];
        HDTableHeaderFootViewModel *headModel = HDTableHeaderFootViewModel.new;
        headModel.title = TNLocalizedString(@"66SQCse1", @"新品推荐");
        _recommenSection.commonHeaderModel = @"recommend";
        _recommenSection.headerModel = headModel;
    }
    return _recommenSection;
}
- (HDTableViewSectionModel *)telegramSection {
    if (!_telegramSection) {
        _telegramSection = [[HDTableViewSectionModel alloc] init];
    }
    return _telegramSection;
}
- (NSMutableArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [NSMutableArray array];
    }
    return _titleArr;
}
/** @lazy microShopDTO */
- (TNMicroShopDTO *)microShopDTO {
    if (!_microShopDTO) {
        _microShopDTO = [[TNMicroShopDTO alloc] init];
    }
    return _microShopDTO;
}
- (TNProductDetailViewType)detailViewStyle {
    if ([TNGlobalData shared].seller.isSeller) {
        return TNProductDetailViewTypeSupplyAndMarketing;
    } else if (HDIsStringNotEmpty(self.sp) && self.isFromProductCenter == NO) {
        return TNProductDetailViewTypeMicroShop;
    } else {
        return TNProductDetailViewTypeNomal;
    }
}
@end
