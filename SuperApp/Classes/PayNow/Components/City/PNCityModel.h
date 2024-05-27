//
//  PNCityModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/9/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNCityItemModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNCityModel : PNModel
/// 北京市
@property (nonatomic, copy) NSString *province;
/// 京
@property (nonatomic, copy) NSString *abbreviate;
/// 110000
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) NSArray<PNCityItemModel *> *cities;

@end


@interface PNCityItemModel : PNModel
///
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@end


NS_ASSUME_NONNULL_END
