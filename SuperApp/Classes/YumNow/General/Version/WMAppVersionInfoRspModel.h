//
//  WMAppVersionInfoRspModel.h
//  SuperApp
//
//  Created by wmz on 2022/10/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAAppVersionInfoRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMAppVersionInfoRspModel : SAAppVersionInfoRspModel
///更新方式 20:强制更新;30:普通更新;40:内测更新
@property (nonatomic, assign) NSInteger updateMethod;
/// app版本信息表id
@property (nonatomic, assign) NSInteger id;
///版本更新内容
@property (nonatomic, copy) NSString *descriptionStr;

@end

NS_ASSUME_NONNULL_END
