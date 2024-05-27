//
//  PNFilterView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/4/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSFilterBaseView.h"
#import "PNMSFilterModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 点击确定回调
typedef void (^ConfirmBlock)(PNMSFilterModel *model);


@interface PNMSFilterView : PNMSFilterBaseView

@property (nonatomic, copy) ConfirmBlock confirmBlock;

- (void)showInSuperView:(UIView *)superview;

@end

NS_ASSUME_NONNULL_END
