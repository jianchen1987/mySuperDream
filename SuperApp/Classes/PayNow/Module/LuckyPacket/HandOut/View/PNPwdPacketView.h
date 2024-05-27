//
//  PNPwdPacketView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^HandOutBtnClickBlock)(void);


@interface PNPwdPacketView : PNView

@property (nonatomic, copy) HandOutBtnClickBlock handOutBtnClickBlock;

@end

NS_ASSUME_NONNULL_END
