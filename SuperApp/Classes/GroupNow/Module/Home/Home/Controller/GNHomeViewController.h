//
//  GNHomeViewController.h
//  SuperApp
//
//  Created by wmz on 2021/5/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNHomeViewController : GNViewController
///开始滚动
@property (nonatomic, assign, getter=isDown) BOOL down;
///手动置顶
- (void)scrollToTop;

@end

NS_ASSUME_NONNULL_END
