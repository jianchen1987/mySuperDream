//
//  WMHomeCustomViewModel.m
//  SuperApp
//
//  Created by wmz on 2022/4/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMHomeCustomViewModel.h"
#import "LKDataRecord.h"
#import "SAAddressModel.h"
#import "SACacheManager.h"
#import "WMAppVersionInfoRspModel.h"
#import "WMHomeView.h"
#import "WMVersionAlertManager.h"
#import "SAAddressCacheAdaptor.h"

@interface WMHomeCustomViewModel ()
/// cutomDTO
@property (nonatomic, strong) WMHomeCustomDTO *cutomDTO;

@end


@implementation WMHomeCustomViewModel

- (void)requestNotice {
    @HDWeakify(self);

    //    SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    ///没有地址 记录一下 等地址有了重新调用
    if (!addressModel) {
        [NSUserDefaults.standardUserDefaults setObject:@(YES) forKey:@"noneNoticeKey"];
        return;
    }

    NSString *lastKey = [NSString stringWithFormat:@"%@_%@", addressModel.state, addressModel.city];
    NSTimeInterval currentTime = NSDate.date.timeIntervalSince1970;
    NSTimeInterval oldTime = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@", @"yunnow_home_notice", lastKey]] doubleValue];
    /// 10分钟重新请求
    BOOL reRequest = NO;
    if (currentTime - oldTime >= 10 * 60) {
        reRequest = YES;
    }

    NSArray<WMHomeNoticeModel *> *list = [SACacheManager.shared objectForKey:[NSString stringWithFormat:@"%@_%@", kCacheKeyHomeNotice, lastKey] type:SACacheTypeDocumentPublic];
    ///有缓存且没有超过10分钟 取缓存
    if (list && !reRequest) {
        self.noticeArray = list;
        [self dealNoticeArray];
        return;
    }

    [self.cutomDTO queryYumNowHomeNoticeSuccess:^(NSArray<WMHomeNoticeModel *> *_Nonnull rspModel) {
        @HDStrongify(self) if ([rspModel isKindOfClass:NSArray.class] && rspModel.count) {
            ///有缓存数据
            if (list) {
                NSMutableDictionary *mdic = NSMutableDictionary.new;
                for (WMHomeNoticeModel *model in list) {
                    [mdic setObject:model forKey:model.homeNoticeNo];
                }
                for (WMHomeNoticeModel *model in rspModel) {
                    ///判断是否展示过了
                    WMHomeNoticeModel *showModel = mdic[model.homeNoticeNo];
                    if (showModel) {
                        model.showTime = showModel.showTime;
                    }
                }
            }
            self.noticeArray = rspModel;
            [self reSaveNoticeArray];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lf", NSDate.date.timeIntervalSince1970]
                                                      forKey:[NSString stringWithFormat:@"%@_%@", @"yunnow_home_notice", lastKey]];
            [self dealNoticeArray];
        }
        else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@_%@", @"yunnow_home_notice", lastKey]];
        }
    } failure:nil];
}

- (void)dealNoticeArray {
    if (![self.noticeArray isKindOfClass:NSArray.class])
        return;
    NSTimeInterval currentTime = NSDate.date.timeIntervalSince1970;
    ///取出未显示的model 优先级后端已经排好
    WMHomeNoticeModel *showModel = nil;
    for (WMHomeNoticeModel *model in self.noticeArray) {
        if (!model.showTime) {
            ///没有展示过
            showModel = model;
            break;
        } else {
            ///当前展示的未达到10秒且非手动关闭 继续展示
            if ((currentTime - model.showTime < 10) && !model.handClose) {
                ///展示过小于10秒且非手动关闭
                if ([self.view isKindOfClass:WMHomeView.class]) {
                    WMHomeView *homeView = (WMHomeView *)self.view;
                    ///当前正在显示
                    if (homeView.noticeView.isShow && [homeView.noticeView.model.homeNoticeNo isEqualToString:model.homeNoticeNo]) {
                        return;
                    } else {
                        ///当前不在显示
                        showModel = model;
                        break;
                    }
                }
            }
        }
    }

    ///如果都展示过了 判断频率
    if (!showModel) {
        for (WMHomeNoticeModel *model in self.noticeArray) {
            ///一天一次
            if ([model.frequency isEqualToString:WMHomeNoticeFrequencyTypeDaily]) {
                ///一天显示一次
                if ((currentTime - model.showTime) >= 24 * 60 * 60) {
                    showModel = model;
                    showModel.handClose = NO;
                    showModel.daily = YES;
                    showModel.showTime = NSDate.date.timeIntervalSince1970;
                    break;
                }
            }
        }
    }

    ///没有需要显示的
    if (!showModel)
        return;

    if (!showModel.showTime || showModel.daily) {
        [LKDataRecord.shared traceEvent:@"browserHomeNotice" name:@"browserHomeNotice" parameters:@{
            @"homeNoticeNo": showModel.homeNoticeNo,
            @"phone": SAUser.shared.loginName,
            @"userName": SAUser.shared.operatorNo,
        }
                                    SPM:[LKSPM SPMWithPage:@"WMHomeViewController" area:@"" node:@""]];
    }
    ///记录model
    self.noticeModel = showModel;
    ///记录显示时间
    if (!showModel.showTime) {
        showModel.showTime = NSDate.date.timeIntervalSince1970;
    }
    ///重新缓存
    [self reSaveNoticeArray];
}

