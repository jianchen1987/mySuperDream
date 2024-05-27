//
//  TNCartBarView.h
//  SuperApp
//
//  Created by wownow on 2023/9/18.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "TNView.h"
#import "TNShoppingCartButton.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNCartBarView : TNView
@property (nonatomic, strong, readonly) HDUIButton *cartBtn;
- (void)shake;

@end

NS_ASSUME_NONNULL_END
