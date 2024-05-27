//
//  SASuggestionDetailViewController.m
//  SuperApp
//
//  Created by Tia on 2022/11/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SASuggestionDetailViewController.h"
#import "SASuggestionDetailView.h"
#import "SASuggestionViewModel.h"


@interface SASuggestionDetailViewController ()
/// 内容
@property (nonatomic, strong) SASuggestionDetailView *contentView;
/// VM
@property (nonatomic, strong) SASuggestionViewModel *viewModel;

@property (nonatomic, copy) NSString *suggestionInfoId;

@end


@implementation SASuggestionDetailViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    self.suggestionInfoId = [parameters objectForKey:@"suggestionInfoId"];
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"sd_title", @"意见详情");
}

- (void)hd_setupViews {
    self.hd_needMoveView = self.contentView;
    [self.view addSubview:self.contentView];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [super updateViewConstraints];
}

- (void)hd_getNewData {
    [self.viewModel querySuggestionDetail];
}

#pragma mark - config
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

#pragma mark - lazy load
- (SASuggestionDetailView *)contentView {
    if (!_contentView) {
        _contentView = [[SASuggestionDetailView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (SASuggestionViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SASuggestionViewModel alloc] init];
        _viewModel.suggestionInfoId = self.suggestionInfoId;
    }
    return _viewModel;
}

@end
