//
//  HDTransationData.h
//  customer
//
//  Created by 帅呆 on 2018/12/24.
//  Copyright © 2018 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDTransationData : NSObject

@property (nonatomic, copy) NSString *tradeNo;
@property (nonatomic, copy) NSString *amt;
@property (nonatomic, copy) NSString *cy;
@property (nonatomic, copy) NSString *payer;
@property (nonatomic, copy) NSString *timeStamp;

@end

NS_ASSUME_NONNULL_END
