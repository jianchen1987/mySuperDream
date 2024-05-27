//
//  PNWalletViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNWalletViewModel.h"
#import "NSString+HD_Util.h"
#import "PNAcountCellModel.h"
#import "PNFunctionCellModel.h"
#import "PNInterTransferDTO.h"
#import "PNPacketMessageDTO.h"
#import "PNRspModel.h"
#import "PNUserDTO.h"
#import "PNWalletAcountModel.h"
#import "PNWalletDTO.h"
#import "PNWalletFunctionModel.h"
#import "PNWalletHomeBannerModel.h"
#import "PNWalletLevelInfoCellView.h"
#import "PNWalletListConfigModel.h"
#import "UIView+NAT.h"


@interface PNWalletViewModel ()
/// 固定的section
@property (nonatomic, strong) NSMutableArray *sectionArray;
/// 数据存储
@property (nonatomic, strong) NSMutableDictionary *dataSourceDict;

@property (nonatomic, strong) PNWalletDTO *walletDTO;
@property (nonatomic, strong) PNUserDTO *userDTO;
@property (nonatomic, strong) PNInterTransferDTO *interTransferDTO;
@property (nonatomic, strong) PNPacketMessageDTO *messageDTO;

@property (nonatomic, assign) BOOL isFirst;
@end


@implementation PNWalletViewModel

/// 获取钱包首页信息
- (void)getNewData {
    @HDWeakify(self);

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_t _sema = dispatch_semaphore_create(1);

        HDLog(@"开始调用");
        dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
        [self.userDTO getPayNowUserInfoSuccess:^(HDUserInfoRspModel *_Nonnull rspModel) {
            dispatch_semaphore_signal(_sema);
        } failure:^(PNRspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            dispatch_semaphore_signal(_sema);
        }];

        dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
        [self getPacketMessageCountCompletion:^{
            @HDStrongify(self);
            self.refreshFlag = !self.refreshFlag;
            dispatch_semaphore_signal(_sema);
        }];

        dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
        [self getWalletInfoCompletion:^{
            @HDStrongify(self);
            self.refreshFlag = !self.refreshFlag;
            dispatch_semaphore_signal(_sema);
        }];

        dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
        [self getWalletFunctionConfigCompletion:^{
            @HDStrongify(self);
            self.refreshFlag = !self.refreshFlag;
            self.settingRefreshFlag = !self.settingRefreshFlag;
            dispatch_semaphore_signal(_sema);
        }];

        dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
        [self getWalletBannerCompletion:^{
            @HDStrongify(self);
            self.refreshFlag = !self.refreshFlag;
            dispatch_semaphore_signal(_sema);
        }];

        dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
        [self getAllNoticeCompletion:^{
            @HDStrongify(self);
            self.refreshFlag = !self.refreshFlag;
            dispatch_semaphore_signal(_sema);
        }];

        if (!self.isFirst) {
            dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
            [self getMarketingInfoCompletion:^{
                dispatch_semaphore_signal(_sema);
            }];

            [self jumpRoutPath];
        }
        [self jumpRoutPath];
    });
}

/// 跳转路由
- (void)jumpRoutPath {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (WJIsStringNotEmpty(self.routPath)) {
            NSString *url = [self.routPath hd_URLDecodedString];
            NSString *url2 = [url hd_URLDecodedString];
            if ([SAWindowManager canOpenURL:url2] && [self isCanOpen:url2]) {
                HDLog(@"有需要跳转的路由");
                [SAWindowManager openUrl:url2 withParameters:@{}];
                self.routPath = @"";
            }
        }
    });
}

- (BOOL)isCanOpen:(NSString *)urlStr {
    NSURL *url = [NSURL URLWithString:[urlStr hd_URLEncodedString]];
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    HDLog(@"%@", actionName);

    /// 开红包
    if ([actionName isEqualToString:@"openPacket"] || [actionName isEqualToString:@"guaranteenRecordDetail"]) {
        return YES;
    }

    BOOL isExist = NO;
    for (SACollectionViewSectionModel *obj in self.dataSource) {
        if ([obj.hd_associatedObject isEqualToString:kBottomFunctionFlag]) {
            isExist = YES;
        }
    }

    if (!isExist) {
        HDLog(@"🐒🐒🐒 config 没数据 说明连入口都没有 不进行跳转");
        return NO;
    } else {
        BOOL isExistItem = NO;

        for (SACollectionViewSectionModel *obj in self.dataSource) {
            if ([obj.hd_associatedObject isEqualToString:kBottomFunctionFlag]) {
                NSArray *arr = obj.list;

                for (PNFunctionCellModel *itemModel in arr) {
                    if ([itemModel.actionName isEqualToString:actionName]) {
                        isExistItem = YES;
                        break;
                    }
                }
            }
        }

        if (isExistItem) {
            HDLog(@"🐱🐱🐱 发现config 里面有对应的 入口");
            return YES;
        } else {
            HDLog(@"🐦🐦🐦 发现config 里面有 没有 对应的 入口");
            return NO;
        }
    }
}

