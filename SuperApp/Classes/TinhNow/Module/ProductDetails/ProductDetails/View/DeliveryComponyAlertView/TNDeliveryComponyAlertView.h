//
//  DeliveryComponyAlertView.h
//  SuperApp
//
//  Created by 张杰 on 2023/7/18.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>
#import "TNDeliveryComponyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TNDeliveryComponyAlertView : HDActionAlertView
- (instancetype)initWithTitle:(NSString *)title list:(NSArray<TNDeliveryComponyModel *> *)deliveryList showTitle:(BOOL)showTitle;
@end

NS_ASSUME_NONNULL_END
