//
//  PNCustomerInfoModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/3/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNCustomerInfoModel : PNModel
/// 名字（英语）-用户英语名
@property (nonatomic, strong) NSString *nameEn;
/// 用户代码
@property (nonatomic, strong) NSString *code;
/// 用户身份编号
@property (nonatomic, strong) NSString *idStr;
/// 名字-用户名
@property (nonatomic, strong) NSString *name;
@end

NS_ASSUME_NONNULL_END
