//
//  WMHomeMenuGroundView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMHomeMenuGroundView.h"
#import "WMHomeMenuNavView.h"
#import "WMNewHomeViewModel.h"
#import <HDUIKit/HDSearchBar.h>
#import <Stinger/Stinger.h>


@interface WMHomeMenuGroundView ()
/// 地址和信息按钮
@property (nonatomic, strong) WMHomeMenuNavView *navView;
@property (nonatomic, strong) WMNewHomeViewModel *viewModel; ///<
@end


@implementation WMHomeMenuGroundView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = (id)viewModel;
    self = [super initWithViewModel:viewModel];
    return self;
}

- (void)hd_setupViews {
    self.backgroundColor = UIColor.whiteColor;
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
}

#pragma mark - lazy load
- (WMHomeMenuNavView *)navView {
    if (!_navView) {
        _navView = [[WMHomeMenuNavView alloc] initWithViewModel:self.viewModel];;
        _navView.hideBackButton = self.viewModel.hideBackButton;
    }
    return _navView;
}
@end
