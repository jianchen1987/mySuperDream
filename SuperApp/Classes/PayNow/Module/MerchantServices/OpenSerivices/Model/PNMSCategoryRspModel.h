//
//  PNMSCategoryRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSCategoryModel : PNModel
/// 编码
@property (nonatomic, copy) NSString *code;
/// 名称
@property (nonatomic, copy) NSString *name;
/// 等级
@property (nonatomic, copy) NSString *level;
@property (nonatomic, strong) NSArray<PNMSCategoryModel *> *sub;
@end


@interface PNMSCategoryRspModel : PNModel
@property (nonatomic, strong) NSArray<PNMSCategoryModel *> *list;
@end

NS_ASSUME_NONNULL_END
