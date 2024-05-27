//
//  WMMineViewModel.m
//  SuperApp
//
//  Created by VanJay on 2020/3/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMMineViewModel.h"
#import "SAAppVersionViewModel.h"
#import "SAChangeLanguageViewPresenter.h"
#import "SACouponTicketDTO.h"
#import "SAInfoViewModel.h"
#import "SAUserViewModel.h"
#import "SAWindowManager.h"
#import "WMMineAdvertisementModel.h"
#import <HDUIKit/HDAppTheme.h>
#import <HDUIKit/HDTableViewSectionModel.h>

#define kSectionContentEdgeInsets UIEdgeInsetsMake(kRealWidth(15), kRealWidth(15), kRealWidth(15), kRealWidth(15))


@interface WMMineViewModel ()
@property (nonatomic, strong) NSMutableArray<HDTableViewSectionModel *> *dataSource;
/// 优惠信息
@property (nonatomic, strong) HDTableViewSectionModel *couponInfoSectionModel;
/// 广告信息
@property (nonatomic, strong) HDTableViewSectionModel *advertisementSectionModel;
/// 帮助信息
@property (nonatomic, strong) HDTableViewSectionModel *helpSectionMdoel;
/// 入驻信息
@property (nonatomic, strong) HDTableViewSectionModel *settleSectionModel;
/// 用户信息
@property (nonatomic, strong) SAGetUserInfoRspModel *userInfoRspModel;
/// 队列组
@property (nonatomic, strong) dispatch_group_t taskGroup;
/// app 版本 VM
@property (nonatomic, strong) SAAppVersionViewModel *appVersionViewModel;
/// 用户 VM
@property (nonatomic, strong) SAUserViewModel *userViewModel;
/// 优惠券 DTO
@property (nonatomic, strong) SACouponTicketDTO *couponTicketDTO;
/// faq
@property (nonatomic, strong) SAInfoViewModel *faqInfoViewModel;

@end


@implementation WMMineViewModel
- (void)hd_initialize {
}

