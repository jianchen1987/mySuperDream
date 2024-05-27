//
//  TNExpressChildControllerConfig.h
//  SuperApp
//
//  Created by 张杰 on 2021/4/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"
#import <UIKit/UIKit.h>
@class TNExpressDetailsModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNExpressChildControllerConfig : TNModel
/// 标题
@property (nonatomic, copy) NSString *title;
/// 模型数据
@property (strong, nonatomic) TNExpressDetailsModel *model;
+ (instancetype)configWithTitle:(NSString *)title model:(TNExpressDetailsModel *)model;
@end

NS_ASSUME_NONNULL_END
