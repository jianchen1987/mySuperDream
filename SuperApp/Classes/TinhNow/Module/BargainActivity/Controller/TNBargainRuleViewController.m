//
//  TNBargainRuleViewController.m
//  SuperApp
//
//  Created by 张杰 on 2020/10/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainRuleViewController.h"
#import "TNBargainDTO.h"
#import "TNBargainRuleModel.h"
#import <SDWebImage.h>
#import "TNAdaptHeightImagesView.h"


@interface TNBargainRuleViewController ()
/// 图片容器
@property (strong, nonatomic) TNAdaptHeightImagesView *imageContainer;
/// 文案
@property (strong, nonatomic) UILabel *contentLabel;
/// dto
@property (strong, nonatomic) TNBargainDTO *bargainDTO;
/// 数据源
@property (strong, nonatomic) TNBargainRuleModel *model;
@end


@implementation TNBargainRuleViewController
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
    }
    return self;
}
- (void)hd_getNewData {
    [self.view showloading];
    @HDWeakify(self);
    [self.bargainDTO queryBargainRulesSuccess:^(TNBargainRuleModel *_Nonnull ruleModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        if (!HDIsObjectNil(ruleModel)) {
            self.model = ruleModel;
            [self updateData];
        } else {
            [self showNoDataPlaceHolderNeedRefrenshBtn:NO refrenshCallBack:nil];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        @HDWeakify(self);
        [self showErrorPlaceHolderNeedRefrenshBtn:YES refrenshCallBack:^{
            @HDStrongify(self);
            [self hd_getNewData];
        }];
    }];
}
- (void)hd_setupViews {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.imageContainer];
    [self.scrollViewContainer addSubview:self.contentLabel];
}
- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"tn_activity_rules", @"活动规则");
}
- (void)updateData {
    self.contentLabel.text = self.model.ruleContent;
    if (!HDIsArrayEmpty(self.model.rulePics)) {
        self.imageContainer.images = self.model.rulePics;
        @HDWeakify(self);
        self.imageContainer.getRealImageSizeCallBack = ^{
            @HDStrongify(self);
            [self.view setNeedsUpdateConstraints];
        };
    }
}
- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    [self.imageContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.scrollViewContainer);
    }];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.view.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.imageContainer.mas_bottom).offset(kRealWidth(20));
        make.bottom.equalTo(self.scrollViewContainer.mas_bottom).offset(-kRealWidth(20));
    }];

    [super updateViewConstraints];
}
- (TNAdaptHeightImagesView *)imageContainer {
    if (!_imageContainer) {
        _imageContainer = [[TNAdaptHeightImagesView alloc] init];
    }
    return _imageContainer;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _contentLabel.font = HDAppTheme.TinhNowFont.standard15;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
- (TNBargainDTO *)bargainDTO {
    if (!_bargainDTO) {
        _bargainDTO = [[TNBargainDTO alloc] init];
    }
    return _bargainDTO;
}
@end
