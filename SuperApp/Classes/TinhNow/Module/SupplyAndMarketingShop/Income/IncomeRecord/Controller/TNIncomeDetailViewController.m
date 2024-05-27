//
//  TNIncomeDetailViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNIncomeDetailViewController.h"
//#import "SAInfoTableViewCell.h"
//#import "SATableView.h"
#import "TNIncomeDetailViewModel.h"
//#import "TNQuestionAndContactView.h"
#import "TNIncomeDetailView.h"
#import "TNNewIncomeDetailView.h"
#import "TNNewIncomeDetailViewModel.h"


@interface TNIncomeDetailViewController ()
/// 旧版视图
@property (strong, nonatomic) TNIncomeDetailView *detailView;
/// 旧版走这个
@property (strong, nonatomic) TNIncomeDetailViewModel *viewModel;
/// 新版走这个 根据开关来
@property (strong, nonatomic) TNNewIncomeDetailViewModel *settledViewModel;
/// 新版视图
@property (strong, nonatomic) TNNewIncomeDetailView *settledDetailView;
@end


@implementation TNIncomeDetailViewController
- (id)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        NSString *objId = [parameters valueForKey:@"id"];
        NSNumber *type = [parameters valueForKey:@"type"];
        if ([TNGlobalData shared].isNeedGobackSupplierIncomePage) {
            //回退旧版本
            self.viewModel.objId = objId;
            self.viewModel.type = [type integerValue];
        } else {
            //新版本
            self.settledViewModel.objId = objId;
        }
    }
    return self;
}
- (void)hd_setupViews {
    if ([TNGlobalData shared].isNeedGobackSupplierIncomePage) {
        //回退旧版本
        [self.view addSubview:self.detailView];
    } else {
        //新版本
        [self.view addSubview:self.settledDetailView];
    }
}
- (void)updateViewConstraints {
    if ([TNGlobalData shared].isNeedGobackSupplierIncomePage) {
        //回退旧版本
        [self.detailView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.hd_navigationBar.mas_bottom);
        }];
    } else {
        //新版本
        [self.settledDetailView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.hd_navigationBar.mas_bottom);
        }];
    }
    [super updateViewConstraints];
}
- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"1rPeo8du", @"收益详情");
}
/** @lazy detailView */
- (TNIncomeDetailView *)detailView {
    if (!_detailView) {
        _detailView = [[TNIncomeDetailView alloc] initWithViewModel:self.viewModel];
    }
    return _detailView;
}
/** @lazy settledDetailView */
- (TNNewIncomeDetailView *)settledDetailView {
    if (!_settledDetailView) {
        _settledDetailView = [[TNNewIncomeDetailView alloc] initWithViewModel:self.settledViewModel];
    }
    return _settledDetailView;
}
/** @lazy viewModel */
- (TNIncomeDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TNIncomeDetailViewModel alloc] init];
    }
    return _viewModel;
}
/** @lazy viewModel */
- (TNNewIncomeDetailViewModel *)settledViewModel {
    if (!_settledViewModel) {
        _settledViewModel = [[TNNewIncomeDetailViewModel alloc] init];
    }
    return _settledViewModel;
}

@end
