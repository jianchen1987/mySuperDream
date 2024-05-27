//
//  GNColumnModel.h
//  SuperApp
//
//  Created by wmz on 2022/5/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNEnum.h"
#import "GNMessageCode.h"
#import "GNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNColumnModel : GNModel
/// name
@property (nonatomic, copy) NSString *columnName;
///排序
@property (nonatomic, assign) int sort;
/// code
@property (nonatomic, copy) NSString *columnCode;
///栏目类型
@property (nonatomic, strong) GNMessageCode *columnType;

@end

NS_ASSUME_NONNULL_END
