//
//  PNInterTransferReciverModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNInterTransferReciverModel : PNModel
/// 收款人id
@property (nonatomic, copy) NSString *reciverId;
/// 证件类型;13护照，12身份证
@property (nonatomic, assign) PNPapersType idType;
/// 证件类型码值;PASSPORT护照，NATIONAL_ID身份证
@property (nonatomic, copy) NSString *idTypeCode;
/// 证件编号
@property (nonatomic, copy) NSString *idCode;
/// 证件生效时间
@property (nonatomic, copy) NSString *idDeliveryDate;
/// 证件失效时间
@property (nonatomic, copy) NSString *idExpirationDate;
/// 证件国籍
@property (nonatomic, copy) NSString *idCountry;
/// 证件国籍码值;国籍信息ID
@property (nonatomic, copy) NSString *idCountryId;
/// 电话号码(移动国际用户识别码)
@property (nonatomic, copy) NSString *msisdn;
/// 名字
@property (nonatomic, copy) NSString *firstName;
/// 中间名字
@property (nonatomic, copy) NSString *middleName;
/// 姓氏
@property (nonatomic, copy) NSString *lastName;
/// 全名
@property (nonatomic, copy) NSString *fullName;
/// 性别;10未知，14男性，15女性
@property (nonatomic, assign) PNSexType genderType;
/// 出生日期  时间戳
@property (nonatomic, copy) NSString *birthDate;
/// 出生日期格式化显示
@property (nonatomic, copy) NSString *showBirthDateStr;
/// 出生国籍
@property (nonatomic, copy) NSString *birthCountry;
/// 出生国籍码值;国籍信息ID
@property (nonatomic, copy) NSString *birthCountryId;
/// 身份国籍
@property (nonatomic, copy) NSString *nationality;
/// 身份国籍码值;国籍信息ID
@property (nonatomic, copy) NSString *nationalityCodeId;
/// 省
@property (nonatomic, copy) NSString *province;
/// 城市
@property (nonatomic, copy) NSString *city;
/// 地址
@property (nonatomic, copy) NSString *address;
/// 邮箱
@property (nonatomic, copy) NSString *email;
/// 关系
@property (nonatomic, copy) NSString *relationType;
/// 关系code
@property (nonatomic, copy) NSString *relationCode;
/// 其它关系
@property (nonatomic, copy) NSString *otherRelation;
/// 收款人是否可用
@property (nonatomic, assign) BOOL beneficiaryIsUsable;
/// 收款人不可用提示文案
@property (nonatomic, copy) NSString *beneficiaryIsUsableMsg;

@property (nonatomic, assign) PNInterTransferThunesChannel channel;
@property (nonatomic, copy) NSString *logoPath;
@end

NS_ASSUME_NONNULL_END
