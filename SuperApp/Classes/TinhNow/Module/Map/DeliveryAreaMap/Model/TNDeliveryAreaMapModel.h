//
//  TNDeliveryAreaMapModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/9/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN


@interface TNCoordinateModel : TNModel
/// 纬度
@property (nonatomic, copy) NSNumber *latitude;
/// 经度
@property (nonatomic, copy) NSNumber *longitude;
@end


@interface TNDeliveryAreaStoreInfoModel : TNModel
/// 店铺id
@property (nonatomic, copy) NSString *storeNo;
/// 店铺绑定的专题id
@property (nonatomic, copy) NSString *specialId;
/// 区域内店铺名称
@property (nonatomic, copy) NSString *storeName;
/// 销售区域: 0全国 1为指定区域 2指定范围
@property (nonatomic, assign) TNRegionType regionType;
/// 所在店铺纬度  店铺销售区域为指定范围的时候  可用
@property (nonatomic, copy) NSNumber *latitude;
/// 所在店铺经度
@property (nonatomic, copy) NSNumber *longitude;
/// 指定范围公里数
@property (nonatomic, copy) NSNumber *areaSize;
/// 指定区域  用的 区域经纬度集合
@property (strong, nonatomic) NSArray<TNCoordinateModel *> *storeLatLonDTOList;
/// 是否可配送
@property (nonatomic, assign) BOOL deliveryValid;
/// 提示文本
@property (nonatomic, copy) NSString *addressTipsInfo;
/// 仓库销售区域颜色
@property (nonatomic, copy) NSString *color;

///绑定属性 是否选中了
@property (nonatomic, assign) BOOL isSelected;

@end


@interface TNDeliveryAreaMapModel : TNModel
/// 多店铺数据
@property (strong, nonatomic) NSArray<TNDeliveryAreaStoreInfoModel *> *storeInfoDTOList;
@end

NS_ASSUME_NONNULL_END
