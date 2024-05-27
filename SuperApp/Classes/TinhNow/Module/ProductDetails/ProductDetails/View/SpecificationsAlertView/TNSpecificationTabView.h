//
//  TNSpecificationTabView.h
//  SuperApp
//
//  Created by 张杰 on 2022/7/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNSpecificationTabView : TNView
/// 单买  批量切换点击
@property (nonatomic, copy) void (^toggleCallBack)(TNSalesType salesType);
@end

NS_ASSUME_NONNULL_END
