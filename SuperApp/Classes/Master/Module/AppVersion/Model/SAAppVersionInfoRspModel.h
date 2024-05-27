//
//  SAAppVersionInfoRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/10.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAAppVersionInfoRspModel : SARspModel
@property (nonatomic, copy) NSString *adaptiveVersion; ///< 适配版本
@property (nonatomic, copy) NSString *packageLink;     ///< 包链接
@property (nonatomic, copy) NSString *publicVersion;   ///< 新的版本
@property (nonatomic, copy) NSString *updateModel;     ///< 更新方式，更新方式，common:普通更新,coerce:强制更新
@property (nonatomic, copy) NSString *versionId;       ///< app版本信息表id
@property (nonatomic, copy) NSString *versionInfo;     ///< 更新内容
@end

NS_ASSUME_NONNULL_END
