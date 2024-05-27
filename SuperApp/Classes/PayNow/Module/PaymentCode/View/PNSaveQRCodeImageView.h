//
//  PNSaveQRCodeImageView.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNView.h"

@class PNQRCodeModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNSaveQRCodeImageView : PNView

@property (nonatomic, strong) PNQRCodeModel *model;

@end

NS_ASSUME_NONNULL_END
