//
//  GNStorePhotoViewController.m
//  SuperApp
//
//  Created by wmz on 2022/6/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNStorePhotoViewController.h"
#import "GNStoreDetailViewModel.h"
#import "GNStorePhotoView.h"
#import "WMZPageView.h"


@interface GNStorePhotoViewController ()
/// pageView
@property (nonatomic, strong) WMZPageView *pageView;
/// viewModel
@property (nonatomic, strong) GNStoreDetailViewModel *viewModel;

@end


@implementation GNStorePhotoViewController

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    if (self = [super initWithViewModel:viewModel]) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)hd_setupViews {
    self.boldTitle = GNLocalizedString(@"gn_merchant_album", @"商家相册");
    @HDWeakify(self) WMZPageParam *param = PageParam();
    param.wMenuTitleWidthSet(kScreenWidth / 4.0);
    param.wMenuAnimalSet(PageTitleMenuPDD);
    param.wMenuIndicatorYSet(2);
    param.wMenuTitleSelectColorSet(HDAppTheme.color.gn_333Color);
    param.wMenuHeightSet(kRealWidth(44));
    if (SAMultiLanguageManager.isCurrentLanguageCN) {
        param.wMenuTitleUIFont = [HDAppTheme.font gn_ForSize:16 weight:UIFontWeightMedium];
        ;
        param.wMenuTitleSelectUIFont = [HDAppTheme.font gn_boldForSize:16];
    } else {
        param.wMenuTitleUIFont = [HDAppTheme.font gn_ForSize:14 weight:UIFontWeightMedium];
        ;
        param.wMenuTitleSelectUIFont = [HDAppTheme.font gn_boldForSize:14];
    }
    param.wMenuIndicatorWidthSet(kRealWidth(44));
    param.wMenuIndicatorHeightSet(kRealWidth(4));
    param.wMenuIndicatorRadioSet(0);
    param.wTitleArrSet(@[
        @{
            WMZPageKeyName: GNLocalizedString(@"gn_order_all", @"全部"),
            WMZPageKeyTitleHeight: @(kRealWidth(kRealWidth(32))),
            WMZPageKeyTitleMarginY: @(SAMultiLanguageManager.isCurrentLanguageCN ? kRealWidth(12) : kRealWidth(0)),
        },
        @{
            WMZPageKeyName: GNLocalizedString(@"gn_merchant_introduction", @"商家介绍"),
            WMZPageKeyTitleHeight: @(kRealWidth(kRealWidth(32))),
            WMZPageKeyTitleMarginY: @(SAMultiLanguageManager.isCurrentLanguageCN ? kRealWidth(12) : kRealWidth(0)),
        },
        @{
            WMZPageKeyName: GNLocalizedString(@"gn_store_environment", @"店内环境"),
            WMZPageKeyTitleHeight: @(kRealWidth(kRealWidth(32))),
            WMZPageKeyTitleMarginY: @(SAMultiLanguageManager.isCurrentLanguageCN ? kRealWidth(12) : kRealWidth(0)),
        },
        @{
            WMZPageKeyName: GNLocalizedString(@"gn_store_qualification", @"商家资质"),
            WMZPageKeyTitleHeight: @(kRealWidth(kRealWidth(32))),
            WMZPageKeyTitleMarginY: @(SAMultiLanguageManager.isCurrentLanguageCN ? kRealWidth(12) : kRealWidth(0)),
        }
    ]);
    param.wViewController = ^UIViewController *_Nullable(NSInteger index) {
        @HDStrongify(self) GNStorePhotoView *view = GNStorePhotoView.new;
        if (index == 0) {
            view.dataSource = self.viewModel.detailModel.storeAllPhotoArr;
        } else if (index == 1) {
            view.dataSource = self.viewModel.detailModel.storeIntroducePhotoArr;
        } else if (index == 2) {
            view.dataSource = self.viewModel.detailModel.storeEnvironmentPhotoArr;
        } else if (index == 3) {
            view.dataSource = self.viewModel.detailModel.storeQualificationPhotoArr;
        }
        return (id)view;
    };
    self.pageView = [[WMZPageView alloc] initWithFrame:CGRectMake(0, kNavigationBarH, kScreenWidth, kScreenHeight - kNavigationBarH) autoFix:NO param:param parentReponder:self];
    [self.view addSubview:self.pageView];
}

- (BOOL)needLogin {
    return NO;
}

@end
