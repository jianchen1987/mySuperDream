//
//  WMToStoreContactView.h
//  SuperApp
//
//  Created by Tia on 2023/8/31.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>
#import "SAShoppingAddressModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMToStoreContactView : HDActionAlertView

- (instancetype)initWithDataSource:(NSArray *)dataSource selectData:(SAShoppingAddressModel *)selectData completion:(void (^)(SAShoppingAddressModel *model))completion;

@end

NS_ASSUME_NONNULL_END
