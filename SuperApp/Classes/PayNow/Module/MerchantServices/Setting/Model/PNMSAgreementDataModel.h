//
//  PNMSAgreementDataModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/8/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSAgreementDataModel : PNModel
/// 资源名称
@property (nonatomic, copy) NSString *resName;
/// 资源地址
@property (nonatomic, copy) NSString *resUrl;
@end

NS_ASSUME_NONNULL_END
