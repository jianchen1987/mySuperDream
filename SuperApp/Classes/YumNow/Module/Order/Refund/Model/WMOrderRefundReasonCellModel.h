//
//  WMOrderRefundReasonCellModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderRefundReasonCellModel : WMModel
/// 内容
@property (nonatomic, copy) NSString *text;
/// 是否要顶部线
@property (nonatomic, assign) BOOL needTopLine;
/// 是否要底部线
@property (nonatomic, assign) BOOL needBottomLine;
@end

NS_ASSUME_NONNULL_END
