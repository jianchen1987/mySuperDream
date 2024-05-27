//
//  CountryModel.h
//  customer
//
//  Created by 谢 on 2019/1/6.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface CountryModel : NSObject
@property (nonatomic, copy) NSString *countryName;   // "瑞士",
@property (nonatomic, copy) NSString *countryPinyin; // "rui shi",
@property (nonatomic, copy) NSString *phoneCode;     // "41",
@property (nonatomic, copy) NSString *countryCode;   // "CH"
@end

NS_ASSUME_NONNULL_END
