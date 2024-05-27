//
//  WMModifyAddressPopView.h
//  SuperApp
//
//  Created by wmz on 2022/10/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMModifyAddressPopModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMModifyAddressPopView : SAView <HDCustomViewActionViewProtocol>
/// MODEL
@property (nonatomic, strong) WMModifyAddressPopModel *model;
/// 提交
@property (nonatomic, copy) void (^clickedConfirmBlock)(void);

@end

NS_ASSUME_NONNULL_END
