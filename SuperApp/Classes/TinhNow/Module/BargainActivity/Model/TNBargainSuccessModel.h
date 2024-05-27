//
//  TNBargainSuccessModel.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/5.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNBargainSuccessModel : TNModel
/// 活动id
@property (nonatomic, copy) NSString *activityId;
/// 任务ID
@property (nonatomic, copy) NSString *taskId;
/// 助力用户昵称
@property (nonatomic, copy) NSString *userName;
/// 助力用户头像
@property (nonatomic, copy) NSString *userImage;
/// 商品名称
@property (nonatomic, copy) NSString *goodName;
/// 商品图片
@property (nonatomic, copy) NSString *goodsNameImage;
@end

NS_ASSUME_NONNULL_END
