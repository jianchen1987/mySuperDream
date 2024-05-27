//
//  SAMerchantInfoModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAMerchantInfoModel : SAModel
/// 商户 logo
@property (nonatomic, copy) NSString *merchantLogo;
/// 商户号
@property (nonatomic, copy) NSString *merchantNo;
/// 商户名
@property (nonatomic, copy) NSString *merchantName;
@end

NS_ASSUME_NONNULL_END
