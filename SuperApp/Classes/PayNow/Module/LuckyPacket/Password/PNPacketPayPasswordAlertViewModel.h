//
//  PNPacketPayPasswordAlertViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNPacketPayPasswordAlertViewModel : PNModel

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, strong) NSAttributedString *subTitleAtt;

/// 业务数据上需要中转的 数据 [输入结束后 会在delegate返回]
@property (nonatomic, strong) id businessObj;

@end

NS_ASSUME_NONNULL_END
