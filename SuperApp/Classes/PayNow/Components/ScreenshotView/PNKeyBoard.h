//
//  PNKeyBoard.h
//  SuperApp
//
//  Created by xixi_wen on 2022/7/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "HDKeyBoard.h"
#import "PNScreenshotView.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNKeyBoard : PNScreenshotView

@property (nonatomic, strong) HDKeyBoard *keyBoard;

- (instancetype)initKeyboardWithType:(HDKeyBoardType)type theme:(HDKeyBoardTheme *_Nullable)theme isRandom:(BOOL)isRandom;
@end

NS_ASSUME_NONNULL_END
