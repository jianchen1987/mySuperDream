//
//  TNBargainRecordModel.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

//#import "TNBargainRecordModel.h"
#import "TNBargainCountModel.h"
#import "TNBargainPeopleModel.h"
#import "TNPagingRspModel.h"
NS_ASSUME_NONNULL_BEGIN
@class TNBargainRecordModel;


@interface TNBargainRecordListRspModel : TNPagingRspModel
/// 商品数据源
@property (strong, nonatomic) NSArray<TNBargainRecordModel *> *records;
@end


@interface TNBargainRecordModel : TNModel
/// 状态 1:正在进行中2:成功;3:结束
@property (nonatomic, assign) TNBargainGoodStatus status;
/// 助力任务id
@property (nonatomic, copy) NSString *taskId;
/// 砍价活动id
@property (nonatomic, copy) NSString *activityId;
/// 图片
@property (nonatomic, copy) NSString *images;
/// 商品名称
@property (nonatomic, copy) NSString *goodsName;
/// 商品原价
@property (strong, nonatomic) SAMoneyModel *goodsPriceMoney;
/// 店铺名称
@property (nonatomic, copy) NSString *shopName;
/// 商品id
@property (nonatomic, copy) NSString *goodsId;
/// 商品规格
@property (nonatomic, copy) NSString *goodsSpec;
/// 砍价成功后的最低价
@property (strong, nonatomic) SAMoneyModel *lowestPriceMoney;
/// 过期时间
@property (nonatomic, assign) NSTimeInterval expiredTimeMillis;
/// 要求助力人数
@property (nonatomic, assign) NSInteger requiredUsers;
/// 订单id
@property (nonatomic, copy) NSString *orderNo;
/// 助力人数记录
@property (strong, nonatomic) NSArray<TNBargainPeopleModel *> *bargainDetailList;
/// 助力次数
@property (strong, nonatomic) TNBargainCountModel *bargainDetailsCount;
/// 过期时间 秒数
@property (nonatomic, assign) NSTimeInterval expiredTimeOut;
/// 是否显示新用户
@property (nonatomic, assign) BOOL isVerifyNewMember;
/// 是否需要下载app打开
@property (nonatomic, assign) BOOL isOpenBargainExponent;
/// 砍价任务类型
@property (nonatomic, assign) TNBargainTaskType bargainType;
/// 助力记录展示文案  返回的是html样式
@property (nonatomic, copy) NSString *userMsg;
/// 将html转换成富文本的展示
@property (nonatomic, copy) NSAttributedString *attrMsg;

@end

NS_ASSUME_NONNULL_END
