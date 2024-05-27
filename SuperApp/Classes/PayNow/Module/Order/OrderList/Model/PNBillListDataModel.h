//
//  PayHDBillListDataModel.h
//  SuperApp
//
//  Created by Quin on 2021/11/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "PNOrderListModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface PNBillListDataModel : PNModel
@property (nonatomic, copy) NSString *sortFactor;    ///< 排序因子
@property (nonatomic, copy) NSString *sectionName;   ///< 分类名
@property (nonatomic, strong) NSMutableArray *datas; ///< 数据
@end

NS_ASSUME_NONNULL_END
