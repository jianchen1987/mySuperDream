//
//  CMSTestViewController.m
//  SuperApp
//
//  Created by Chaos on 2021/6/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSTestViewController.h"
#import "SACMSCacheKeyConst.h"
#import "SACMSManager.h"
#import "SAHomeMenuGroundView.h"

#define kCMSPageWidth (kScreenWidth)


@interface CMSTestViewController () <SACMSPageViewDelegate>

@property (nonatomic, copy) NSString *pageIdentify;
/// cmsPage
@property (nonatomic, strong) SACMSPageView *pageView;
/// 头部菜单
@property (nonatomic, strong) SAHomeMenuGroundView *menuGroundView;
/// 列表容器
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIImageView *bgView;

@end


@implementation CMSTestViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    self.pageIdentify = parameters[@"pageLable"] ?: CMSPageIdentifyWownowHome;

    return self;
}

- (BOOL)allowContinuousBePushed {
    return true;
}

- (void)hd_setupViews {
    self.miniumGetNewDataDuration = -2;
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.container];
    [self.view addSubview:self.menuGroundView];
}

- (void)hd_getNewData {
    SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCMSCacheKeyChooseAddress type:SACacheTypeDocumentPublic];
    [self showloading];
    @HDWeakify(self);
    [SACMSManager getPageWithAddress:addressModel identify:self.pageIdentify pageWidth:kCMSPageWidth operatorNo:[SAUser hasSignedIn] ? SAUser.shared.operatorNo : @""
        success:^(SACMSPageView *_Nonnull page, SACMSPageViewConfig *_Nonnull config) {
            @HDStrongify(self);
            [self dismissLoading];
            self.pageView = page;
            self.pageView.delegate = self;
            [self.container addSubview:self.pageView];
            [self.view setNeedsUpdateConstraints];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self dismissLoading];
        }];
}

- (void)updateViewConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self.menuGroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
    }];

    [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.menuGroundView.mas_bottom);
    }];

    if (!HDIsObjectNil(self.pageView)) {
        [self.pageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.top.equalTo(self.container);
            make.width.mas_equalTo(kCMSPageWidth);
        }];
    }

    [super updateViewConstraints];
}

#pragma mark - SACMSPageViewDelegate
- (void)didClickedOnPageView:(SACMSPageView *)pageView cardView:(SACMSCardView *)cardView node:(SACMSNode *)node link:(NSString *)link spm:(nonnull NSString *)spm {
    if (HDIsStringEmpty(link)) {
        return;
    }
    if ([SAWindowManager canOpenURL:link]) {
        [SAWindowManager openUrl:link withParameters:nil];
    }
    HDLog(@"spm:%@", spm);
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleTransparent;
}

#pragma mark - lazy load
- (SAHomeMenuGroundView *)menuGroundView {
    if (!_menuGroundView) {
        _menuGroundView = SAHomeMenuGroundView.new;
    }
    return _menuGroundView;
}

- (UIView *)container {
    if (!_container) {
        _container = UIView.new;
        _container.backgroundColor = UIColor.whiteColor;
        _container.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:10];
        };
    }
    return _container;
}
- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        _bgView.image = [UIImage imageNamed:@"StartImage2"];
    }
    return _bgView;
}
@end
