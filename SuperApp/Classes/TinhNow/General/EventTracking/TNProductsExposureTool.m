//
//  TNScrollerExposureTool.m
//  SuperApp
//
//  Created by 张杰 on 2023/3/20.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "TNProductsExposureTool.h"
#import "TNGoodsModel.h"
#import <HDKitCore/HDKitCore.h>


@interface TNProductsExposureTool ()
///  记录曝光的下标位置
//@property (strong, nonatomic) NSMutableArray<NSIndexPath *> *exposureIndexArray;
@property (strong, nonatomic) NSMutableArray<NSString *> *productIds;
@end


@implementation TNProductsExposureTool
//- (void)startRecordingExposureIndexWithScrollIndexPath:(NSIndexPath *)indexPath {
//
//    HDLog(@"startRecordingExposureIndex --section = %ld, row = %ld", indexPath.section, indexPath.row);
//
//    if (![self.exposureIndexArray containsObject:indexPath]) {
//        [self.exposureIndexArray addObject:indexPath];
//    } else {
//        HDLog(@"exposureIndexArray已经记录过了 %@", indexPath);
//    }
//}
- (void)startRecordingExposureIndexWithProductId:(NSString *)productId {
    //    HDLog(@"startRecordingExposureIndexWithProductId = %@", productId);
    if (HDIsStringNotEmpty(productId) && ![self.productIds containsObject:productId]) {
        [self.productIds addObject:productId];
    } else {
        //        HDLog(@"productIds已经记录过了 %@", productId);
    }
}
//-(void)processExposureProductsIdByProductsListDict:(NSDictionary *)productsListDict{
//    if (!HDIsObjectNil(productsListDict) && !HDIsArrayEmpty(self.exposureIndexArray)) {
//        [self.exposureIndexArray enumerateObjectsUsingBlock:^(NSIndexPath *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
//            NSArray *list = [productsListDict objectForKey:[NSString stringWithFormat:@"%ld",obj.section]];
//            if (!HDIsArrayEmpty(list) && list.count > obj.row) {
//                id tempModel = list[obj.row];
//                if ([tempModel isKindOfClass:[TNGoodsModel class]]) {
//                    TNGoodsModel *model = tempModel;
//                    [self.productIds addObject:model.productId];
//                    HDLog(@"曝光的商品名字 = %@ 商品id = %@", model.productName, model.productId);
//                }
//            }
//        }];
//    }
//}
//- (void)processExposureProductsIdByProductsList:(NSArray *)list section:(NSInteger)section {
//    if (!HDIsArrayEmpty(list) && !HDIsArrayEmpty(self.exposureIndexArray)) {
//        [self.exposureIndexArray enumerateObjectsUsingBlock:^(NSIndexPath *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
//            if (obj.section == section) {
//                if (list.count > obj.row) {
//                    id tempModel = list[obj.row];
//                    if ([tempModel isKindOfClass:[TNGoodsModel class]]) {
//                        TNGoodsModel *model = tempModel;
//                        [self.productIds addObject:model.productId];
//                        HDLog(@"曝光的商品名字 = %@ 商品id = %@", model.productName, model.productId);
//                    }
//                }
//            }
//        }];
//    }
//}
- (void)clean {
    //    [self.exposureIndexArray removeAllObjects];
    [self.productIds removeAllObjects];
}
///** @lazy exposureIndexArray */
//- (NSMutableArray<NSIndexPath *> *)exposureIndexArray {
//    if (!_exposureIndexArray) {
//        _exposureIndexArray = [NSMutableArray array];
//    }
//    return _exposureIndexArray;
//}
/** @lazy productIds */
- (NSMutableArray<NSString *> *)productIds {
    if (!_productIds) {
        _productIds = [NSMutableArray array];
    }
    return _productIds;
}

@end
