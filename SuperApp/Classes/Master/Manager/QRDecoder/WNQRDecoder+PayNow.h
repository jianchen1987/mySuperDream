//
//  WNQRDecoder+PayNow.h
//  SuperApp
//
//  Created by seeu on 2022/5/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WNQRDecoder.h"

NS_ASSUME_NONNULL_BEGIN


@interface WNQRDecoder (PayNow)

/// 是否可以解码
/// @param code 二维码字符串
- (BOOL)canDecodePayNowQRCode:(NSString *)code;

/// 解码
/// @param code 二维码字符串
- (BOOL)decodePayNowQRCode:(NSString *)code;

@end

NS_ASSUME_NONNULL_END
