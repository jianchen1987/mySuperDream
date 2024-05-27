//
//  TNSubmitReviewController.m
//  SuperApp
//
//  Created by 张杰 on 2021/3/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSubmitReviewController.h"
#import "TNSubmitReviewView.h"
#import "TNReviewViewModel.h"
#import "SAWindowManager.h"


@interface TNSubmitReviewController ()
///
@property (nonatomic, strong) TNReviewViewModel *viewModel;
///
@property (nonatomic, strong) TNSubmitReviewView *contentView;
///
@property (nonatomic, strong) NSString *orderNo;
/// 评价攻略按钮
@property (nonatomic, strong) UIButton *evaluationStrategyButton;

@end


@implementation TNSubmitReviewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        NSString *orderNo = [parameters objectForKey:@"orderNo"];
        if (HDIsStringEmpty(orderNo)) {
            return nil;
            ;
        }
        self.orderNo = orderNo;
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"tn_post_review_title", @"发表商品评论");

    self.hd_navigationItem.rightBarButtonItem = nil;

    NSString *url = [SAApolloManager getApolloConfigForKey:kApolloEvaluationStrategyFromTinhNow];
    if (HDIsStringNotEmpty(url)) {
        self.hd_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.evaluationStrategyButton];
    }
}

- (void)hd_setupViews {
    self.view.backgroundColor = HexColor(0xF5F7FA);
    [self.view addSubview:self.contentView];
}

- (void)hd_bindViewModel {
    self.contentView.orderNo = self.orderNo;
    [self.viewModel getOrderDetailWithOrderNo:self.orderNo];
    //拉取评价公告数据
    [self.viewModel getReviewNotice];
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return NO;
}


#pragma mark -
- (TNSubmitReviewView *)contentView {
    if (!_contentView) {
        _contentView = [[TNSubmitReviewView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (TNReviewViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TNReviewViewModel alloc] init];
    }
    return _viewModel;
}

- (UIButton *)evaluationStrategyButton {
    if (!_evaluationStrategyButton) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:SALocalizedString(@"Rating_instruction", @"评价攻略") forState:UIControlStateNormal];
        [btn setTitleColor:HDAppTheme.color.sa_C1 forState:UIControlStateNormal];
        btn.titleLabel.font = HDAppTheme.font.sa_standard12M;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = HDAppTheme.color.sa_C1.CGColor;
        btn.layer.cornerRadius = 5;
        btn.contentEdgeInsets = UIEdgeInsetsMake(5, 11, 5, 11);
        [btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"点击评价攻略了");
            NSString *url = [SAApolloManager getApolloConfigForKey:kApolloEvaluationStrategyFromTinhNow];
            if (HDIsStringNotEmpty(url)) {
                [SAWindowManager openUrl:url withParameters:nil];
            }
        }];
        _evaluationStrategyButton = btn;
    }
    return _evaluationStrategyButton;
}

@end
