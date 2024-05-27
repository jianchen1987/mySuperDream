//
//  SALoginFrontPageViewController.m
//  SuperApp
//
//  Created by Tia on 2022/9/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SALoginFrontPageViewController.h"
#import "LKDataRecord.h"
#import "SAAlertView.h"
#import "SAAppEnvManager.h"
#import "SAAppTheme.h"
#import "SAChangeAppEnvViewPresenter.h"
#import "SACommonConst.h"
#import "SALoginAdManager.h"
#import "SALoginBannerCollectionViewCell.h"
#import "SALoginByPasswordViewController.h"
#import "SAStartupAdVideoView.h"

#define cellMargin 0
#define sideWidth 0

static CGFloat const kPageControlDotSize = 6;


@interface SALoginFrontPageViewController () <HDCyclePagerViewDataSource, HDCyclePagerViewDelegate>
/// 关闭按钮
@property (nonatomic, strong) HDUIButton *closeBTN;
/// 背景图
@property (nonatomic, strong) UIImageView *bgView;
/// 注册按钮
@property (nonatomic, strong) SAOperationButton *registerBTN;
/// 登录按钮
@property (nonatomic, strong) SAOperationButton *loginBTN;
/// 切换环境按钮
@property (nonatomic, strong) HDUIButton *switchEnvBTN;
/// 轮播图
@property (nonatomic, strong) HDCyclePagerView *bannerView;
/// pageControl
@property (nonatomic, strong) HDPageControl *pageControl;
/// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
/// 视频广告
@property (nonatomic, strong) SAStartupAdVideoView *videoView;

@end


@implementation SALoginFrontPageViewController

- (void)hd_setupViews {
    [self.view addSubview:self.bgView];

    [self.view addSubview:self.bannerView];
    [self.view addSubview:self.pageControl];

    [self.view addSubview:self.videoView];

    [self.view addSubview:self.registerBTN];
    [self.view addSubview:self.loginBTN];

    NSDictionary *oldConfigs = [SACacheManager.shared objectForKey:kCacheKeyLoginAdConfigs type:SACacheTypeDocumentPublic relyLanguage:NO];
    if (!oldConfigs) {
        self.bannerView.hidden = true;
        self.pageControl.hidden = true;
        self.videoView.hidden = true;
    } else {
        if ([oldConfigs[@"fileType"] isEqualToString:@"picture"]) {
            self.videoView.hidden = true;

            NSDictionary *dic = oldConfigs[@"linkDic"];
            NSArray *arr = oldConfigs[@"links"];
            for (NSString *key in arr) {
                if (dic[key]) {
                    [self.dataSource addObject:dic[key]];
                }
            }
            if (self.dataSource.count) {
                self.bannerView.isInfiniteLoop = self.dataSource.count > 1;
                self.pageControl.numberOfPages = self.dataSource.count;
                [self.bannerView reloadData];
                [self.bannerView setNeedClearLayout];
            } else {
                self.bannerView.hidden = true;
                self.pageControl.hidden = true;
            }
        } else if ([oldConfigs[@"fileType"] isEqualToString:@"video"]) {
            self.bannerView.hidden = true;
            self.pageControl.hidden = true;

            NSDictionary *dic = oldConfigs[@"linkDic"];
            NSArray *arr = oldConfigs[@"links"];
            for (NSString *key in arr) {
                if (dic[key]) {
                    [self.dataSource addObject:dic[key]];
                }
            }
            if (self.dataSource.count) {
                NSString *path = self.dataSource.firstObject;
                self.videoView.contentURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", DocumentsPath, path]];
                [self.videoView startVideoPlayer];
            } else {
                self.videoView.hidden = true;
            }
        } else {
            self.bannerView.hidden = true;
            self.pageControl.hidden = true;
            self.videoView.hidden = true;
        }
    }

    [LKDataRecord.shared tracePVEvent:@"Login/Register_Page_PV" parameters:nil SPM:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.videoView.hidden) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetPlayerToPlay) name:UIApplicationWillEnterForegroundNotification object:nil];
        [self.videoView.videoPlayer.player play];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (!self.videoView.hidden) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
        [self.videoView.videoPlayer.player pause];
    }
}

- (void)hd_setupNavigation {
    self.hd_navLeftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.closeBTN]];

#if EnableDebug
    self.hd_navigationItem.titleView = self.switchEnvBTN;
#endif

    self.hd_statusBarStyle = UIStatusBarStyleDefault;
}

- (void)updateViewConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(self.bgView.mas_width).multipliedBy(self.bgView.image.size.height / self.bgView.image.size.width);
    }];

    [self.bannerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.bannerView);
        make.centerX.equalTo(self.bannerView);
        make.bottom.equalTo(self.bannerView).offset(-(kiPhoneXSeriesSafeBottomHeight + kRealWidth(8)));
        make.height.mas_equalTo(kPageControlDotSize);
    }];

    [self.videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    CGFloat margin = kRealWidth(12);

    [self.registerBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        make.height.mas_equalTo(margin * 4);
        make.bottom.equalTo(self.view).offset(-(kiPhoneXSeriesSafeBottomHeight + kRealWidth(8) + kPageControlDotSize + kRealWidth(8)));
    }];

    [self.loginBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(self.registerBTN);
        make.bottom.equalTo(self.registerBTN.mas_top).offset(-margin);
    }];

    [super updateViewConstraints];
}

#pragma mark - event
- (void)resetPlayerToPlay {
    if (!self.videoView.hidden) {
        [self.videoView.videoPlayer.player play];
    }
}

#pragma mark - override
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleTransparent;
}

