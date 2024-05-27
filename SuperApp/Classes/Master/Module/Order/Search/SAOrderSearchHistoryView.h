//
//  SAOrderSearchView.h
//  SuperApp
//
//  Created by Tia on 2023/2/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAOrderSearchHistoryView : SAView
/// 选中回调
@property (nonatomic, copy) void (^keywordSelectedBlock)(NSString *keyword);

@end

NS_ASSUME_NONNULL_END
