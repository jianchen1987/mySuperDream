//
//  TNPictureSearchViewController.m
//  SuperApp
//
//  Created by 张杰 on 2022/1/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNPictureSearchViewController.h"
#import "TNCameraView.h"
#import "TNMenuNavView.h"
#import "TNPictureDiscoveryView.h"


@interface TNPictureSearchViewController ()
///
@property (strong, nonatomic) TNMenuNavView *navView;
///
@property (strong, nonatomic) TNCameraView *cameraView;
///
@property (strong, nonatomic) TNPictureDiscoveryView *picView;
@end


@implementation TNPictureSearchViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        ///  带了图片url 过来直接 进行搜索
        NSString *url = [parameters objectForKey:@"imageURL"];
        if (HDIsStringNotEmpty(url)) {
            [self.cameraView stopRunning];
            self.picView.hidden = NO;
            [self showPictureSearchView:url];
        }
    }
    return self;
}
- (void)hd_setupViews {
    [self.view addSubview:self.cameraView];
    [self.view addSubview:self.picView];
    [self.view addSubview:self.navView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.picView.isHidden) {
        [self.cameraView startRunning];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.cameraView stopRunning];
}
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}
- (void)hd_setupNavigation {
    self.hd_statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)updateViewConstraints {
    [self.cameraView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.picView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.navView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(kNavigationBarH);
    }];
    [super updateViewConstraints];
}

#pragma mark -展示占位搜索视图
- (void)showPictureSearchView:(id)image {
    self.picView.hidden = NO;
    self.picView.targetImage = image;
}
/** @lazy cameraView */
- (TNCameraView *)cameraView {
    if (!_cameraView) {
        _cameraView = [[TNCameraView alloc] init];
        @HDWeakify(self);
        _cameraView.takePhotoCallBack = ^(UIImage *_Nonnull image) {
            @HDStrongify(self);
            if (image) {
                [self.cameraView stopRunning];
                [self showPictureSearchView:image];
            }
        };
    }
    return _cameraView;
}
/** @lazy navView */
- (TNMenuNavView *)navView {
    if (!_navView) {
        _navView = [[TNMenuNavView alloc] init];
        _navView.bgAlpha = 0;
        _navView.leftImage = @"tn_back_image_new";
        _navView.leftImageInset = 15.0f;
        @HDWeakify(self);
        _navView.clickedLeftViewBlock = ^{
            @HDStrongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        };
        [_navView updateConstraintsAfterSetInfo];
    }
    return _navView;
}
/** @lazy picView */
- (TNPictureDiscoveryView *)picView {
    if (!_picView) {
        _picView = [[TNPictureDiscoveryView alloc] init];
        _picView.hidden = YES;
        @HDWeakify(self);
        _picView.dimissCallBack = ^{
            @HDStrongify(self);
            [self.cameraView startRunning];
            if ([self.parameters.allKeys containsObject:@"imageURL"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        };
    }
    return _picView;
}
@end
