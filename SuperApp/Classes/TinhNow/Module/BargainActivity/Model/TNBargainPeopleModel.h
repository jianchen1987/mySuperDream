//
//  TNBargainPeopleModel.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "TNModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainPeopleModel : TNModel
/// 砍价任务id
@property (nonatomic, copy) NSString *taskId;
/// 助力用户ID
@property (nonatomic, copy) NSString *userId;
/// 助力用户昵称
@property (nonatomic, copy) NSString *userNickname;
/// 助力用户头像
@property (nonatomic, copy) NSString *userPortrait;
/// 助力金额
@property (strong, nonatomic) SAMoneyModel *discountAmountMoney;

@end

NS_ASSUME_NONNULL_END
