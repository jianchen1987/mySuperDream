//
//  VipayUser.m
//  customer
//
//  Created by 陈剑 on 2018/7/27.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "VipayUser.h"
#import "PNCommonUtils.h"
#import "PNEnum.h"
#import "PNNotificationMacro.h"
#import "PNUtilMacro.h"
#import "SACacheManager.h"

#define kCacheKeyViPayUser @"pn_module.payuser.instance"
#define kCacheKeyLastPayNowLoginedUserName @"pn_module.user.payNowlastLoginName"


@interface VipayUser ()
/// 锁
@property (atomic, strong) NSLock *pn_sessionLock;
@property (nonatomic, strong) dispatch_queue_t pn_lockQueue;

@end

@import Firebase;

static VipayUser *_USER = NULL;
static NSLock *_sessionLock = NULL;


@implementation VipayUser
+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _USER = VipayUser.new;
    });
}
//
+ (instancetype)shareInstance {
    if (_USER.loginName.length > 0) {
        return _USER;
    }
    if (!_USER) {
        _USER = VipayUser.new;
        //        [_USER commonInit];
    };
    return _USER;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    VipayUser *user = [super allocWithZone:zone];
    [user commonInit];
    return user;
}

- (void)commonInit {
    self.pn_sessionLock = NSLock.new;
    self.pn_lockQueue = dispatch_queue_create("com.wownow.paynow.session.lock", DISPATCH_QUEUE_SERIAL);
}

- (void)save {
}

- (void)pn_lockSessionCompletion:(void (^)(void))completion {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(self.pn_lockQueue ? self.pn_lockQueue : dispatch_queue_create("com.wownow.paynow.session.lock", DISPATCH_QUEUE_SERIAL), ^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.pn_sessionLock lock];
        HDLog(@"🎆🎆🎆paynow.session.lock");
        completion();
    });
}

- (void)pn_unlockSession {
    [self.pn_sessionLock unlock];
    HDLog(@"🎆🎆🎆paynow.session.  unlock");
}

- (BOOL)pn_needUpdateMobileToken {
    if (_mobileUpdateTime && [PNCommonUtils getDiffenrenceMinByDate:_mobileUpdateTime] < 50 && [PNCommonUtils getDiffenrenceMinByDate:_mobileUpdateTime] >= 0) {
        return NO;
    } else {
        return YES;
    }
}

+ (void)loginWithModel:(HDUserRegisterRspModel *)model {
    _USER = [VipayUser new];
    _USER.loginName = model.loginName;
    _USER.userNo = model.userNo;
    _USER.sessionKey = model.sessionKey;
    _USER.mobileToken = model.mobileToken;

    _USER.accountLevel = model.accountLevel;
    _USER.accountNo = model.accountNo ? model.accountNo : @"";
    _USER.headUrl = model.headUrl ? model.headUrl : @"";
    _USER.loginName = model.loginName ? model.loginName : @"";
    _USER.nickName = model.nickName ? model.nickName : @"";
    _USER.tradePwdExist = model.tradePwdExist;
    //    _USER.authenStatus = model.authStatus;
    _USER.loginPwdExist = model.loginPwdExist;
    _USER.customerNo = model.customerNo;
    [_USER save];
}

- (void)updateByModel:(HDUserInfoRspModel *)model {
    _USER.headUrl = model.headUrl;
    _USER.accountNo = model.accountNo ? model.accountNo : @"";
    _USER.headUrl = model.headUrl ? model.headUrl : @"";
    _USER.nickName = model.nickName ? model.nickName : @"";
    _USER.accountLevel = model.accountLevel;
    _USER.tradePwdExist = model.tradePwdExist;
    _USER.loginPwdExist = model.loginPwdExist;
    _USER.invitationCode = model.invitationCode;
    _USER.billEmail = model.billEmail;
    _USER.authStatus = model.authStatus;
    _USER.upgradeStatus = model.upgradeStatus;
    _USER.upgradeMessage = model.upgradeMessage;
    _USER.birthday = model.birthday;
    _USER.firstName = model.firstName;
    _USER.lastName = model.lastName;
    _USER.upgradeDesc = model.upgradeDesc;
    _USER.cardHandUrl = model.cardHandUrl;
    _USER.country = model.country;
    _USER.cardType = model.cardType;
    _USER.cardNum = model.cardNum;
    _USER.expirationTime = model.expirationTime;
    _USER.visaExpirationTime = model.visaExpirationTime;
    _USER.idCardBackUrl = model.idCardBackUrl;
    _USER.idCardFrontUrl = model.idCardFrontUrl;
    _USER.sex = model.sex;
    _USER.customerNo = model.customerNo;

    [_USER save];
}

- (void)logout {
    _USER = VipayUser.new;
    _USER.mobileToken = @"";
    _USER.sessionKey = @"";
    _USER.loginName = @"";
    _USER.mobileToken = @"";
    _USER.merchantNo = @"";
    _USER.merchantName = @"";
    _USER.userNo = @"";
    _USER.role = 0;
    _USER.merchantMenus = @[];
    _USER.customerNo = @"";
    [_USER save];
}

+ (BOOL)isLogin {
    if (WJIsStringNotEmpty(VipayUser.shareInstance.userNo) && WJIsStringNotEmpty(VipayUser.shareInstance.loginName)) {
        return YES;
    } else {
        return NO;
    }
}

