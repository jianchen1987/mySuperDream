//
//  TNDeliveryComponyModel.h
//  SuperApp
//
//  Created by 张杰 on 2023/7/18.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TNDeliveryComponyModel : TNModel
/// 物流公司名称
@property (nonatomic, copy) NSString *deliveryCorp;
/// 物流公司代码
@property (nonatomic, copy) NSString *deliveryCorpCode;
/// 运费规则说明 (html)
@property (nonatomic, copy) NSString *freightRulesDesc;
/// 物流公司logo访问地址
@property (nonatomic, copy) NSString *logo;
/// 是否推荐的物流公司 true 是, false: 不是
@property (nonatomic, assign) BOOL recommend;

/// 是否选中
@property (nonatomic, assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
