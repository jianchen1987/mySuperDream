//
//  PNMSQRCodeView.h
//  SuperApp
//
//  Created by xixi on 2022/12/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"

@class PNMSReceiveCodeRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNMSQRCodeView : PNView
@property (nonatomic, strong) PNMSReceiveCodeRspModel *model;

@end

NS_ASSUME_NONNULL_END
