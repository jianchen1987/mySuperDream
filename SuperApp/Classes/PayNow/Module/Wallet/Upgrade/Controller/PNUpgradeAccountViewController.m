//
//  PNUpgradeAccountViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/1/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNUpgradeAccountViewController.h"
#import "PNAccountViewModel.h"
#import "PNConfirmNameView.h"
#import "PNUploadLegalDocView.h"
#import "SAWriteDateReadableModel.h"


@interface PNUpgradeAccountViewController ()
@property (nonatomic, strong) PNAccountViewModel *viewModel;
@property (nonatomic, strong) PNUploadLegalDocView *uploadView;
@property (nonatomic, strong) PNConfirmNameView *confirmNameView;

@property (nonatomic, assign) NSInteger step;
@property (nonatomic, assign) BOOL needGetUserInfoData;
@end


@implementation PNUpgradeAccountViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    ///步骤 根据入参step 决定显示哪个view
    if ([self.parameters.allKeys containsObject:@"step"]) {
        self.step = [[self.parameters objectForKey:@"step"] integerValue];
    } else {
        self.step = 1;
    }

    if ([parameters.allKeys containsObject:@"needCall"]) {
        self.needGetUserInfoData = [[parameters objectForKey:@"needCall"] boolValue];
    } else {
        self.needGetUserInfoData = YES;
    }

    if ([parameters.allKeys containsObject:@"userInfo"]) {
        /// 按目前的逻辑，只有在第二个步骤的是才不需要调用接口，user 的数据从第一个步骤传过来
        if (self.step == 2) {
            HDUserInfoRspModel *userInfoModel = [HDUserInfoRspModel yy_modelWithJSON:[parameters objectForKey:@"userInfo"]];
            self.viewModel.userInfoModel = userInfoModel;
        }
    }

    if (self.step == 2) {
        HDLog(@"这个是第二个步骤啊");
        self.uploadView.headUrl = [self.parameters objectForKey:@"headUrl"];
        self.uploadView.lastName = [self.parameters objectForKey:@"lastName"];
        self.uploadView.firstName = [self.parameters objectForKey:@"firstName"];
        self.uploadView.sex = [[self.parameters objectForKey:@"sex"] integerValue];
        self.uploadView.birthday = [[self.parameters objectForKey:@"birthday"] integerValue];
        self.uploadView.country = [self.parameters objectForKey:@"country"];

        SAWriteDateReadableModel *model = [SACacheManager.shared objectForKey:kSaveUserTempInfo type:SACacheTypeCacheNotPublic];
        if (model) {
            HDLog(@"发现缓存");
            HDLog(@"%@", model.storeObj);
            NSDictionary *dict = model.storeObj;
            if (!WJIsObjectNil(dict)) {
                self.uploadView.cardType = [[dict objectForKey:@"cardType"] integerValue];
                self.uploadView.cardNum = [dict objectForKey:@"cardNum"];
                self.uploadView.expirationTime = [[dict objectForKey:@"expirationTime"] integerValue];
                self.uploadView.visaExpirationTime = [[dict objectForKey:@"visaExpirationTime"] integerValue];
                self.uploadView.idCardFrontUrl = [dict objectForKey:@"idCardFrontUrl"];
                self.uploadView.idCardBackUrl = [dict objectForKey:@"idCardBackUrl"];
                self.uploadView.cardHandUrl = [dict objectForKey:@"cardHandUrl"];

                if (![self.uploadView.country isEqualToString:@"KH"]) {
                    /// 强制转成选择护照
                    if (self.uploadView.cardType != PNPapersTypePassport || self.uploadView.cardType != PNPapersTypeDrivingLince) {
                        self.uploadView.cardType = PNPapersTypePassport;
                    }
                }
            } else {
                [self supplement];
            }
        } else {
            [self supplement];
        }
    }

    return self;
}

