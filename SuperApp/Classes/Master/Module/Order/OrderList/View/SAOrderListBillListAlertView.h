//
//  SAOrderListBillListAlertView.h
//  SuperApp
//
//  Created by Tia on 2023/2/20.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAOrderBillListModel.h"
#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface SAOrderListBillListAlertView : HDAlertView

@property (nonatomic, strong) SAOrderBillListModel *model;

@property (nonatomic, copy) void (^didSelectedBlock)(BOOL isRefund, SAOrderBillListItemModel *model);

@end

NS_ASSUME_NONNULL_END
