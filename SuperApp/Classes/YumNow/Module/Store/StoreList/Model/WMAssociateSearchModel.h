//
//  WMAssociateSearchModel.h
//  SuperApp
//
//  Created by wmz on 2022/7/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "WMRspModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface WMAssociateSearchModel : WMRspModel
///联想词
@property (nonatomic, strong) SAInternationalizationModel *name;

@property (nonatomic, copy) NSString *cityCode;
///搜索关键词
@property (nonatomic, copy) NSString *keyword;
///历史词
@property (nonatomic, assign) BOOL history;

@end

NS_ASSUME_NONNULL_END
