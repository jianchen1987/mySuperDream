//
//  TNSellerOrderConfig.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerOrderModel.h"
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN


@interface TNSellerOrderConfig : NSObject
@property (nonatomic, copy) NSString *title; ///< 标题
@property (nonatomic, assign) TNSellerOrderStatus status;

+ (instancetype)configWithTitle:(NSString *)title status:(TNSellerOrderStatus)status;
@end

NS_ASSUME_NONNULL_END
