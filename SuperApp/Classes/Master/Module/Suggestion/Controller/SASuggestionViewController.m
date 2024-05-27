//
//  SASuggestionViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/4/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SASuggestionViewController.h"
#import "SASuggestionView.h"
#import "SASuggestionViewModel.h"


@interface SASuggestionViewController ()
/// 内容
@property (nonatomic, strong) SASuggestionView *contentView;
/// VM
@property (nonatomic, strong) SASuggestionViewModel *viewModel;
@end


@implementation SASuggestionViewController
- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"suggestion_sendback", @"意见反馈");
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

#pragma mark - lazy load

- (SASuggestionView *)contentView {
    return _contentView ?: ({ _contentView = [[SASuggestionView alloc] initWithViewModel:self.viewModel]; });
}

- (SASuggestionViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SASuggestionViewModel alloc] init];
    }
    return _viewModel;
}
@end
