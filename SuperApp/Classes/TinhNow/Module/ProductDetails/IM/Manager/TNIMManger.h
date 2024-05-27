//
//  TNIMManger.h
//  SuperApp
//
//  Created by xixi on 2021/1/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNIMRspModel.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface TNIMCacheModel : NSObject
/// 店铺id
@property (nonatomic, strong) NSString *storeNo;
/// 缓存接口的数据
@property (nonatomic, strong) NSArray<TNIMRspModel *> *dataArray;
/// 缓存数据那一刻的时间戳
@property (nonatomic, assign) NSTimeInterval timeInterval;
@end


@interface TNIMManger : NSObject

+ (TNIMManger *)shared;

- (void)getCustomerServerList:(NSString *)storeNo success:(void (^_Nullable)(NSArray<TNIMRspModel *> *rspModelArray))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 打开客服聊天页面
/// @param storeNo 店铺ID  用于获取客服数据
/// @param orderNo 订单ID  用于发送订单数据给客服  有就传
- (void)openCustomerServiceChatWithStoreNo:(NSString *)storeNo orderNo:(NSString *_Nullable)orderNo;

/// 打开客服聊天页面 询问商品  需要组装卡片
/// @param storeNo 店铺id
/// @param title 标题
/// @param content 内容
/// @param image 图片
- (void)openCustomerServiceChatWithStoreNo:(NSString *)storeNo title:(NSString *)title content:(NSString *)content image:(NSString *)image;
@end

NS_ASSUME_NONNULL_END
