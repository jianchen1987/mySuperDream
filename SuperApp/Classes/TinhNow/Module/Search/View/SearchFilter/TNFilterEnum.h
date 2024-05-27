//
//  TNFilterEnum.h
//  SuperApp
//
//  Created by seeu on 2020/6/28.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString *TNSearchFilterOptions NS_STRING_ENUM;

FOUNDATION_EXPORT TNSearchFilterOptions const TNSearchFilterOptionsPriceLowest;  ///< 最低价
FOUNDATION_EXPORT TNSearchFilterOptions const TNSearchFilterOptionsPriceHighest; ///< 最高价

FOUNDATION_EXPORT TNSearchFilterOptions const TNSearchFilterOptionsStagePrice; ///< 是否批量
