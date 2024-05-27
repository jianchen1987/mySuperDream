//
//  SAMissingNotificationTipView.h
//  SuperApp
//
//  Created by VanJay on 2020/5/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAMissingNotificationTipModel : NSObject
/// 是否自计算尺寸，默认否
@property (nonatomic, assign) BOOL shouldFittingSize;
@end


@interface SAMissingNotificationTipView : SAView
/// 模型
@property (nonatomic, strong) SAMissingNotificationTipModel *model;

@end

NS_ASSUME_NONNULL_END
