//
//  SASearchHistoryView.h
//  SuperApp
//
//  Created by Tia on 2022/12/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SASearchHistoryView : SAView
/// 选中回调
@property (nonatomic, copy) void (^keywordSelectedBlock)(NSString *keyword);

@end

NS_ASSUME_NONNULL_END
