//
//  PNAgentInfoModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/4/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNAgentInfoModel : PNModel
/// 商户编号
@property (nonatomic, strong) NSString *merchantNo;
/// 商户名称
@property (nonatomic, strong) NSString *merchantName;
/// 商户Logo
@property (nonatomic, strong) NSString *merchantLogo;
/// 产品列表（即可提供的服务）
@property (nonatomic, strong) NSArray *products;
/// 经度
@property (nonatomic, strong) NSString *longitude;
/// 纬度
@property (nonatomic, strong) NSString *latitude;
/// 商户详细地址
@property (nonatomic, strong) NSString *address;
/// 联系电话
@property (nonatomic, strong) NSString *contactPhone;
@end

NS_ASSUME_NONNULL_END
