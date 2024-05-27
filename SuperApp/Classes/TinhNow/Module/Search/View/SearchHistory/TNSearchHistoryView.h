//
//  TNSearchHistoryView.h
//  SuperApp
//
//  Created by seeu on 2020/6/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^SearchHistoryKeyWordSelected)(NSString *keyWord);


@interface TNSearchHistoryView : TNView
/// 选中回调
@property (nonatomic, copy) SearchHistoryKeyWordSelected searchHistoryKeyWordSelected;
@end

NS_ASSUME_NONNULL_END
