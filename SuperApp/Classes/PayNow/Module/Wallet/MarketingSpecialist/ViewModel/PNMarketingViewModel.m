//
//  PNMarketingViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2023/4/24.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNMarketingViewModel.h"
#import "PNMarketingDTO.h"
#import "PNRspModel.h"
#import "VipayUser.h"


@interface PNMarketingViewModel ()
@property (nonatomic, strong) PNMarketingDTO *marketingDTO;
@end


@implementation PNMarketingViewModel

- (void)getCoolCashAccountName {
    [self.view showloading];

    @HDWeakify(self);
    [self.marketingDTO getCCAmountWithMobile:self.accountPhoneNumber success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        HDLog(@"%@", rspModel.data);
        if ([rspModel.data isKindOfClass:NSDictionary.class]) {
            NSString *firstName = [rspModel.data objectForKey:@"name"] ?: @"";
            NSString *lastName = [rspModel.data objectForKey:@"surname"] ?: @"";
            self.accountName = [NSString stringWithFormat:@"%@ %@", lastName, firstName];
            self.isSuccess = YES;
        } else {
            self.accountName = @"";
        }
        self.refreshFlag = !self.refreshFlag;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.accountName = @"";
        self.refreshFlag = !self.refreshFlag;
    }];
}

- (void)bindMarketing {
    [self.view showloading];

    NSString *phoneNumber = [NSString stringWithFormat:@"8550%@", self.accountPhoneNumber];
    @HDWeakify(self);
    [self.marketingDTO bindMarketing:VipayUser.shareInstance.loginName promoterLoginName:phoneNumber success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        [NAT showToastWithTitle:@"" content:PNLocalizedString(@"qv3Liso5", @"绑定成功") type:HDTopToastTypeSuccess];
        [self.view.viewController.navigationController popViewControllerAnimated:YES];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (PNMarketingDTO *)marketingDTO {
    if (!_marketingDTO) {
        _marketingDTO = [[PNMarketingDTO alloc] init];
    }
    return _marketingDTO;
}
@end
