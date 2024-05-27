//
//  PNOpenPaymentCodeView.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^SecretFlagBlock)(BOOL selectFlag);


@interface PNOpenPaymentCodeView : PNView

@property (nonatomic, copy) SecretFlagBlock secretFlagBlock;
@end

NS_ASSUME_NONNULL_END
