//
//  WMStoreProductMerchantReplyView.h
//  SuperApp
//
//  Created by VanJay on 2020/6/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN

/// 商家回复
@interface WMStoreProductMerchantReplyView : SAView
/// 更新商家回复

/// 更新商家回复
/// @param reply 商家回复内容
/// @param isMerchantReplyExpanded 展开状态
/// @param showReadMoreMaxRowCount 显示 查看更多的行数
/// @param numberOfLines 行数限制（showReadMoreMaxRowCount 为 0 生效）
- (void)updateMerchantReply:(NSString *)reply isMerchantReplyExpanded:(BOOL)isMerchantReplyExpanded showReadMoreMaxRowCount:(NSUInteger)showReadMoreMaxRowCount numberOfLines:(NSUInteger)numberOfLines;
/// 点击了查看更多或更少
@property (nonatomic, copy) void (^clickedReadMoreOrReadLessBlock)(void);
@end

NS_ASSUME_NONNULL_END
