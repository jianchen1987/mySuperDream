//
//  TNScrollerExposureTool.h
//  SuperApp
//
//  Created by 张杰 on 2023/3/20.
//  Copyright © 2023 chaos network technology. All rights reserved.
//  记录滚动商品列表曝光工具类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface TNProductsExposureTool : NSObject
/////  商品id数组  需要埋点的页面通过exposureIndexArray下标获取后赋值
@property (strong, nonatomic, readonly) NSMutableArray<NSString *> *productIds;
/// 开始记录曝光商品数量  在cell  Willdisplay记录
/// - Parameter indexPath: 必须是tableView 或者是collectionView Willdisplay中的indexPath
//- (void)startRecordingExposureIndexWithScrollIndexPath:(NSIndexPath *)indexPath;

/// 开始记录曝光商品商品ID
- (void)startRecordingExposureIndexWithProductId:(NSString *)productId;
/// 返回处理商品id数据
/// - Parameters:
///   - productsListDict: 商品模型字典  key为商品数组所在的section  value为商品数组
//- (void)processExposureProductsIdByProductsListDict:(NSDictionary *)productsListDict;
///清空
- (void)clean;
@end

NS_ASSUME_NONNULL_END
