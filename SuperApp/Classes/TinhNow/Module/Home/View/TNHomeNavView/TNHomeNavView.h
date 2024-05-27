//
//  TNHomeNavView.h
//  SuperApp
//
//  Created by seeu on 2020/6/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^clickedHandler)(void);


@interface TNHomeNavView : TNView

/// 点击搜索栏回调
@property (nonatomic, copy) clickedHandler searchBarClickedHandler;
/// 点击消息
//@property (nonatomic, copy) clickedHandler msgButtonClickedHandler;

@end

NS_ASSUME_NONNULL_END
