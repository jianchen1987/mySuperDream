//
//  PNSceneQrCodeInfoModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNSceneQrCodeInfoModel : PNModel
/// 商户NO
@property (nonatomic, copy) NSString *tenantId;
/// logo
@property (nonatomic, copy) NSString *logoUrl;
/// 商户名称
@property (nonatomic, copy) NSString *merName;
/// 门店编号
@property (nonatomic, copy) NSString *storeNo;
/// 门店名称
@property (nonatomic, copy) NSString *storeName;
/// 门店操作员名称
@property (nonatomic, copy) NSString *operaName;
/// 门店操作员编号
@property (nonatomic, copy) NSString *operaLoginName;
/// 10 商户码  11 门店码  12 店员码
@property (nonatomic, assign) NSInteger sceneType;
@end

NS_ASSUME_NONNULL_END
