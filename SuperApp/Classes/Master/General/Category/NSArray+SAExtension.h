//
//  NSArray+SAExtension.h
//  SuperApp
//
//  Created by VanJay on 2020/6/1.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface NSArray (SAExtension)

/// 和另一个数组内容是否相同，不计较元素顺序
/// @param array 比较的数组
- (BOOL)isSetFormatEqualTo:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
