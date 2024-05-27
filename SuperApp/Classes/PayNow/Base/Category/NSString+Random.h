//
//  NSString+Random.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface NSString (Random)
/// 生产随机字符串 【数字 + 字母】
+ (NSString *)getRandomStringWithNum:(NSInteger)num;
@end

NS_ASSUME_NONNULL_END