/// 获取钱包余额
- (void)getWalletInfoCompletion:(void (^)(void))completion {
    @HDWeakify(self);
    HDLog(@"开始调用 账户余额接口");
    [self.walletDTO getMyWalletInfoSuccess:^(PNWalletAcountModel *_Nonnull rspModel) {
        @HDStrongify(self);
        if (!WJIsObjectNil(rspModel)) {
            SACollectionViewSectionModel *model = SACollectionViewSectionModel.new;
            model.hd_associatedObject = kAccountFlag;
            model.list = @[rspModel];
            [self.dataSourceDict setValue:model forKey:kAccountFlag];
        } else {
            [self.dataSourceDict removeObjectForKey:kAccountFlag];
        }

        !completion ?: completion();
    } failure:^(PNRspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        [self.dataSourceDict removeObjectForKey:kAccountFlag];
        !completion ?: completion();
    }];
}

/// 获取用户信息
- (void)getUserInfoCompletion:(void (^)(void))completion {
    HDLog(@"开始调用 用户信息接口");
    [self.userDTO getPayNowUserInfoSuccess:^(HDUserInfoRspModel *_Nonnull rspModel) {
        !completion ?: completion();
    } failure:^(PNRspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion();
    }];
}

/// 获取APP钱包的功能配置
- (void)getWalletFunctionConfigCompletion:(void (^)(void))completion {
    @HDWeakify(self);
    [self.walletDTO getAllWalletFunctionConfig:^(PNWalletFunctionModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self changeModel:rspModel];
        VipayUser.shareInstance.functionModel = rspModel;
        !completion ?: completion();
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        !completion ?: completion();
    }];
}

/// 获取营销广告 - 弹窗
- (void)getMarketingInfoCompletion:(void (^)(void))completion {
    self.isFirst = YES;
    PNUserLevel level = VipayUser.shareInstance.accountLevel;
    PNAccountLevelUpgradeStatus status = VipayUser.shareInstance.upgradeStatus;
    if ((level == PNUserLevelNormal || level == PNUserLevelAdvanced)
        && (status != PNAccountLevelUpgradeStatus_INTERMEDIATE_UPGRADEING && status != PNAccountLevelUpgradeStatus_SENIOR_UPGRADING && status != PNAccountLevelUpgradeStatus_APPROVALING)) {
        [self.walletDTO getWalletMarketingInfo:^(NSString *_Nonnull showMsg) {
            if (WJIsStringNotEmpty(showMsg)) {
                [NAT showAlertWithMessage:showMsg confirmButtonTitle:PNLocalizedString(@"Go_to_upgrade", @"去升级")
                    confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        [alertView dismiss];
                        PNAccountLevelUpgradeStatus upgradeStatus = VipayUser.shareInstance.upgradeStatus;

                        if (upgradeStatus == PNAccountLevelUpgradeStatus_GoToUpgrade) {
                            [HDMediator.sharedInstance navigaveToPayNowUpgradeAccountVC:@{@"needCall": @(YES)}];
                        } else {
                            [HDMediator.sharedInstance navigaveToPayNowUpgradeAccountResultVC:@{}];
                        }
                    }
                    cancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        [alertView dismiss];
                    }];
            }
            !completion ?: completion();
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            !completion ?: completion();
        }];
    } else {
        !completion ?: completion();
    }
}

/// 获取banner 广告
- (void)getWalletBannerCompletion:(void (^)(void))completion {
    HDLog(@"开始调用 列表配置接口");
    @HDWeakify(self);
    [self.interTransferDTO getWalletHomeBanner:^(NSArray<PNWalletHomeBannerModel *> *_Nonnull array) {
        @HDStrongify(self);
        if (!HDIsArrayEmpty(array)) {
            SACollectionViewSectionModel *model = SACollectionViewSectionModel.new;
            model.hd_associatedObject = kBannerFlag;
            model.list = array;
            [self.dataSourceDict setValue:model forKey:kBannerFlag];
        } else {
            [self.dataSourceDict removeObjectForKey:kBannerFlag];
        }
        !completion ?: completion();
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        [self.dataSourceDict removeObjectForKey:kBannerFlag];
        !completion ?: completion();
    }];
}

/// 获取未领取红包总数
- (void)getPacketMessageCountCompletion:(void (^)(void))completion {
    [self.messageDTO getPacketMessageCount:^(NSInteger count) {
        self.packetMessageCount = count;
        !completion ?: completion();
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        !completion ?: completion();
    }];
}

