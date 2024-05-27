//
//  TNProductBatchToggleCellModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/8/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNProductBatchToggleCellModel : TNModel
/// 单买还是批量
@property (nonatomic, copy) TNSalesType salesType;
/// 隐藏疑问按钮
@property (nonatomic, assign) BOOL hiddenQuestionBtn;
/// 单买 批量疑问点击回调
@property (nonatomic, copy) void (^buyQustionCallBack)(TNSalesType salesType);
/// 单买  批量切换点击
@property (nonatomic, copy) void (^toggleCallBack)(TNSalesType salesType);
@end

NS_ASSUME_NONNULL_END
