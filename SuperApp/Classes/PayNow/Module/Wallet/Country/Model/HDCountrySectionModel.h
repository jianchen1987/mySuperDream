//
//  HDCountrySectionModel.h
//  ViPay
//
//  Created by VanJay on 2019/7/20.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "CountryModel.h"
#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface HDCountrySectionModel : PNModel
@property (nonatomic, copy) NSArray<CountryModel *> *data; ///< 国家
@property (nonatomic, copy) NSString *key;                 ///< 首字母
@end

NS_ASSUME_NONNULL_END
