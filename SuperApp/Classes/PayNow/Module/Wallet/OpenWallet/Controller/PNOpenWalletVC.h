//
//  OpenWalletVC.h
//  SuperApp
//
//  Created by Quin on 2021/11/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNViewController.h"

typedef enum : NSUInteger {
    PNWalletViewType_Open = 0,       ///< 钱包开通
    PNWalletViewType_Activation = 1, ///< 钱包激活
} PNWalletViewType;

NS_ASSUME_NONNULL_BEGIN


@interface PNOpenWalletVC : PNViewController

@end

NS_ASSUME_NONNULL_END