/// 获取所有公告
- (void)getAllNoticeCompletion:(void (^)(void))completion {
    [self.userDTO getAllNoticeSuccess:^(PNRspModel *_Nonnull rspModel) {
        if ([rspModel.data isKindOfClass:NSDictionary.class]) {
            NSDictionary *data = rspModel.data;
            if (!WJIsObjectNil(data)) {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:data forKey:kPNAllNotice];
                [defaults synchronize];
            }
        } else {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults removeObjectForKey:kPNAllNotice];
            [defaults synchronize];
        }
        !completion ?: completion();
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        !completion ?: completion();
    }];
}

#pragma mark
/// 重置数据源
- (void)resetDataSource {
    /// 重置一些数据源
    [self.dataSource removeAllObjects];

    [self addDefaultModel];

    ///
    for (int i = 0; i < self.sectionArray.count; i++) {
        NSString *key = [self.sectionArray objectAtIndex:i];
        SACollectionViewSectionModel *model = [self.dataSourceDict valueForKey:key];
        if (!WJIsObjectNil(model)) {
            [self.dataSource addObject:model];
        }
    }
}

- (void)addDefaultModel {
    /// 添加默认的这个info
    SACollectionViewSectionModel *model = SACollectionViewSectionModel.new;
    model.hd_associatedObject = kLevelInfoFlag;
    PNWalletLevelInfoViewCellModel *levelInfoCellModel = [[PNWalletLevelInfoViewCellModel alloc] init];
    model.list = @[levelInfoCellModel];

    [self.dataSourceDict setValue:model forKey:kLevelInfoFlag];
}

/// 转换一下model
- (void)changeModel:(PNWalletFunctionModel *)rspModel {
    SACollectionViewSectionModel *model = SACollectionViewSectionModel.new;
    model.hd_associatedObject = kTopFunctionFlag;
    NSMutableArray *functionCellModelArr = [NSMutableArray array];
    for (PNWalletListConfigModel *obj in rspModel.RIBBON) {
        PNFunctionCellModel *cellModel = [PNFunctionCellModel getModelWithWalletConfigModel:obj];
        [functionCellModelArr addObject:cellModel];
    }
    model.list = functionCellModelArr;
    [self.dataSourceDict setValue:model forKey:kTopFunctionFlag];

    model = SACollectionViewSectionModel.new;
    model.hd_associatedObject = kBottomFunctionFlag;
    functionCellModelArr = [NSMutableArray array];
    for (PNWalletListConfigModel *obj in rspModel.ENTRANCE) {
        PNFunctionCellModel *cellModel = [PNFunctionCellModel getModelWithWalletConfigModel:obj];
        ///额外赋值
        if ([cellModel.actionName isEqualToString:@"luckPacketHome"]) {
            cellModel.count = self.packetMessageCount;
        }
        [functionCellModelArr addObject:cellModel];
    }
    model.list = functionCellModelArr;
    [self.dataSourceDict setValue:model forKey:kBottomFunctionFlag];
}

#pragma mark
- (PNWalletDTO *)walletDTO {
    if (!_walletDTO) {
        _walletDTO = [[PNWalletDTO alloc] init];
    }
    return _walletDTO;
}

- (PNUserDTO *)userDTO {
    if (!_userDTO) {
        _userDTO = [[PNUserDTO alloc] init];
    }
    return _userDTO;
}

- (PNInterTransferDTO *)interTransferDTO {
    if (!_interTransferDTO) {
        _interTransferDTO = [[PNInterTransferDTO alloc] init];
    }
    return _interTransferDTO;
}

- (NSMutableArray<SACollectionViewSectionModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:self.sectionArray.count];
    }
    return _dataSource;
}

- (PNPacketMessageDTO *)messageDTO {
    if (!_messageDTO) {
        _messageDTO = [[PNPacketMessageDTO alloc] init];
    }
    return _messageDTO;
}

- (NSMutableArray *)sectionArray {
    if (!_sectionArray) {
        NSMutableArray *arr = [NSMutableArray array];

        [arr addObject:kLevelInfoFlag];
        [arr addObject:kTopFunctionFlag];
        [arr addObject:kAccountFlag];
        [arr addObject:kBottomFunctionFlag];
        [arr addObject:kBannerFlag];

        _sectionArray = arr;
    }
    return _sectionArray;
}

- (NSMutableDictionary *)dataSourceDict {
    if (!_dataSourceDict) {
        _dataSourceDict = [NSMutableDictionary dictionaryWithCapacity:self.sectionArray.count];
    }
    return _dataSourceDict;
}

@end
