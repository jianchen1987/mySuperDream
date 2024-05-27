//
//  TransViewModel.h
//  SuperApp
//
//  Created by Quin on 2021/11/16.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAViewModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TransViewModel : SAViewModel
/// 获取成功
@property (nonatomic, copy) void (^successGetDataBlock)(HDNetworkResponse *);
/// 获取失败
@property (nonatomic, copy) void (^failedGetDataBlock)(HDNetworkResponse *);

- (void)getData:(NSDictionary *)params Api:(NSString *)api;
@end

NS_ASSUME_NONNULL_END
