//
//  TNOrderListCategoryConfig.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/4.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNOrderListCategoryConfig : TNModel
///
@property (nonatomic, copy) NSString *title;
///
@property (nonatomic, copy) TNOrderState state;
///
@property (nonatomic, copy) NSNumber *orderNum;

+ (instancetype)configWithTitle:(NSString *)title state:(TNOrderState)state num:(NSNumber *)num;
@end

NS_ASSUME_NONNULL_END
