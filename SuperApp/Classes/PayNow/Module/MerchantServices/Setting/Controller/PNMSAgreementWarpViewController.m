//
//  PNMSAgreementWarpViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/8/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSAgreementWarpViewController.h"
#import "NSObject+HDKitCore.h"
#import "PNMSAgreementDataModel.h"
#import "PNTableView.h"
#import "SAInfoTableViewCell.h"

static NSString *kType = @"pn_type";


@interface PNMSAgreementWarpViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PNTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end


@implementation PNMSAgreementWarpViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        NSArray *arr = [parameters objectForKey:@"data"];
        [self processData:arr];
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_merchant_payment_service_agreement", @"商户支付服务协议");
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.tableView];
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(8));
        make.left.right.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark
- (void)processData:(NSArray *)arr {
    for (int i = 0; i < arr.count; i++) {
        PNMSAgreementDataModel *agModel = [arr objectAtIndex:i];
        SAInfoViewModel *model = [self getDefaultModel];
        model.keyText = agModel.resName;
        [model hd_bindObjectWeakly:agModel.resUrl forKey:kType];

        [self.dataSource addObject:model];
    }
}

- (SAInfoViewModel *)getDefaultModel {
    SAInfoViewModel *model = SAInfoViewModel.new;
    model.keyFont = HDAppTheme.PayNowFont.standard14;
    model.keyColor = HDAppTheme.PayNowColor.c333333;
    model.valueFont = HDAppTheme.PayNowFont.standard14;
    model.valueColor = HDAppTheme.PayNowColor.c999999;
    model.valueTextAlignment = NSTextAlignmentLeft;
    model.valueAlignmentToOther = NSTextAlignmentLeft;
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), kRealWidth(16), kRealWidth(12));
    model.rightButtonImage = [UIImage imageNamed:@"pn_arrow_gray_small"];
    return model;
}

#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:[SAInfoViewModel class]]) {
        SAInfoTableViewCell *cell = [SAInfoTableViewCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    }
    return UITableViewCell.new;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:[SAInfoViewModel class]]) {
        SAInfoViewModel *infoModel = model;
        NSString *url = [infoModel hd_getBoundObjectForKey:kType];
        [HDMediator.sharedInstance navigaveToPayNowPayWebViewVC:@{
            @"url": url,
            @"navTitle": infoModel.keyText,
        }];
    }
}

#pragma mark
- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
