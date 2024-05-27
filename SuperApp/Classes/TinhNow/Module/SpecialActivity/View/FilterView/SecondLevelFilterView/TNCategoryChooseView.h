//
//  TNCategoryChooseView.h
//  SuperApp
//
//  Created by 张杰 on 2021/5/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN
@class TNCategoryModel;


@interface TNCategoryChooseView : TNView
/// 数据源
@property (strong, nonatomic) NSArray<TNCategoryModel *> *categoryArr;
/// 验证是否可以选中确定按钮
@property (nonatomic, copy) void (^checkCanConfirm)(BOOL canConfirm);
//重置
- (void)reset;
@end

NS_ASSUME_NONNULL_END
