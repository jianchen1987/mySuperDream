//
//  SACancellationApplicationAssetsAndEquityViewModel.m
//  SuperApp
//
//  Created by Tia on 2022/6/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACancellationApplicationAssetsAndEquityViewModel.h"
#import "SACancellationAssetModel.h"


@interface SACancellationApplicationAssetsAndEquityViewModel ()

@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, assign) BOOL refreshFlag;

@property (nonatomic, copy) NSArray *dataSource;
/// 注销原因模型数据
@property (nonatomic, strong) SACancellationReasonModel *reasonModel;

@end


@implementation SACancellationApplicationAssetsAndEquityViewModel

- (instancetype)initWithModel:(id)model {
    if (self = [super initWithModel:model]) {
        self.reasonModel = model;
    }
    return self;
}

- (void)queryOrdeDetailInfo {
    self.isLoading = YES;
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/cancellation/getAsset.do";
    request.requestParameter = @{};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        self.dataSource = [NSArray yy_modelArrayWithClass:SACancellationAssetModel.class json:rspModel.data];
        if (self.isNetworkError) {
            self.isNetworkError = false;
        }
        self.isLoading = NO;
        self.refreshFlag = !self.refreshFlag;
    } failure:^(HDNetworkResponse *_Nonnull response) {
        self.isNetworkError = YES;
        self.isLoading = NO;
        self.refreshFlag = !self.refreshFlag;
    }];
}

@end