- (void)reSaveNoticeArray {
    //    SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    if (!addressModel)
        return;
    if (HDIsArrayEmpty(self.noticeArray))
        return;
    NSString *lastKey = [NSString stringWithFormat:@"%@_%@", addressModel.state, addressModel.city];
    [SACacheManager.shared setObject:self.noticeArray forKey:[NSString stringWithFormat:@"%@_%@", kCacheKeyHomeNotice, lastKey] type:SACacheTypeDocumentPublic];
}

- (void)versionUpdate {
    @HDWeakify(self) CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/get-laster-app-version-tips";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    if ([SAUser hasSignedIn]) {
        request.requestParameter = @{@"operatorNo": [SAUser.shared operatorNo]};
    }
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self) SARspModel *rspModel = response.extraData;
        WMAppVersionInfoRspModel *infoRspModel = [WMAppVersionInfoRspModel yy_modelWithJSON:rspModel.data];
        if (!HDIsStringEmpty(infoRspModel.publicVersion)) {
            SAVersionAlertViewConfig *config = SAVersionAlertViewConfig.new;
            config.versionId = @(infoRspModel.id).stringValue;
            config.updateInfo = infoRspModel.descriptionStr;
            config.updateVersion = infoRspModel.publicVersion;
            config.packageLink = infoRspModel.packageLink;
            if (infoRspModel.updateMethod == 20) {
                ///适配外卖的版本更新 否则按照中台的需求取消按钮不展示
                config.updateModel = SAVersionUpdateModelCommon;
                config.ignoreCache = YES;
            } else if (infoRspModel.updateMethod == 30) {
                config.updateModel = SAVersionUpdateModelCommon;
            } else if (infoRspModel.updateMethod == 40) {
                config.updateModel = SAVersionUpdateModelBeta;
            }

            if ([WMVersionAlertManager versionShouldAlert:config]) {
                SAVersionBaseAlertView *alertView = [SAVersionAlertManager alertViewWithConfig:config];
                alertView.didDismissHandler = ^(HDActionAlertView *_Nonnull alertView) {
                    ///强制更新
                    if (infoRspModel.updateMethod == 20) {
                        [self.view.viewController dismissAnimated:YES completion:nil];
                        return;
                    }
                    if (HDIsStringEmpty(config.versionId))
                        return;
                    NSMutableArray<NSString *> *tmp = NSMutableArray.new;
                    NSArray<NSString *> *showHistory = [SACacheManager.shared objectForKey:kCacheKeyYumUserIgnoredAppVersion type:SACacheTypeDocumentPublic relyLanguage:NO];
                    if ([showHistory isKindOfClass:NSArray.class]) {
                        [tmp addObjectsFromArray:showHistory];
                    }
                    [tmp addObject:[NSString stringWithFormat:@"%@_%@_%@_%@_%@", config.versionId, config.updateVersion, config.updateInfo, config.updateModel, config.packageLink]];
                    [SACacheManager.shared setObject:tmp forKey:kCacheKeyYumUserIgnoredAppVersion type:SACacheTypeDocumentPublic relyLanguage:NO];
                };
                [alertView show];
            }
        }
    } failure:nil];
}

- (WMHomeCustomDTO *)cutomDTO {
    if (!_cutomDTO) {
        _cutomDTO = WMHomeCustomDTO.new;
    }
    return _cutomDTO;
}

@end
