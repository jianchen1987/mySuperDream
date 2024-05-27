//
//  PNNotifyView.h
//  SuperApp
//
//  Created by xixi on 2023/1/30.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNNotifyView : PNView

@property (nonatomic, copy) NSString *content;

/// 返回view的高度
- (CGFloat)getViewHeight;
@end

NS_ASSUME_NONNULL_END
