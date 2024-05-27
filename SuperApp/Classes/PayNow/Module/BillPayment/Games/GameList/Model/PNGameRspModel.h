//
//  PNGameRspModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/12/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNGameTitleInfoModel : PNModel
/// 标题
@property (nonatomic, copy) NSString *title;
/// 描述
@property (nonatomic, copy) NSString *desc;
@end


@interface PNGameCategoryModel : PNModel
/// id
@property (nonatomic, copy) NSString *gameId;
/// 备注
@property (nonatomic, copy) NSString *remark;
/// 图片
@property (nonatomic, copy) NSString *image;
/// 描述
@property (nonatomic, copy) NSString *des;
/// 名称
@property (nonatomic, copy) NSString *name;
@end


@interface PNGameRspModel : PNModel
///
@property (strong, nonatomic) NSArray<PNGameCategoryModel *> *categories;
///
@property (strong, nonatomic) PNGameTitleInfoModel *titleInfo;
@end

NS_ASSUME_NONNULL_END
