//
//  TNSearchFilterPriceView.h
//  SuperApp
//
//  Created by seeu on 2020/6/28.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNFilterOptionProtocol.h"
#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNSearchFilterPriceView : TNView <TNFilterOptionProtocol>
/// lowest
@property (nonatomic, copy) NSString *lowest;
/// highest
@property (nonatomic, copy) NSString *highest;
/// 是否支持批量
@property (nonatomic, assign) BOOL stagePrice;
@end

NS_ASSUME_NONNULL_END
