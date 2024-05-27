//
//  TNShareWebpageObject.h
//  SuperApp
//
//  Created by 张杰 on 2022/4/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAShareWebpageObject.h"
/// 电商分享  业务类型
typedef NS_ENUM(NSInteger, TNShareBusinessType) {
    /// 默认的通用分享
    TNShareBusinessTypeCommon = 0,
    /// 商品详情分享
    TNShareBusinessTypeProductDetail = 1,
};

NS_ASSUME_NONNULL_BEGIN


@interface TNShareWebpageObject : SAShareWebpageObject
/// 业务类型
@property (nonatomic, assign) TNShareBusinessType businessType;

/// 绑定模型   商品详情生成的图片  需要展示额外的数据
@property (strong, nonatomic) id associationModel;
@end

NS_ASSUME_NONNULL_END
