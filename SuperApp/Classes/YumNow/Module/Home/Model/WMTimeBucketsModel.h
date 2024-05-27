//
//  WMTimeBucketsModel.h
//  SuperApp
//
//  Created by seeu on 2020/8/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMTimeBucketsModel : WMModel
/// 门店照片
@property (nonatomic, copy) NSString *photo;
/// 门店logo
@property (nonatomic, copy) NSString *logo;
/// 门店名称
@property (nonatomic, strong) SAInternationalizationModel *storeName;
/// 门店号
@property (nonatomic, copy) NSString *storeNo;
@end

NS_ASSUME_NONNULL_END
