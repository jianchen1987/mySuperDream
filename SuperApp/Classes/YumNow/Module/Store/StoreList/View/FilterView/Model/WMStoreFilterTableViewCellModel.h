//
//  WMStoreFilterTableViewCellModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreFilterTableViewCellBaseModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreFilterTableViewCellModel : WMStoreFilterTableViewCellBaseModel
@property (nonatomic, copy) NSArray<WMStoreFilterTableViewCellBaseModel *> *subArrList; ///< 子数据
@end

NS_ASSUME_NONNULL_END
