//
//  TNBargainRuleModel.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"
@class TNAdaptImageModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainRuleModel : TNModel
/// 规则名称
@property (nonatomic, copy) NSString *ruleName;
/// 规则详情
@property (nonatomic, copy) NSString *ruleContent;
/// 规则引导图片
@property (nonatomic, copy) NSString *guidePics;
/// 规则图片数组   后台返回的是个json字符串 转一下模型数组
@property (strong, nonatomic) NSArray<TNAdaptImageModel *> *rulePics;
@end

NS_ASSUME_NONNULL_END