- (void)getCouponInfoAndUserInfoCompletion:(void (^)(void))finish {
    @HDWeakify(self);

    dispatch_group_enter(self.taskGroup);
    [self.couponTicketDTO getCouponInfoWithBusinessLine:SAMarketingBusinessTypeYumNow success:^(SACouponInfoRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self updateCouponInfoSectionModel:rspModel];
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];

    dispatch_group_enter(self.taskGroup);
    [self.userViewModel getUserInfoWithOperatorNo:SAUser.shared.operatorNo success:^(SAGetUserInfoRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [SAUser.shared saveWithUserInfo:rspModel];

        self.userInfoRspModel = rspModel;
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];

    dispatch_group_enter(self.taskGroup);
    [self.faqViewModel yumNowQueryGuideLinkWithKey:@"index" block:^(WMFAQRspModel *_Nonnull rspModel) {
        if (rspModel && rspModel.code) {
            if ([self.helpSectionMdoel.list indexOfObject:self.faqInfoViewModel] == NSNotFound) {
                NSMutableArray *marr = [NSMutableArray arrayWithArray:self.helpSectionMdoel.list];
                [marr addObject:self.faqInfoViewModel];
                self.helpSectionMdoel.list = marr;
            }
        } else {
            if ([self.helpSectionMdoel.list indexOfObject:self.faqInfoViewModel] != NSNotFound) {
                NSMutableArray *marr = [NSMutableArray arrayWithArray:self.helpSectionMdoel.list];
                [marr removeObject:self.faqInfoViewModel];
                self.helpSectionMdoel.list = marr;
            }
        }
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];

    dispatch_group_notify(self.taskGroup, dispatch_get_main_queue(), ^() {
        HDLog(@"“我的”页面全部数据获取完成，刷新界面");
        !finish ?: finish();
    });
}

- (void)handleLanguageDidChanged {
    self.refreshFlag = !self.refreshFlag;
}

- (void)clearDataSource {
    [self.dataSource removeAllObjects];
    self.dataSource = nil;
    self.couponInfoSectionModel = nil;

    // 获取原来的 value
    SAInfoViewModel *infoModel = self.couponInfoSectionModel.list.firstObject;
    if (SAUser.hasSignedIn) {
        // 恢复
        NSString *oldInfoModelValueText = infoModel.valueText;
        infoModel = self.couponInfoSectionModel.list.firstObject;
        infoModel.valueText = oldInfoModelValueText;
    }
}

#pragma mark - private methods
- (void)updateCouponInfoSectionModel:(SACouponInfoRspModel *)rspModel {
    SAInfoViewModel *infoModel = self.couponInfoSectionModel.list.firstObject;
    if (infoModel && [infoModel isKindOfClass:SAInfoViewModel.class]) {
        infoModel.valueText = [NSString stringWithFormat:@"%@", rspModel.cashCouponAmount];
        NSMutableArray *arrayCopy = self.couponInfoSectionModel.list.mutableCopy;
        [arrayCopy replaceObjectAtIndex:0 withObject:infoModel];
        self.couponInfoSectionModel.list = arrayCopy;
    }
}

#pragma mark - lazy load
- (NSMutableArray<HDTableViewSectionModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        [_dataSource addObjectsFromArray:@[self.advertisementSectionModel, self.couponInfoSectionModel, self.helpSectionMdoel, self.settleSectionModel]];
    }
    return _dataSource;
}

- (HDTableViewSectionModel *)couponInfoSectionModel {
    if (!_couponInfoSectionModel) {
        HDTableViewSectionModel *sectionModel = [[HDTableViewSectionModel alloc] init];
        SAInfoViewModel *model = [[SAInfoViewModel alloc] init];
        model.leftImage = [UIImage imageNamed:@"icon-coupon-waimai"];
        model.keyText = WMLocalizedString(@"my_coupons", @"我的优惠券");
        model.valueColor = HDAppTheme.color.G1;
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [SAWindowManager openUrl:@"SuperApp://SuperApp/businessCouponList?businessLine=YumNow&showFilterBar=1&couponState=11" withParameters:@{
                @"source" : HDIsStringNotEmpty(self.source) ? [self.source stringByAppendingString:@"|外卖我的页"] : @"外卖我的页",
                @"associatedId" : self.associatedId
            }];
        };
        model.rightButtonImage = [UIImage imageNamed:@"black_arrow"];
        model.valueText = @"0";
        model.contentEdgeInsets = kSectionContentEdgeInsets;

        SAInfoViewModel *evaluationModel = [[SAInfoViewModel alloc] init];
        evaluationModel.leftImage = [UIImage imageNamed:@"icon-evaluation-waimai"];
        evaluationModel.keyText = WMLocalizedString(@"my_reviews", @"我的评价");
        evaluationModel.eventHandler = ^{
            @HDStrongify(self);
            [HDMediator.sharedInstance navigaveToMyReviewsViewController:@{
                @"source" : HDIsStringNotEmpty(self.source) ? [self.source stringByAppendingString:@"|外卖我的页"] : @"外卖我的页",
                @"associatedId" : self.associatedId
            }];
        };
        evaluationModel.rightButtonImage = [UIImage imageNamed:@"black_arrow"];
        evaluationModel.contentEdgeInsets = kSectionContentEdgeInsets;

        SAInfoViewModel *favoriteModel = [[SAInfoViewModel alloc] init];
        favoriteModel.leftImage = [UIImage imageNamed:@"icon-favorite-waimai"];
        favoriteModel.keyText = WMLocalizedString(@"my_collection", @"我的收藏");
        favoriteModel.eventHandler = ^{
            @HDStrongify(self);
            [HDMediator.sharedInstance navigaveToStoreFavoriteViewController:@{
                @"source" : HDIsStringNotEmpty(self.source) ? [self.source stringByAppendingString:@"|外卖我的页"] : @"外卖我的页",
                @"associatedId" : self.associatedId
            }];
        };
        favoriteModel.rightButtonImage = [UIImage imageNamed:@"black_arrow"];

        sectionModel.list = @[model, evaluationModel, favoriteModel];
        _couponInfoSectionModel = sectionModel;
    }
    return _couponInfoSectionModel;
}

- (HDTableViewSectionModel *)advertisementSectionModel {
    if (!_advertisementSectionModel) {
        _advertisementSectionModel = [[HDTableViewSectionModel alloc] init];
    }
    return _advertisementSectionModel;
}

