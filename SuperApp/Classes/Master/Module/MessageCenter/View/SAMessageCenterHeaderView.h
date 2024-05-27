//
//  SAMessageCenterHeaderView.h
//  SuperApp
//
//  Created by Tia on 2023/4/23.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAMessageCenterHeaderView : SAView
/// 已读按钮
@property (nonatomic, strong) HDUIButton *readButton;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 全部已读回调
@property (nonatomic, copy) dispatch_block_t allRealClickBlock;

@end

NS_ASSUME_NONNULL_END