#pragma mark - HDCyclePagerViewDataSource
- (NSInteger)numberOfItemsInPagerView:(HDCyclePagerView *)pageView {
    return self.dataSource.count;
}

- (UICollectionViewCell *)pagerView:(HDCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    SALoginBannerCollectionViewCell *cell = [SALoginBannerCollectionViewCell cellWithCollectionView:pagerView.collectionView forIndexPath:indexPath];
    NSString *imagePath = self.dataSource[index];
    UIImage *bannerImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@", DocumentsPath, imagePath]];
    cell.imageView.image = bannerImage;
    return cell;
}

- (HDCyclePagerViewLayout *)layoutForPagerView:(HDCyclePagerView *)pageView {
    HDCyclePagerViewLayout *layout = [[HDCyclePagerViewLayout alloc] init];
    layout.layoutType = HDCyclePagerTransformLayoutNormal;
    const CGFloat width = CGRectGetWidth(pageView.frame) - 2 * cellMargin - (pageView.isInfiniteLoop ? 2 * sideWidth : 0);
    const CGFloat height = CGRectGetHeight(pageView.frame);
    layout.itemSpacing = cellMargin;
    layout.itemSize = CGSizeMake(width, height);
    layout.sectionInset = UIEdgeInsetsMake(0, cellMargin, 0, cellMargin);
    return layout;
}

- (void)pagerView:(HDCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    [self.pageControl setCurrentPage:toIndex animate:YES];
}

#pragma mark - lazy load
- (UIImageView *)bgView {
    if (!_bgView) {
        NSString *imageName = @"login_bg_en";
        if ([SAMultiLanguageManager isCurrentLanguageCN])
            imageName = @"login_bg_cn";
        if ([SAMultiLanguageManager isCurrentLanguageKH])
            imageName = @"login_bg_kh";

        _bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        _bgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bgView;
}
- (HDUIButton *)closeBTN {
    if (!_closeBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"icon_login_close"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self.navigationController dismissAnimated:true completion:nil];
        }];
        _closeBTN = button;
    }
    return _closeBTN;
}

- (SAOperationButton *)registerBTN {
    if (!_registerBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [button applyPropertiesWithBackgroundColor:[UIColor hd_colorWithHexString:@"#FEF0F2"]];
        [button setTitleColor:HDAppTheme.color.sa_C1 forState:UIControlStateNormal];
        [button setTitle:SALocalizedString(@"login_new_userRegister", @"新用户注册") forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.font.sa_standard16H;

        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            NSMutableDictionary *params = @{@"smsCodeType": SASendSMSTypeRegister}.mutableCopy;
            [HDMediator.sharedInstance navigaveToLoginBySMSViewController:params];

            [LKDataRecord.shared traceClickEvent:@"Login/Register_Page_Register_click" parameters:nil SPM:[LKSPM SPMWithPage:@"SALoginFrontPageViewController" area:@"" node:@""]];
        }];
        _registerBTN = button;
    }
    return _registerBTN;
}

- (SAOperationButton *)loginBTN {
    if (!_loginBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:SALocalizedString(@"login_new_SignIn", @"登录") forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.font.sa_standard16H;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            SALoginByPasswordViewController *vc = SALoginByPasswordViewController.new;
            [self.navigationController pushViewController:vc animated:YES];

            [LKDataRecord.shared traceClickEvent:@"Login/Register_Page_Login_click" parameters:nil SPM:[LKSPM SPMWithPage:@"SALoginFrontPageViewController" area:@"" node:@""]];
        }];
        _loginBTN = button;
    }
    return _loginBTN;
}

- (HDUIButton *)switchEnvBTN {
    if (!_switchEnvBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.color.G1 forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        [button setTitle:SAAppEnvManager.sharedInstance.appEnvConfig.name forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.font.standard2Bold;
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [btn.window endEditing:true];
            [SAChangeAppEnvViewPresenter showChangeAppEnvViewViewWithChoosedItemHandler:^(SAAppEnvConfig *_Nullable model) {
                if (model) {
                    [btn setTitle:model.name forState:UIControlStateNormal];
                    [btn sizeToFit];
                }
            }];
        }];
        [button sizeToFit];
        _switchEnvBTN = button;
    }
    return _switchEnvBTN;
}

- (HDCyclePagerView *)bannerView {
    if (!_bannerView) {
        _bannerView = HDCyclePagerView.new;
        _bannerView.autoScrollInterval = 5.0;
        _bannerView.dataSource = self;
        _bannerView.delegate = self;
        [_bannerView registerClass:SALoginBannerCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(SALoginBannerCollectionViewCell.class)];
    }
    return _bannerView;
}

- (HDPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[HDPageControl alloc] init];
        _pageControl.currentPageIndicatorSize = CGSizeMake(kPageControlDotSize, kPageControlDotSize);
        _pageControl.pageIndicatorSize = CGSizeMake(kPageControlDotSize, kPageControlDotSize);
        _pageControl.currentPageIndicatorTintColor = UIColor.whiteColor;
        _pageControl.pageIndicatorTintColor = UIColor.whiteColor;
        _pageControl.hidesForSinglePage = true;
        _pageControl.currentPageIndicatorTintColor = HDAppTheme.color.sa_C1;
    }
    return _pageControl;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (SAStartupAdVideoView *)videoView {
    if (!_videoView) {
        _videoView = [[SAStartupAdVideoView alloc] initWithFrame:CGRectZero];
        _videoView.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _videoView.muted = true;
        @HDWeakify(self);
        _videoView.videoPlayerFailBlock = ^{
            @HDStrongify(self);
            self.videoView.hidden = true;
        };
    }
    return _videoView;
}

@end
