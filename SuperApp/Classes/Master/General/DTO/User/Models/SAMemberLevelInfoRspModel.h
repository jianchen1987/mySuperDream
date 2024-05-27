//
//  SAMemberLevelInfoRspModel.h
//  SuperApp
//
//  Created by seeu on 2022/1/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAMemberLevelInfoModel : SAModel
///< 会员等级
@property (nonatomic, assign) NSUInteger opLevel;
///< 会员名称
@property (nonatomic, copy) NSString *memberNameZh;
///< 会员名称
@property (nonatomic, copy) NSString *memberNameEn;
///< 会员名称
@property (nonatomic, copy) NSString *memberNameKm;
///< 会员logo
@property (nonatomic, copy) NSString *memberLogo;

///< 会员名称
@property (nonatomic, strong) SAInternationalizationModel *memberName;

@end


@interface SAMemberLevelInfoRspModel : SARspInfoModel

///< 会员等级
@property (nonatomic, assign) NSUInteger opLevel;
///< 等级列表
@property (nonatomic, strong) NSArray<SAMemberLevelInfoModel *> *userLevelNameListRespDTOS;

@end

NS_ASSUME_NONNULL_END
