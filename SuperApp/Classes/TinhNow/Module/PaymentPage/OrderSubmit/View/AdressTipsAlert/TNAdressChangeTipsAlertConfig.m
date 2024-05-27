//
//  TNAdressChangeTipsAlertConfig.m
//  SuperApp
//
//  Created by 张杰 on 2021/9/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNAdressChangeTipsAlertConfig.h"
#import "HDAppTheme+TinhNow.h"


@implementation TNAlertAction
- (instancetype)init {
    self = [super init];
    if (self) {
        self.textColor = HDAppTheme.TinhNowColor.C3;
        self.font = [HDAppTheme.TinhNowFont fontMedium:14];
        self.backgroundColor = HexColor(0xF5F6FA);
    }
    return self;
}
+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(TNAlertAction *_Nonnull))handler {
    TNAlertAction *action = [[TNAlertAction alloc] init];
    action.title = title;
    action.actionClickCallBack = handler;
    return action;
}
@end


@implementation TNAdressChangeTipsAlertConfig
+ (instancetype)configWithCheckModel:(TNRedZoneReginTipsModel *)model isJustShow:(BOOL)isJustShow {
    TNAdressChangeTipsAlertConfig *config = [[TNAdressChangeTipsAlertConfig alloc] init];
    config.title = model.tipsInfo;
    if (isJustShow) {
        config.alertType = TNAdressTipsAlertTypeConfirm;
    } else {
        if ([model.tipsCode isEqualToString:TNReginTipsCodeHasStoreArea]) {
            config.alertType = TNAdressTipsAlertTypeChooseStore;
        } else {
            config.alertType = TNAdressTipsAlertTypeDeliveryArea;
        }
    }
    config.storeNo = model.storeNo;
    config.storeName = model.storeName;
    config.deliveryArea = model.deliveryArea;
    config.storeLocation = model.storeAddress;
    return config;
}

@end
