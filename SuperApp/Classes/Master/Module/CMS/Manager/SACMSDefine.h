//
//  SACMSDefine.h
//  SuperApp
//
//  Created by seeu on 2021/6/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#ifndef SACMSDefine_h
#define SACMSDefine_h

#import <Foundation/Foundation.h>

///页面枚举
typedef NSString *CMSPageIdentify NS_STRING_ENUM;
FOUNDATION_EXPORT CMSPageIdentify const CMSPageIdentifyWownowHome;                 ///< wownow首页
FOUNDATION_EXPORT CMSPageIdentify const CMSPageIdentifyYumNowHome;                 ///< 外卖首页
FOUNDATION_EXPORT CMSPageIdentify const CMSPageIdentifyTinhNowHome;                ///< 电商首页
FOUNDATION_EXPORT CMSPageIdentify const CMSPageIdentifyMine;                       ///< 我的
FOUNDATION_EXPORT CMSPageIdentify const CMSPageIdentifyOrderListAll;               ///< 订单列表全部
FOUNDATION_EXPORT CMSPageIdentify const CMSPageIdentifyOrderListWaitingPay;        ///<订单列表待支付
FOUNDATION_EXPORT CMSPageIdentify const CMSPageIdentifyOrderListProcessing;        ///<订单列表处理中
FOUNDATION_EXPORT CMSPageIdentify const CMSPageIdentifyOrderListWaitingEvaluation; ///<订单列表待评价
FOUNDATION_EXPORT CMSPageIdentify const CMSPageIdentifyOrderListWatingRefund;      ///<订单列表退款/售后

///卡片枚举
typedef NSString *CMSCardIdentify NS_STRING_ENUM;
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentifyKingkongAreaCard;                    ///< 金刚区
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentifySingleImageScrolledCard;             ///< 单张轮播
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentifyThreeImage1X1ScrolledCard;           ///< 1:1 三图推荐卡片
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentifyThreeImage3X2ScrolledCard;           ///< 3:2三图推荐卡片
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentifyThreeImage7X3ScrolledCard;           ///< 7:3三图推荐卡片
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentifyThreeImage7x3ScrolledDataSourceCard; ///< 带数据源的7:3三图推荐卡片
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentifyToolsAreaCard;                       ///< 工具栏卡片
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentifyParentChildKingkongAreaCard;         ///< 父子金刚区卡片
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentifyTwoImagePagedCard;                   ///< 二格翻页卡片
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentifyFourImageScrolledCard;               ///< 四宫格翻页卡片
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentify150x375SingleImageScrolledCard;      ///< 单张轮播150x375
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentify80x375SingleImageScrolledCard;       ///< 单张轮播80x375
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentifySixImageCard;                        ///< 六宫格卡片
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentifyMuItipleIconTextMarqueeCard;         ///< 图标文本跑马灯
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentifyTitleCard;                           ///< 标题卡片
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentifyCubeScrolledCard;                    ///< 滑动方块广告
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentifyListGroupCard;                       ///< 分组列表
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentifyImageListDataSourceCard;             ///< 图片列表
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentifyToolsAreaHorizontalScrolledCard;     ///< 水平滑动工具栏
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentifyMainEntranceCard;                    ///< 业务主入口
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentifySingleImageAutoScrollCard;
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentifyImageTextScrolledDataSourceCard; ///< 带数据源的图文滑动组件
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentifyYumNowKingKongAreaDataSourceCard; ///<外卖金刚区卡片
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentifyYumNowBannerDataSourceCard; ///<外卖Banner
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentifyYumNowBrandPromoDataSourceCard; ///<外卖品牌主体
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentifyYumNowBannerAutoScrollDataSourceCard; ///<外卖轮播
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentifyYumNowGoodsRecommendDataSourceCard; ///<外卖分时推荐
FOUNDATION_EXPORT CMSCardIdentify const CMSCardIdentifyYumNowStoreRecommendDataSourceCard; ///<外卖门店推荐
///<
typedef NSString *CMSPluginIdentify NS_STRING_ENUM;
FOUNDATION_EXPORT CMSPluginIdentify const CMSPluginIdentifyFloatWindow;          ///< 浮动弹窗
FOUNDATION_EXPORT CMSPluginIdentify const CMSPluginIdentifyNavigationBar;        ///< 导航栏
FOUNDATION_EXPORT CMSPluginIdentify const CMSPluginIdentifyNewUserMarketingView; ///< 新用户营销插件

///标题样式
typedef NSString *CMSTitleViewStyle NS_STRING_ENUM;
FOUNDATION_EXPORT CMSTitleViewStyle const CMSTitleViewStyleValue1; ///< 标题在左，副标题在右
FOUNDATION_EXPORT CMSTitleViewStyle const CMSTitleViewStyleValue2; ///< 副标题跟随主标题

typedef NS_ENUM(NSUInteger, CMSAppCornerIconStyle) { CMSAppCornerIconStyle1 = 1, CMSAppCornerIconStyle2 = 2, CMSAppCornerIconStyle3 = 3 };

typedef NSString *CMSDataSource NS_STRING_ENUM;
FOUNDATION_EXPORT CMSDataSource const CMSDataSourceCurrentVersion;  ///< 当前版本
FOUNDATION_EXPORT CMSDataSource const CMSDataSourceCurrentLanguage; ///< 当前语言

#endif /* SACMSDefine_h */
