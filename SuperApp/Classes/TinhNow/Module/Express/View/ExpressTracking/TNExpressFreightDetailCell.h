//
//  TNExpressFreightDetailCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/9/17.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
@class TNExpressDetailsModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNExpressFreightDetailCellModel : NSObject
/// 运费明细数据
@property (strong, nonatomic) NSArray *dataArr;
+ (instancetype)configCellModelWithDetailModel:(TNExpressDetailsModel *)detailModel;
@end


@interface TNExpressFreightDetailCell : SATableViewCell
@property (strong, nonatomic) TNExpressFreightDetailCellModel *model;
@end

NS_ASSUME_NONNULL_END
