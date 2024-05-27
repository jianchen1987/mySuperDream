//
//  GNFilterModel.h
//  SuperApp
//
//  Created by wmz on 2022/5/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNEnum.h"
#import "GNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNFilterModel : GNModel
///分类code
@property (nonatomic, copy) NSString *classificationCode;
///商圈No
@property (nonatomic, copy) NSString *commercialDistrictNo;
///排序规则
@property (nonatomic, strong) GNHomeSortType sortType;

@end

NS_ASSUME_NONNULL_END
