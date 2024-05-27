//
//  PNInterTransferOpenViewController.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferOpenViewController.h"
#import "PNInterTransferAmountViewController.h"
#import "PNInterTransferFeeRateAlertView.h"
#import "PNInterTransferViewModel.h"
#import "PNSingleSelectedAlertView.h"
#import "PNTransferFormCell.h"


@interface PNInterTransferOpenViewController ()
///
@property (strong, nonatomic) PNInterTransferViewModel *viewModel;
@end


@implementation PNInterTransferOpenViewController

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.stepView setCurrentStep:0];
}

- (void)hd_bindViewModel {
    [self.viewModel initTransferOpenData];
    [self.viewModel hd_bindView:self.view];
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"openVcRefrehData" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
    }];
}

#pragma mark -下一步
- (void)clickOprateBtn {
    @HDWeakify(self);
    [self.viewModel openInterTransferAccountCompletion:^{
        @HDStrongify(self);
        PNInterTransferAmountViewController *amountVC = [[PNInterTransferAmountViewController alloc] initWithViewModel:self.viewModel];
        [SAWindowManager navigateToViewController:amountVC];
    }];
}

#pragma mark -tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.transOpenDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNTransferFormCell *cell = [PNTransferFormCell cellWithTableView:tableView];
    PNTransferFormConfig *config = self.viewModel.transOpenDataArr[indexPath.row];
    cell.config = config;
    return cell;
}

/** @lazy viewModel */
- (PNInterTransferViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PNInterTransferViewModel alloc] init];
    }
    return _viewModel;
}
@end