/// 钱包余额 菜单显示
+ (BOOL)hasWalletBalanceMenu {
    return [VipayUser.shareInstance checkMerchantMenusRole:PNMSMenusRoleType_WALLET_BALANCE];
}

/// 今日收款 菜单显示
+ (BOOL)hasCollectionTodayMenu {
    return [VipayUser.shareInstance checkMerchantMenusRole:PNMSMenusRoleType_COLLECTION_TODAY];
}

/// 提现 菜单显示
+ (BOOL)hasWalletWithdrawMenu {
    return [VipayUser.shareInstance checkMerchantMenusRole:PNMSMenusRoleType_WALLET_WITHDRAWAL];
}

/// 交易记录 菜单显示
+ (BOOL)hasCollectionDataQueryMenu {
    return [VipayUser.shareInstance checkMerchantMenusRole:PNMSMenusRoleType_COLLECTION_DATA_QUER];
}

/// 门店管理 菜单显示
+ (BOOL)hasStoreManagerMenu {
    return [VipayUser.shareInstance checkMerchantMenusRole:PNMSMenusRoleType_STORE_MANAGEMENTC];
}

/// 收款码 菜单显示
+ (BOOL)hasMerchantCodeQueryMenu {
    return [VipayUser.shareInstance checkMerchantMenusRole:PNMSMenusRoleType_MERCHANT_CODE_QUERY];
}

/// 操作员管理 菜单显示
+ (BOOL)hasOperatorManagerMenu {
    return [VipayUser.shareInstance checkMerchantMenusRole:PNMSMenusRoleType_OPERATOR_MANAGEMENTC];
}

/// 上传凭证 菜单显示
+ (BOOL)hasUploadVoucherMenu {
    return [VipayUser.shareInstance checkMerchantMenusRole:PNMSMenusRoleType_UPLOAD_VOUCHER];
}

/// 右上角 设置入口
+ (BOOL)hasSettingMenu {
    return [VipayUser.shareInstance checkMerchantMenusRole:PNMSMenusRoleType_Setting];
}

- (BOOL)checkMerchantMenusRole:(PNMSMenusRoleType)menusType {
    if ([self.merchantMenus containsObject:@(menusType)]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)setPermission:(NSMutableArray *)permission {
    if ([permission containsObject:@(PNMSPermissionType_WALLET_BALANCE_QUERY)]) {
        self.walletPrower = YES;
    } else {
        self.walletPrower = NO;
    }

    if ([permission containsObject:@(PNMSPermissionType_WALLET_WITHDRAWAL)]) {
        self.withdraowPower = YES;
    } else {
        self.withdraowPower = NO;
    }

    if ([permission containsObject:@(PNMSPermissionType_COLLECTION_DATA_QUERY)]) {
        self.collectionPower = YES;
    } else {
        self.collectionPower = NO;
    }

    if ([permission containsObject:@(PNMSPermissionType_STORE_MANAGEMENT)]) {
        self.storePower = YES;
    } else {
        self.storePower = NO;
    }

    if ([permission containsObject:@(PNMSPermissionType_MERCHANT_CODE_QUERY)]) {
        self.receiverCodePower = YES;
    } else {
        self.receiverCodePower = NO;
    }

    if ([permission containsObject:@(PNMSPermissionType_STORE_DATA_QUERY)]) {
        self.storeDataQueryPower = YES;
    } else {
        self.storeDataQueryPower = NO;
    }
}

- (NSMutableArray *)permission {
    NSMutableArray *arr = [NSMutableArray array];
    if (self.walletPrower) {
        [arr addObject:@(PNMSPermissionType_WALLET_BALANCE_QUERY)];
    }

    if (self.withdraowPower) {
        [arr addObject:@(PNMSPermissionType_WALLET_WITHDRAWAL)];
    }

    if (self.collectionPower) {
        [arr addObject:@(PNMSPermissionType_COLLECTION_DATA_QUERY)];
    }

    if (self.storePower) {
        [arr addObject:@(PNMSPermissionType_STORE_MANAGEMENT)];
    }

    if (self.receiverCodePower) {
        [arr addObject:@(PNMSPermissionType_MERCHANT_CODE_QUERY)];
    }

    if (self.storeDataQueryPower) {
        [arr addObject:@(PNMSPermissionType_STORE_DATA_QUERY)];
    }

    return arr;
}

/// 钱包明细列表 入口
+ (BOOL)hasWalletOrder {
    return [self searchWalletListItemType:PNWalletListItemTypeWALLET_DETAILS];
}

/// 交易记录 入口
+ (BOOL)hasWalletTransferList {
    return [self searchWalletListItemType:PNWalletListItemTypeWALLET_TRANSACTIONS];
}

+ (BOOL)searchWalletListItemType:(PNWalletListItemType)bizType {
    BOOL isExist = NO;
    if (!WJIsArrayEmpty(VipayUser.shareInstance.functionModel.SETTING)) {
        PNWalletListConfigModel *settingModel = VipayUser.shareInstance.functionModel.SETTING.firstObject;
        for (PNWalletListConfigModel *model in settingModel.children) {
            if (model.bizType == bizType) {
                isExist = YES;
                break;
            }
        }
    }

    return isExist;
}

@end
