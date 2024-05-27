//
//  TNRefundSimpleOrderInfoModel.h
//  SuperApp
//
//  Created by xixi on 2021/1/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNRefundSimpleOrderInfoModel : TNModel
/// 商家手机号码
@property (nonatomic, strong) NSString *phone;
/// 金额
@property (nonatomic, strong) NSString *price;
/// 用户手机号码
@property (nonatomic, strong) NSString *userPhone;
/// 店铺No.
@property (nonatomic, strong) NSString *storeNo;

@end


NS_ASSUME_NONNULL_END
