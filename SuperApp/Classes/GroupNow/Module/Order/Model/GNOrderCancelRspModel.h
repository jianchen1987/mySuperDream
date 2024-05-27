//
//  GNOrderCancelRspModel.h
//  SuperApp
//
//  Created by wmz on 2022/7/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNModel.h"
#import "SAInternationalizationModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNOrderCancelRspModel : GNModel
/// type
@property (nonatomic, copy) NSString *type;
/// name
@property (nonatomic, strong) SAInternationalizationModel *name;
/// 选中
@property (nonatomic, assign, getter=isSelect) BOOL selected;
@end

NS_ASSUME_NONNULL_END
