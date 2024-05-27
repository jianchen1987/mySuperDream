//
//  TNEnum.m
//  SuperApp
//
//  Created by seeu on 2020/6/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNEnum.h"

TNGoodsType const TNGoodsTypeGeneral = @"GENERAL";   ///< 普通商品
TNGoodsType const TNGoodsTypeExchange = @"EXCHANGE"; ///< 兑换商品
TNGoodsType const TNGoodsTypeGift = @"GIFI";         ///< 赠品
TNGoodsType const TNGoodsTypeActivity = @"ACTIVITY"; ///< 促销活动商品
TNGoodsType const TNGoodsTypeOverseas = @"OVERSEAS"; ///< 海外购商品

TNOrderType const TNOrderTypeGeneral = @"GENERAL";          ///< 普通订单
TNOrderType const TNOrderTypeExchange = @"EXCHANGE";        ///< 兑换订单
TNOrderType const TNOrderTypeBargain = @"BARGAIN";          ///< 砍价订单
TNOrderType const TNOrderTypeGroupon = @"GROUPON";          ///< 拼团订单
TNOrderType const TNOrderTypePanicBuying = @"PANIC_BUYING"; ///< 抢购订单
TNOrderType const TNOrderTypeSeckill = @"SEC_KILL";         ///<秒杀订单
TNOrderType const TNOrderTypeOverseas = @"OVERSEAS";        ///< 海外购订单

TNStoreType const TNStoreTypeGeneral = @"GENERAL";                    ///< 普通店铺
TNStoreType const TNStoreTypeSelf = @"SELF";                          ///< 自营店铺
TNStoreType const TNStoreTypePlatfromSelf = @"PLATFORM_SELF";         ///<   平台直营店铺  这个后端废弃 没用了
TNStoreType const TNStoreTypeOverseasShopping = @"OVERSEAS_SHOPPING"; ///< 海外购店铺

///店铺标签
TNStoreTag const TNStoreTagGlobal = @"Global";

TNGoodsListSortType const TNGoodsListSortTypeTopDesc = @"TOP_DESC";     ///< 置顶降序
TNGoodsListSortType const TNGoodsListSortTypePriceAsc = @"PRICE_ASC";   ///< 价格升序
TNGoodsListSortType const TNGoodsListSortTypePriceDesc = @"PRICE_DESC"; ///< 价格降序
TNGoodsListSortType const TNGoodsListSortTypeSalesDesc = @"SALES_DESC"; ///< 销量降序
TNGoodsListSortType const TNGoodsListSortTypeScoreDesc = @"SCORE_DESC"; ///< 评分降序
TNGoodsListSortType const TNGoodsListSortTypeDateDesc = @"DATE_DESC";   ///< 日期降序
TNGoodsListSortType const TNGoodsListSortTypeDefault = @"";             ///<默认  可传空

TNStoreState const TNStoreStateOpen = @"OPEN";    ///< 营业中
TNStoreState const TNStoreStateRest = @"REST";    ///< 休息中
TNStoreState const TNStoreStateClose = @"CLOSED"; ///< 已停业

TNPaymentMethod const TNPaymentMethodOnLine = @"ONLINE";             ///线上支付
TNPaymentMethod const TNPaymentMethodOffLine = @"OFFLINE";           /// 线下支付
TNPaymentMethod const TNPaymentMethodTransfer = @"OFFLINE_TRANSFER"; /// 转账付款

TNOrderState const TNOrderStatePendingPayment = @"PENDING_PAYMENT";   ///< 等待付款
TNOrderState const TNOrderStatePendingReview = @"PENDING_REVIEW";     ///<  等待审核
TNOrderState const TNOrderStatePendingShipment = @"PENDING_SHIPMENT"; ///<  等待发货
TNOrderState const TNOrderStateShipped = @"SHIPPED";                  ///<  已发货
TNOrderState const TNOrderStateReceived = @"RECEIVED";                ///<  已收货
TNOrderState const TNOrderStateCompleted = @"COMPLETED";              ///<  已完成
TNOrderState const TNOrderStateFailed = @"FAILED";                    ///<  已失败
TNOrderState const TNOrderStateCanceled = @"CANCELED";                ///<  已取消
TNOrderState const TNOrderStateDenied = @"DENIED";                    ///<  已拒绝

TNMarketingType const TNMarketingTypeFeeReduce = @"DELIVERY_FEE_REDUCE";       ///< 减配送费
TNMarketingType const TNMarketingTypeFullReduction = @"LADDER_FULL_REDUCTION"; ///< 满减活动
TNMarketingType const TNMarketingTypeDiscount = @"DISCOUNT";                   ///< 折扣活动

TNCategoryType const TNCategoryTypeGoods = @"productCategory"; ///<分类商品
TNCategoryType const TNCategoryTypeBrand = @"brand";           ///< 分类品牌

TNProductCategoryScene const TNProductCategorySceneAll = @"ALL";                    ///<全部一级分类
TNProductCategoryScene const TNProductCategorySceneBargainList = @"BARGAIN_LIST";   ///< 砍价活动列表一级分类
TNProductCategoryScene const TNProductCategorySceneGroupList = @"GROUPON_LIST";     ///< 拼团活动列表一级分类
TNProductCategoryScene const TNProductCategorySceneGoodsSpecial = @"GOODS_SPECIAL"; ///< 商品专题一级分类

TNDeliveryCorpCode const TNDeliveryCorpCodeCE = @"CambodianExpress"; /// CE物流代码
TNDeliveryCorpCode const TNDeliveryCorpCodeYumnow = @"yumnow";       ///外卖骑手

TNPaymentWayCode const TNPaymentWayCodeBank = @"BANK";                 ///<银行卡
TNPaymentWayCode const TNPaymentWayCodeThird = @"THIRD_PARTY_PAYMENT"; ///< 第三方支付
TNPaymentWayCode const TNPaymentWayCodeCash = @"CASH";                 ///< 现金

TNTrackEventPrefixName const TNTrackEventPrefixNameOverseas = @"【电商-海外购】";    ///<【电商-海外购】
TNTrackEventPrefixName const TNTrackEventPrefixNameFastConsume = @"【电商-快消品】"; ///< 【电商-快消品】
TNTrackEventPrefixName const TNTrackEventPrefixNameOther = @"【电商-其它】";         ///< 【电商-其它】

TNSalesType const TNSalesTypeSingle = @"single"; /// 单买
TNSalesType const TNSalesTypeBatch = @"batch";   ///批量
