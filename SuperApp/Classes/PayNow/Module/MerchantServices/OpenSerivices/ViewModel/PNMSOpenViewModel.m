//
//  PNMSOpenViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/5/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSOpenViewModel.h"
#import "HDMediator+PayNow.h"
#import "PNMSOpenDTO.h"
#import "PNUserDTO.h"


@interface PNMSOpenViewModel ()
@property (nonatomic, strong) PNMSOpenDTO *openDTO;
@property (nonatomic, strong) PNUserDTO *userDTO;
@end


@implementation PNMSOpenViewModel

/// 获取数据 【经营品类 + 数据回填】
- (void)getData {
    dispatch_group_t taskGroup = dispatch_group_create();
    @HDWeakify(self);

    [self.view showloading];

    dispatch_group_enter(taskGroup);
    /// 获取经营品类数据
    [self.openDTO getCategory:^(PNMSCategoryRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.categoryRspModel = rspModel;
        dispatch_group_leave(taskGroup);
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        dispatch_group_leave(taskGroup);
    }];

    if (WJIsStringNotEmpty(self.merchantNo)) {
        dispatch_group_enter(taskGroup);

        @HDWeakify(self);
        [self.openDTO getMMSApplyDetailsWithMerchantNo:self.merchantNo success:^(PNMSOpenModel *_Nonnull rspModel) {
            @HDStrongify(self);
            self.model = rspModel;
            dispatch_group_leave(taskGroup);
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            dispatch_group_leave(taskGroup);
        }];
    }

    dispatch_group_notify(taskGroup, dispatch_get_global_queue(0, 0), ^{
        @HDStrongify(self);
        self.refreshFlag = !self.refreshFlag;
        [self.view dismissLoading];
    });
}

- (void)getCategory {
}

/// 获取上次填写数据
- (void)getMSApplyDetails {
}

- (void)sumitApplyOpenMerchantServices {
    [self.view showloading];

    ///不传 市、区
    self.model.area = @"";
    self.model.city = @"";
    NSDictionary *dict = [self.model yy_modelToJSONObject];
    HDLog(@"%@", dict);
    HDLog(@"---------------");
    HDLog(@"%@", [self.model yy_modelToJSONString]);

    @HDWeakify(self);
    [self.openDTO openMerchantServices:dict merchantNo:self.merchantNo success:^(PNMSCategoryRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];

        NSMutableArray<UIViewController *> *controllers = [[NSMutableArray alloc] initWithArray:self.view.viewController.navigationController.viewControllers];
        [controllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIViewController *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            /// 反着来寻找到 钱包主页
            if ([obj isMemberOfClass:NSClassFromString(@"PNWalletController")]) {
                *stop = YES;
            } else {
                [controllers removeObject:obj];
            }
        }];
        self.view.viewController.navigationController.viewControllers = [NSArray arrayWithArray:controllers];

        [HDMediator.sharedInstance navigaveToPayNowMerchantServicesOpenResultVC:@{}];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

#pragma mark
- (PNMSOpenDTO *)openDTO {
    return _openDTO ?: ({ _openDTO = PNMSOpenDTO.new; });
}

- (PNUserDTO *)userDTO {
    if (!_userDTO) {
        _userDTO = [[PNUserDTO alloc] init];
    }
    return _userDTO;
}
@end
