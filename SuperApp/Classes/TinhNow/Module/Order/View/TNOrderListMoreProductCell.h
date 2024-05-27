//
//  TNOrderListMoreProductCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/3.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNOrderListRspModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNOrderListMoreProductCellModel : NSObject
///
@property (strong, nonatomic) TNOrderModel *orderModel;
/// 商品图片数组
@property (strong, nonatomic) NSArray<NSString *> *productPicArr;
@end


@interface TNOrderListMoreProductCell : SATableViewCell
/// 商品图片数组
@property (strong, nonatomic) NSArray<NSString *> *productPicArr;
@end

NS_ASSUME_NONNULL_END
