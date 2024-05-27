//
//  SASearchAssociateModel.h
//  SuperApp
//
//  Created by Tia on 2023/7/7.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAModel.h"
#import "SAInternationalizationModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SASearchAssociateModel : SAModel
///联想词
@property (nonatomic, strong) SAInternationalizationModel *name;

@property (nonatomic, copy) NSString *cityCode;
///搜索关键词
@property (nonatomic, copy) NSString *keyword;

@end

NS_ASSUME_NONNULL_END
