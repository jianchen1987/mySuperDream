//
//  TNRedZoneActivityModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/9/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNRedZoneAdressForActivityModel : TNModel
/// 是否可配送
@property (nonatomic, assign) BOOL deliveryValid;
/// 专题id
@property (nonatomic, copy) NSString *specialId;
/// 地址id
@property (nonatomic, copy) NSString *addressNo;
/// 地址名称
@property (nonatomic, copy) NSString *address;
/// 纬度
@property (nonatomic, strong) NSNumber *latitude;
/// 经度
@property (nonatomic, strong) NSNumber *longitude;
/// 手机号
@property (nonatomic, copy) NSString *mobile;
/// 收货人姓名
@property (nonatomic, copy) NSString *consigneeName;
/// 性别
@property (nonatomic, assign) SAGender gender;
///
@property (nonatomic, assign) CGFloat cellHeight;
@end


@interface TNRedZoneRecommendActivityModel : TNModel
/// 店铺名称
@property (nonatomic, copy) NSString *storeNo;
/// 专题id
@property (nonatomic, copy) NSString *specialId;
/// 专题名称
@property (nonatomic, copy) NSString *specialName;
@end


@interface TNRedZoneActivityModel : TNModel
/// 是否可配送
@property (nonatomic, assign) BOOL deliveryValid;
/// 专题id
@property (nonatomic, copy) NSString *specialId;
/// 推荐展示的专题
@property (strong, nonatomic) NSArray<TNRedZoneRecommendActivityModel *> *storeSpecialDTOList;
/// 全部地址专题
@property (strong, nonatomic) NSArray<TNRedZoneAdressForActivityModel *> *addressSpecialDTOList;
@end

NS_ASSUME_NONNULL_END
