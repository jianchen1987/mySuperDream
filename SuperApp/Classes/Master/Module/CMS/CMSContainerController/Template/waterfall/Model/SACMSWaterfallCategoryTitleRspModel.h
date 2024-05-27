//
//  SACMSWaterfallCategoryTitleRspModel.h
//  SuperApp
//
//  Created by seeu on 2022/2/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SACMSCategoryTitleModel;


@interface SACMSWaterfallCategoryTitleRspModel : SARspInfoModel
///< 数据
@property (nonatomic, strong) NSArray<SACMSCategoryTitleModel *> *list;
@end


@interface SACMSCategoryTitleModel : SAModel

///< 标题
@property (nonatomic, strong) SAInternationalizationModel *title;
///< 关联值
@property (nonatomic, copy) NSString *associatedValue;

@end

NS_ASSUME_NONNULL_END
