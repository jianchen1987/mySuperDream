//
//  HDPayeeInfoModel.m
//  ViPay
//
//  Created by seeu on 2019/7/18.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDPayeeInfoModel.h"


@implementation HDPayeeInfoModel

- (instancetype)initWithContactModel:(HDContactsModel *)contact {
    self = [super init];
    if (self) {
        self.payeeLoginName = contact.mobilePhone;
        self.firstName = contact.realNameFirst;
        self.lastName = contact.realNameEnd;
        self.nickName = contact.nickName;
        self.headUrl = contact.headUrl;
        self.orderAmt = nil;
    }
    return self;
}

- (instancetype)initWithAnalysisQRCodeModel:(HDAnalysisQRCodeRspModel *)analysisModel {
    self = [super init];
    if (self) {
        self.payeeLoginName = analysisModel.payeeNo;
        self.nickName = analysisModel.payeeName;
        self.headUrl = analysisModel.payeeHeadUrl;
        self.orderAmt = analysisModel.orderAmt;
        self.firstName = @"";
        self.lastName = analysisModel.payeeName;
    }
    return self;
}

+ (instancetype)modelWithTitle:(NSString *)title icon:(NSString *)icon routePath:(NSURL *)routePath {
    HDPayeeInfoModel *model = [HDPayeeInfoModel new];
    model.nickName = title;
    model.headUrl = icon;
    model.routePath = routePath;

    return model;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"sceneQrCodeInfoDTO": PNSceneQrCodeInfoModel.class,
    };
}

@end
