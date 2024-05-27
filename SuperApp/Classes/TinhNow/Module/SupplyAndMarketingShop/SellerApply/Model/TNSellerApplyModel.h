//
//  TNSellerApplyModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

typedef NS_ENUM(NSInteger, TNSellerApplyStatus) {
    //已经是卖家
    TNSellerApplyStatusSucess = 0,
    //未申请
    TNSellerApplyStatusNone = 1,
    //申请中
    TNSellerApplyStatusApplying = 2,
    //申请被拒绝
    TNSellerApplyStatusReject = 3,
};

NS_ASSUME_NONNULL_BEGIN


@interface TNSellerApplyModel : TNModel
@property (nonatomic, copy) NSString *firstName;                             ///< 姓
@property (nonatomic, copy) NSString *lastName;                              ///< 名
@property (nonatomic, copy) NSString *memberId;                              ///< 卖家ID
@property (nonatomic, copy) NSString *telephoneNumber;                       ///< 手机号码  填写的
@property (nonatomic, copy) NSString *wechat;                                ///< 手机号码
@property (nonatomic, copy) NSString *facebook;                              ///< 手机号码
@property (nonatomic, copy) NSString *areaCode;                              ///< 手机号码
@property (nonatomic, assign) TNSellerApplyStatus status;                    ///<申请状态
@property (nonatomic, copy) NSString *number;                                ///< 手机号码  用户自己的
@property (nonatomic, copy) NSString *sellerChannelValue;                    ///< 填写的来源渠道
@property (strong, nonatomic) NSArray<NSDictionary *> *dicValues;            ///< 渠道来源  字段  key  value
@property (strong, nonatomic) NSArray<NSDictionary *> *customerChannelTypes; ///< 客户渠道数据  字段  key  value
@property (nonatomic, copy) NSString *customerChannelType;                   ///<  客户渠道回显值
@property (strong, nonatomic) NSArray<NSDictionary *> *customerGroups;       ///< 客户群体  字段  key  value
@property (nonatomic, copy) NSString *customerGroup;                         ///<  客户群体回显值
@property (strong, nonatomic) NSArray<NSString *> *images;                   ///< 门店图片数组
@property (nonatomic, copy) NSString *sellerChannelKey;                      ///< 招商来源 key值  提交和返回字段不一致  。。。。

/// 提交申请用字段  渠道来源key值
@property (nonatomic, copy) NSString *sellerApplyChannels;
/// 提交申请其它来源
@property (nonatomic, copy) NSString *sellerApplyChannelsContent;
/// 提交申请用字段 客服渠道key值
@property (nonatomic, copy) NSString *customerChannelId;
/// 提交申请用字段  客户群体key值
@property (nonatomic, copy) NSString *customerGroupId;

@end

NS_ASSUME_NONNULL_END
