//
//  WMOneClickResultModel.h
//  SuperApp
//
//  Created by wmz on 2022/7/25.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN
@class WMOneClickItemResultModel;


@interface WMOneClickResultModel : WMRspModel
///结果
@property (nonatomic, strong) WMGiveCouponResult resultCode;
///错误代码
@property (nonatomic, strong) WMGiveCouponError errorCode;
///券具体结果
@property (nonatomic, copy) NSArray<WMOneClickItemResultModel *> *couponResult;
@end


@interface WMOneClickItemResultModel : WMRspModel
///错误代码
@property (nonatomic, strong) WMGiveCouponError errorCode;
///是否成功
@property (nonatomic, assign) BOOL isSuccess;
///券No
@property (nonatomic, copy) NSString *couponNo;

@end

NS_ASSUME_NONNULL_END
