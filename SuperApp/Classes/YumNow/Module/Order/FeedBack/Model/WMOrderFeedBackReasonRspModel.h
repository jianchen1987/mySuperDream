//
//  WMOrderFeedBackReasonRspModel.h
//  SuperApp
//
//  Created by wmz on 2022/11/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "WMSelectRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderFeedBackReasonRspModel : WMSelectRspModel
/// no
@property (nonatomic, copy) NSString *no;
/// reason
@property (nonatomic, strong) SAInternationalizationModel *reason;
///图片必传
@property (nonatomic, assign) BOOL isPhoto;
///备注必填
@property (nonatomic, assign) BOOL isRemark;

@end

NS_ASSUME_NONNULL_END
