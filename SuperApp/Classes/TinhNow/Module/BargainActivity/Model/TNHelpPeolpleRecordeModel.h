//
//  TNHelpPeolpleRecordeModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/3/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"
#import "SAMoneyModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNHelpPeolpleRecordeModel : TNModel
/// 头像
@property (nonatomic, copy) NSString *img;
/// 名字
@property (nonatomic, copy) NSString *userName;
/// 助力金额
@property (strong, nonatomic) SAMoneyModel *money;
@end

NS_ASSUME_NONNULL_END
