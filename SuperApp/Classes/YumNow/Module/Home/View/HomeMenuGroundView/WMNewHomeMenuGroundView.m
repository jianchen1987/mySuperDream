//
//  WMNewHomeMenuGroundView.m
//  SuperApp
//
//  Created by Tia on 2023/7/19.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMNewHomeMenuGroundView.h"
#import "WMNewHomeMenuNavView.h"
#import "WMHomeViewModel.h"
#import <HDUIKit/HDSearchBar.h>
#import <Stinger/Stinger.h>


@interface WMNewHomeMenuGroundView ()
/// 地址和信息按钮
@property (nonatomic, strong) WMNewHomeMenuNavView *navView;
@property (nonatomic, strong) WMHomeViewModel *viewModel;

@property (nonatomic, strong) UIImageView *bgView;

@end


@implementation WMNewHomeMenuGroundView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = (id)viewModel;
    self = [super initWithViewModel:viewModel];
    return self;
}

- (void)hd_setupViews {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.bgView];
    [self addSubview:self.navView];
}

- (void)hd_bindViewModel {
    self.navView.hideBackButton = self.viewModel.hideBackButton;
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"hideBackButton" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.navView.hideBackButton = self.viewModel.hideBackButton;
    }];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.mas_equalTo(kNavigationBarH);
    }];

    [self.navView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(UIApplication.sharedApplication.statusBarFrame.size.height);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    [super updateConstraints];
}

#pragma mark - private methods
/// 根据偏移变化 UI
/// @param offsetY 偏移 Y 方向大小
/// @param completion 变化回调
- (void)refreshUIWithOffsetY:(CGFloat)offsetY completion:(nullable void (^)(CGRect, CGFloat))completion {
    [self.navView refreshUIWithCriticalValue:self.scrollViewMaxOffsetY offsetY:offsetY completion:completion];

    CGFloat rate = offsetY / self.scrollViewMaxOffsetY;
    rate = rate > 0.98 ? 1 : rate;
    rate = rate < 0.02 ? 0 : rate;
    if (rate == 1) {
        self.bgView.alpha = 0;
    } else {
        self.bgView.alpha = 1;
    }
}

#pragma mark - setter
//- (void)setScrollViewDelegate:(id)scrollViewDelegate {
//    _scrollViewDelegate = scrollViewDelegate;
//
//    if (scrollViewDelegate) {
//        [scrollViewDelegate st_hookInstanceMethod:@selector(scrollViewDidScroll:) option:STOptionAfter usingIdentifier:@"scrollViewDelegate_scrollViewDidScroll_after"
//                                        withBlock:^(id<StingerParams> params, UIScrollView *scrollView) {
//                                            scrollView.isScrolling = true;
//
//                                            CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
//
//                                            [self refreshUIWithOffsetY:offsetY completion:nil];
//                                        }];
//    }
//}

#pragma mark - lazy load
- (WMNewHomeMenuNavView *)navView {
    if (!_navView) {
        _navView = WMNewHomeMenuNavView.new;
        _navView.hideBackButton = self.viewModel.hideBackButton;
    }
    return _navView;
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yn_home_top_bg1"]];
    }
    return _bgView;
}

@end
