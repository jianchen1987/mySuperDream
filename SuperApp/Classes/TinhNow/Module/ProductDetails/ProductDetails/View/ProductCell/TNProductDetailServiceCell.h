//
//  TNProductDetailServiceCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/8/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
@class TNProductServiceModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNProductDetailServiceCellModel : NSObject
/// 服务条款
@property (strong, nonatomic) NSArray<TNProductServiceModel *> *servicesList;
///  砍价页用了  砍价的不用设置内边距
@property (nonatomic, assign) BOOL notSetCellInset;
@end


@interface TNProductDetailServiceCell : SATableViewCell
@property (strong, nonatomic) TNProductDetailServiceCellModel *model;
@end

NS_ASSUME_NONNULL_END
