//
//  SAMemberLevelInfoRspModel.m
//  SuperApp
//
//  Created by seeu on 2022/1/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAMemberLevelInfoRspModel.h"


@implementation SAMemberLevelInfoRspModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"userLevelNameListRespDTOS": SAMemberLevelInfoModel.class};
}

@end


@implementation SAMemberLevelInfoModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    self.memberName = [SAInternationalizationModel modelWithCN:self.memberNameZh en:self.memberNameEn kh:self.memberNameKm];

    return YES;
}

@end
