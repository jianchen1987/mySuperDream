//
//  TNBargainDetailModel.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/5.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainCountModel.h"
#import "TNBargainPeopleModel.h"
#import "TNBargainRuleModel.h"
#import "TNModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNCouponModel : TNModel
/// 优惠金额
@property (nonatomic, strong) SAMoneyModel *couponMoney;
/// 优惠卷code
@property (nonatomic, strong) NSString *couponCode;
/// couponNo
@property (nonatomic, strong) NSString *couponNo;
/// 优惠卷专题
@property (nonatomic, strong) NSString *couponTitle;
/// 优惠卷类型 优惠券类型 13-折扣券 14-满减券 15-代金券"
@property (nonatomic, strong) NSString *couponType;
@end

///帮砍一刀返回模型
///发起人用户信息模型
@interface TNHelpBargainModel : TNModel
/// 是否砍价    0:已砍价    1：未砍价
@property (nonatomic, assign) BOOL isBargain;
/// 当isBargain为1时，返回未砍价的原因
@property (nonatomic, copy) NSString *info;
/// 当前砍一刀金额
@property (nonatomic, copy) SAMoneyModel *bargainPriceMoney;
/// 已经砍价总金额
@property (strong, nonatomic) SAMoneyModel *helpedPriceMoney;
/// 助力人数记录
@property (strong, nonatomic) NSArray<TNBargainPeopleModel *> *bargainDetailList;
/// 是否砍价成功
@property (nonatomic, assign) BOOL isBargainSuccess;
/// 帮砍页面 邀请人文案  包含未砍价的提示文案  和已经砍价后的提示 有可能是H5 展示
@property (nonatomic, copy) NSString *helpCopywritingV2;
/// 帮砍价金额  主要用于判断是否需要展示砍价金额   同helpCopywritingV2  一起用
@property (strong, nonatomic) SAMoneyModel *userMsgPrice;
/// 助力记录展示文案  返回的是html样式
@property (nonatomic, copy) NSString *userMsg;
/// 优惠券数据list
@property (nonatomic, strong) NSArray<TNCouponModel *> *couponList;

@end

///发起人用户信息模型
@interface TNBargainUserModel : TNModel
/// 用户头像
@property (nonatomic, copy) NSString *userImage;
/// 用户名
@property (nonatomic, copy) NSString *username;
@end

///砍价详情模型
@interface TNBargainDetailModel : TNModel
///// 任务id
@property (nonatomic, copy) NSString *taskId;
/// 状态 1:正在进行中2:成功;3:结束
@property (nonatomic, assign) TNBargainGoodStatus status;
/// 砍价成功后的最低价
@property (strong, nonatomic) SAMoneyModel *lowestPriceMoney;
/// 商品名称
@property (nonatomic, copy) NSString *goodsName;
/// 商品原价
@property (strong, nonatomic) SAMoneyModel *goodsPriceMoney;
/// 图片
@property (nonatomic, copy) NSString *images;
/// 店铺名称
@property (nonatomic, copy) NSString *shopName;
/// 商品id
@property (nonatomic, copy) NSString *goodsId;
/// 商品规格
@property (nonatomic, copy) NSString *goodsSpec;
/// 砍价活动id
@property (nonatomic, copy) NSString *activityId;
/// 要求助力人数
@property (nonatomic, assign) NSInteger requiredUsers;
/// 库存数量
@property (nonatomic, assign) NSInteger stockNumber;
/// 过期时间 毫秒
@property (nonatomic, assign) NSTimeInterval expiredTimeMillis;
/// 订单id
@property (nonatomic, copy) NSString *orderNo;
/// 助力人数记录
@property (strong, nonatomic) NSArray<TNBargainPeopleModel *> *bargainDetailList;
/// 助力次数
@property (strong, nonatomic) TNBargainCountModel *bargainDetailsCount;
/// 过期时间 秒数
@property (nonatomic, assign) NSTimeInterval expiredTimeOut;
/// 发起人用户信息
@property (strong, nonatomic) TNBargainUserModel *userTaskInfoVO;
/// 新注册用户提示
@property (nonatomic, copy) NSString *registNewTips;
/// 需要下载app提示
@property (nonatomic, copy) NSString *downLoadAppTips;
/// 是否显示新用户
@property (nonatomic, assign) BOOL isVerifyNewMember;
/// 是否需要下载app打开
@property (nonatomic, assign) BOOL isOpenBargainExponent;
/// 帮砍页面 邀请人文案  包含未砍价的提示文案  和已经砍价后的提示 有可能是H5 展示
@property (nonatomic, copy) NSString *helpCopywritingV2;
/// 将html转换成富文本的展示
@property (nonatomic, copy) NSAttributedString *attrhelpCopywritingV2;
/// 帮砍价金额
@property (strong, nonatomic) SAMoneyModel *operatorHelpedPriceMoney;
/// 已经砍价总金额
@property (strong, nonatomic) SAMoneyModel *helpedPriceMoney;
/// 砍价失败提示
@property (nonatomic, copy) NSString *helpFailMsg;
/// 是否已经帮看过  只有在登录情况下有效
@property (nonatomic, assign) BOOL isHelpedBargain;
/// 最多还可以助力多少金额
@property (strong, nonatomic) SAMoneyModel *canHelpePriceMoney;
/// 砍价任务类型
@property (nonatomic, assign) TNBargainTaskType bargainType;
/// 是否需要唤起app
@property (nonatomic, assign) BOOL isEvokeApp;
/// 助力记录展示文案  返回的是html样式
@property (nonatomic, copy) NSString *userMsg;
/// 将html转换成富文本的展示
@property (nonatomic, copy) NSAttributedString *attrMsg;
/// 砍价任务进行中 按钮展示文本
@property (nonatomic, copy) NSString *buttonMsg;
/// 帮砍价金额  根据类型 可能返回空  主要用于判断是否需要展示砍价金额   同helpCopywritingV2  一起用
@property (strong, nonatomic) SAMoneyModel *userMsgPrice;
/// 优惠券数据list
@property (nonatomic, strong) NSArray<TNCouponModel *> *couponList;
/***********绑定属性  帮砍数据************/
/// 图片数组
@property (strong, nonatomic) NSArray<TNAdaptImageModel *> *rulePics;
/// 砍价成功的展示文本  需要helpCopywritingV2 和userMsgPrice 拼接使用
@property (nonatomic, copy) NSString *showBargainSuccessMsg;
/// 进度条  进度
@property (nonatomic, assign) CGFloat taskPrecent;

@end

NS_ASSUME_NONNULL_END
