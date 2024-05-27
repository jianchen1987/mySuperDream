//
//  TNDeliverInfoModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/4/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"
#import "SAMoneyModel.h"
@class TNAdaptImageModel;
@class TNDeliverFlowModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNDeliverVideoModel : TNModel
/// 封面图
@property (nonatomic, copy) NSString *cover;
/// 视频地址
@property (nonatomic, copy) NSString *coverUrl;
@end


@interface TNDeliverFreightModel : TNModel
/// 地点名字
@property (nonatomic, copy) NSString *name;
/// 地点全名
@property (nonatomic, copy) NSString *fullName;
/// 首重
@property (nonatomic, copy) NSString *firstWeight;
/// 续重
@property (nonatomic, copy) NSString *continueWeight;
/// 首重金额
@property (strong, nonatomic) SAMoneyModel *firstPriceMoney;
/// 续重金额
@property (strong, nonatomic) SAMoneyModel *continuePriceMoney;
@end


@interface TNDeliverAreaModel : TNModel
/// 配送金额
@property (strong, nonatomic) SAMoneyModel *freightPriceMoney;
/// 地区说明
@property (nonatomic, copy) NSString *areaDeclare;
/// 地区详细运费数据
@property (strong, nonatomic) NSArray<TNDeliverFreightModel *> *freightTemplate;
@end


@interface TNDeliverInfoModel : TNModel
/// 图片数组
@property (strong, nonatomic) NSArray<NSString *> *overseaImage;
/// 配送地区数据
@property (strong, nonatomic) NSArray<TNDeliverAreaModel *> *areaFreightDeclar;
/// 视频数据
@property (nonatomic, strong) TNDeliverVideoModel *overseaVideo;
/// 出发地
@property (nonatomic, copy) NSString *departTxt;
/// 国际物流
@property (nonatomic, copy) NSString *interShippingTxt;
/// 目的地
@property (nonatomic, copy) NSString *arriveTxt;
/// 模型化配送说明
@property (strong, nonatomic) TNDeliverFlowModel *flowModel;

/**
 自定义字段
 */
/// 图片转换为模型
@property (strong, nonatomic) NSArray<TNAdaptImageModel *> *deliverInfoImages;
/// 配送范围文本
@property (nonatomic, copy) NSString *contentText;

@end

NS_ASSUME_NONNULL_END