- (void)supplement {
    //没有缓存数据就需要 用接口数据
    self.uploadView.cardType = self.viewModel.userInfoModel.cardType;
    self.uploadView.cardNum = self.viewModel.userInfoModel.cardNum;
    self.uploadView.expirationTime = self.viewModel.userInfoModel.expirationTime;
    self.uploadView.visaExpirationTime = self.viewModel.userInfoModel.visaExpirationTime;
    self.uploadView.idCardFrontUrl = self.viewModel.userInfoModel.idCardFrontUrl;
    self.uploadView.idCardBackUrl = self.viewModel.userInfoModel.idCardBackUrl;
    self.uploadView.cardHandUrl = self.viewModel.userInfoModel.cardHandUrl;
}

- (void)dealloc {
    HDLog(@"%@ 释放了", NSStringFromClass(self.class));
    if (self.step == 2) {
        /// 返回上一页需要缓存 填写的数据
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@(self.uploadView.cardType) forKey:@"cardType"];
        [dict setValue:self.uploadView.cardNum forKey:@"cardNum"];
        [dict setValue:@(self.uploadView.expirationTime) forKey:@"expirationTime"];
        [dict setValue:self.uploadView.idCardFrontUrl forKey:@"idCardFrontUrl"];
        [dict setValue:self.uploadView.idCardBackUrl forKey:@"idCardBackUrl"];
        [dict setValue:self.uploadView.cardHandUrl forKey:@"cardHandUrl"];
        [dict setValue:@(self.uploadView.visaExpirationTime) forKey:@"visaExpirationTime"];

        HDLog(@"缓存数据: %@", dict);
        [SACacheManager.shared setObject:[SAWriteDateReadableModel modelWithStoreObj:dict] forKey:kSaveUserTempInfo type:SACacheTypeCacheNotPublic];
    } else {
        [SACacheManager.shared removeObjectForKey:kSaveUserTempInfo type:SACacheTypeCacheNotPublic];
    }
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"Upgrade_account", @"升级账户");
}

- (BOOL)allowContinuousBePushed {
    return YES;
}

- (void)hd_bindViewModel {
    if (self.needGetUserInfoData) {
        if (self.step == 1) {
            [self.viewModel hd_bindView:self.confirmNameView];
            [self.viewModel getUserInfoFromKYC];
        } else {
            [self.viewModel hd_bindView:self.uploadView];
            [self.viewModel getUserInfoFromKYC];
        }
    } else {
        [self refreshData];
    }
}

- (void)refreshData {
    if (self.step == 1) {
        self.confirmNameView.refreshFlag = YES;
    } else {
        self.uploadView.refreshFlag = YES;
    }
}

- (void)hd_setupViews {
    if (self.step == 1) {
        self.confirmNameView.hidden = NO;
        [self.view addSubview:self.confirmNameView];
    } else {
        self.uploadView.hidden = NO;
        [self.view addSubview:self.uploadView];
    }
}

- (void)updateViewConstraints {
    if (!self.uploadView.hidden) {
        [self.uploadView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }

    if (!self.confirmNameView.hidden) {
        [self.confirmNameView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }

    [super updateViewConstraints];
}

#pragma mark
- (PNAccountViewModel *)viewModel {
    return _viewModel ?: ({ _viewModel = [[PNAccountViewModel alloc] init]; });
}

- (PNUploadLegalDocView *)uploadView {
    if (!_uploadView) {
        _uploadView = [[PNUploadLegalDocView alloc] initWithViewModel:self.viewModel];
        _uploadView.hidden = YES;

        @HDWeakify(self);
        _uploadView.clickButtonBlock = ^(NSMutableDictionary *_Nonnull postDict) {
            @HDStrongify(self);
            [self.viewModel submitRealNameV2WithParams:postDict successBlock:^{
                [HDMediator.sharedInstance navigaveToPayNowUpgradeAccountResultVC:@{}];
                [SACacheManager.shared removeObjectForKey:kSaveUserTempInfo type:SACacheTypeCacheNotPublic];
            }];
        };
    }
    return _uploadView;
}

- (PNConfirmNameView *)confirmNameView {
    if (!_confirmNameView) {
        _confirmNameView = [[PNConfirmNameView alloc] initWithViewModel:self.viewModel];
        _confirmNameView.hidden = YES;
    }
    return _confirmNameView;
}
@end
