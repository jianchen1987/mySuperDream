//
//  PNReceiveCodeView.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNView.h"

@class PNQRCodeModel;

NS_ASSUME_NONNULL_BEGIN

typedef void (^SetAmountBlock)(void);
typedef void (^SaveQRCodeBlock)(void);
typedef void (^DownRCodeBlock)(void);


@interface PNReceiveCodeView : PNView
/// 截图view
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) PNQRCodeModel *model;

@property (nonatomic, copy) SetAmountBlock setAmountBlock;
@property (nonatomic, copy) SaveQRCodeBlock saveQRCodeBlock;
@property (nonatomic, copy) DownRCodeBlock downQRCodeBlock;
@end

NS_ASSUME_NONNULL_END