- (HDTableViewSectionModel *)helpSectionMdoel {
    if (!_helpSectionMdoel) {
        _helpSectionMdoel = [[HDTableViewSectionModel alloc] init];
        SAInfoViewModel *model = [[SAInfoViewModel alloc] init];

        NSMutableArray<SAInfoViewModel *> *sectionList = [NSMutableArray array];
        UIImage *arrowImage = [UIImage imageNamed:@"black_arrow"];

        sectionList = [NSMutableArray array];

        model = [[SAInfoViewModel alloc] init];
        model.leftImage = [UIImage imageNamed:@"icon-address-waimai"];
        model.keyText = WMLocalizedString(@"shopping_address", @"收货地址");
        model.eventHandler = ^{
            [HDMediator.sharedInstance navigaveToShoppingAddressViewController:nil];
        };
        model.rightButtonImage = arrowImage;
        model.contentEdgeInsets = kSectionContentEdgeInsets;
        [sectionList addObject:model];

        model = [[SAInfoViewModel alloc] init];
        model.leftImage = [UIImage imageNamed:@"icon-helpCenter-waimai"];
        model.keyText = WMLocalizedString(@"help_center", @"帮助中心");
        model.eventHandler = ^{
            [HDMediator.sharedInstance navigaveToWebViewViewController:@{@"path": @"/mobile-h5/super/app/user/v1/help-center?isWowNow=1"}];
        };
        model.rightButtonImage = arrowImage;
        model.contentEdgeInsets = kSectionContentEdgeInsets;
        [sectionList addObject:model];

        _helpSectionMdoel.list = sectionList;
    }
    return _helpSectionMdoel;
}

- (HDTableViewSectionModel *)settleSectionModel {
    if (!_settleSectionModel) {
        _settleSectionModel = [[HDTableViewSectionModel alloc] init];
        SAInfoViewModel *model = [[SAInfoViewModel alloc] init];

        NSMutableArray<SAInfoViewModel *> *sectionList = [NSMutableArray array];
        UIImage *arrowImage = [UIImage imageNamed:@"black_arrow"];

        sectionList = [NSMutableArray array];

        model = [[SAInfoViewModel alloc] init];
        model.leftImage = [UIImage imageNamed:@"icon_push_waimai"];
        model.keyText = WMLocalizedString(@"wm_merchant_registration", @"外卖商家入驻");
        model.eventHandler = ^{
            [HDMediator.sharedInstance navigaveToWebViewViewController:@{@"path": @"/mobile-h5/marketing/merchant-settlement?settledFrom=A001"}];
        };
        model.rightButtonImage = arrowImage;
        model.contentEdgeInsets = kSectionContentEdgeInsets;
        [sectionList addObject:model];

        _settleSectionModel.list = sectionList;
    }
    return _settleSectionModel;
}

- (SAAppVersionViewModel *)appVersionViewModel {
    return _appVersionViewModel ?: ({ _appVersionViewModel = SAAppVersionViewModel.new; });
}

- (SAUserViewModel *)userViewModel {
    return _userViewModel ?: ({ _userViewModel = SAUserViewModel.new; });
}

- (dispatch_group_t)taskGroup {
    return _taskGroup ?: ({ _taskGroup = dispatch_group_create(); });
}

- (SACouponTicketDTO *)couponTicketDTO {
    if (!_couponTicketDTO) {
        _couponTicketDTO = SACouponTicketDTO.new;
    }
    return _couponTicketDTO;
}

- (WMFAQViewModel *)faqViewModel {
    if (!_faqViewModel) {
        _faqViewModel = WMFAQViewModel.new;
    }
    return _faqViewModel;
}

- (SAInfoViewModel *)faqInfoViewModel {
    if (!_faqInfoViewModel) {
        UIImage *arrowImage = [UIImage imageNamed:@"black_arrow"];
        SAInfoViewModel *model = [[SAInfoViewModel alloc] init];
        model.leftImage = [UIImage imageNamed:@"wm_faq_icon"];
        model.keyText = WMLocalizedString(@"wm_guide_user", @"新手指引");
        @HDWeakify(self) model.eventHandler = ^{
            @HDStrongify(self)[HDMediator.sharedInstance navigaveToFAQViewController:@{@"viewModel": self.faqViewModel}];
        };
        model.rightButtonImage = arrowImage;
        model.contentEdgeInsets = kSectionContentEdgeInsets;
        _faqInfoViewModel = model;
    }
    return _faqInfoViewModel;
}

@end
