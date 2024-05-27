//
//  TNTutorialViewController.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNTutorialViewController.h"
#import "TNMenuNavView.h"


@interface TNTutorialViewController ()
@end


@implementation TNTutorialViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    HDUIButton *backButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"tn_back_image_new"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(hd_backItemClick:) forControlEvents:UIControlEventTouchUpInside];
    self.hd_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    //    [self.view addSubview:self.navBarView];
    @HDWeakify(self);
    [self.KVOController hd_observe:self.webView keyPath:@"title" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.hd_navigationItem.title = self.webView.title;
    }];
}

- (void)hd_backItemClick:(HDUIButton *)btn {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        self.tabBarController.selectedIndex = 0;
    }
}
- (void)updateViewConstraints {
    [super updateViewConstraints];
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
}
//- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
//    return HDViewControllerNavigationBarStyleHidden;
//}
//- (TNMenuNavView *)navBarView {
//    if (!_navBarView) {
//        _navBarView = [[TNMenuNavView alloc] init];
//        _navBarView.leftImage = @"tn_back_image_new";
//        _navBarView.leftImageInset = 15.0f;
//        @HDWeakify(self);
//        _navBarView.clickedLeftViewBlock = ^{
//            @HDStrongify(self);
//            if ([self.webView canGoBack]) {
//                [self.webView goBack];
//            } else {
//                !self.dismissCallBack ?: self.dismissCallBack();
//            }
//        };
//
//        [_navBarView updateConstraintsAfterSetInfo];
//    }
//    return _navBarView;
//}
@end
