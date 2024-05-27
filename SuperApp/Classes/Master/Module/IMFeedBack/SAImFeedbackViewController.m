//
//  SAImFeedbackViewController.m
//  SuperApp
//
//  Created by Tia on 2023/2/27.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAImFeedbackViewController.h"
#import "SAImFeedbackView.h"
#import "SAImFeedbackViewModel.h"


@interface SAImFeedbackViewController ()
/// 内容
@property (nonatomic, strong) SAImFeedbackView *contentView;
/// VM
@property (nonatomic, strong) SAImFeedbackViewModel *viewModel;
@end


@implementation SAImFeedbackViewController
- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"im_fb_Feedback", @"反馈");
}

- (void)hd_setupViews {
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

#pragma mark - override
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

#pragma mark - lazy load

- (SAImFeedbackView *)contentView {
    return _contentView ?: ({ _contentView = [[SAImFeedbackView alloc] initWithViewModel:self.viewModel]; });
}

- (SAImFeedbackViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SAImFeedbackViewModel alloc] init];
        _viewModel.fromOperatorNo = self.parameters[@"fromOperatorNo"];
        _viewModel.fromOperatorType = [self.parameters[@"fromOperatorType"] integerValue];
        _viewModel.toOperatorNo = self.parameters[@"toOperatorNo"];
        _viewModel.toOperatorType = [self.parameters[@"toOperatorType"] integerValue];
    }
    return _viewModel;
}
@end
