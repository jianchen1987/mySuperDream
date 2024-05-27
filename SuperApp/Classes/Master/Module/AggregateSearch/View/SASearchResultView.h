//
//  SASearchResultView.h
//  SuperApp
//
//  Created by Tia on 2022/12/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAAddressModel.h"
#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SASearchResultView : SAView
///热词传递
- (void)searchListForKeyWord:(NSString *)keyword;

@end

NS_ASSUME_NONNULL_END
