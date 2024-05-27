//
//  HDOnlinePaymentToolsModel.h
//  SuperApp
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCheckStandEnum.h"
#import "SAInternationalizationModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 支付方式模型
 */
@interface HDOnlinePaymentToolsModel : SAModel
/// code
@property (nonatomic, copy) HDCheckStandPaymentTools method;
/// 信息
@property (nonatomic, copy) NSString *message;

///< 支付工具编号
@property (nonatomic, copy) NSString *payToolNo;
///< 支付工具名称
@property (nonatomic, copy) NSString *payToolName;
///< 支付工具渠道编码
@property (nonatomic, copy) HDCheckStandPaymentTools vipayCode;

@property (nonatomic, strong) NSArray<NSString *> *marketing; ///< 营销信息
/// 支付工具名三语
@property (nonatomic, strong) SAInternationalizationModel *payToolNameDTO;
/// 副标题三语
@property (nonatomic, strong) SAInternationalizationModel *subTitleDTO;
/// 副图标路径
@property (nonatomic, copy) NSString *subIcon;
/// 图标路径
@property (nonatomic, copy) NSString *icon;
/// 是否可用，不可用置灰
@property (nonatomic, assign) BOOL isShow;

+ (instancetype)modelWithToolsCode:(HDCheckStandPaymentTools)tool;

@end

NS_ASSUME_NONNULL_END
