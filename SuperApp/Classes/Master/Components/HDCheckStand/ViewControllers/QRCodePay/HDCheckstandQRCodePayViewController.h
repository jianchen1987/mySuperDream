//
//  HDCheckstandQRCodePayViewController.h
//  SuperApp
//
//  Created by Tia on 2023/5/9.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAViewController.h"
#import "HDCheckStandOrderSubmitParamsRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface HDCheckstandQRCodePayViewController : SAViewController

@property (nonatomic, strong) HDCheckStandQRCodePayDetailRspModel *model;
/// 主动关闭回调
@property (nonatomic, copy) dispatch_block_t closeByUser;

@end

NS_ASSUME_NONNULL_END
