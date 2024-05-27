//
//  TNPictureSearchDTO.h
//  SuperApp
//
//  Created by 张杰 on 2022/1/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNModel.h"
#import "TNPictureSearchRspModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNPictureSearchDTO : TNModel

/// 通过图片查询相似商品
/// @param picUrl 图片地址
/// @param pageNo 页码
/// @param pageSize 页数
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryProductSimilarSearchWithPicUrl:(NSString *)picUrl
                                     pageNo:(NSInteger)pageNo
                                   pageSize:(NSInteger)pageSize
                                    success:(void (^_Nullable)(TNPictureSearchRspModel *rspModel))successBlock
                                    failure:(CMNetworkFailureBlock _Nullable)failureBlock;

///// 创建图搜索相似商品查询任务
///// @param picUrl 图片地址
///// @param pageNo 页码
///// @param pageSize 页数
///// @param successBlock 成功回调
///// @param failureBlock 失败回调
//- (void)createSimilarSearchJobWithPicUrl:(NSString *)picUrl
//                                  pageNo:(NSInteger)pageNo
//                                pageSize:(NSInteger)pageSize
//                                 success:(void (^_Nullable)(TNPictureSearchRspModel *rspModel))successBlock
//                                 failure:(CMNetworkFailureBlock _Nullable)failureBlock;
//
///// 查询搜索图片任务
///// @param taskId 任务id
///// @param successBlock 成功回调
///// @param failureBlock 失败回调
//- (void)querySimilarSearchJobWithTaskId:(NSString *)taskId success:(void (^_Nullable)(TNPictureSearchRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
//
///// 取消所有请求
//- (void)cancel;

@end

NS_ASSUME_NONNULL_END
