//
//  PayActionSheet.m
//  SuperApp
//
//  Created by Quin on 2021/11/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PayActionSheet.h"
#import "PayActionSheetView.h"


@implementation PayActionSheet
- (void)showPayActionSheetView:(NSArray *)dataArr CallBack:(PayActionSheetViewChoosedItemHandler)choosedItemHandler {
    HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
    config.title = self.title;
    if (self.buttonTitle.length > 0) {
        config.buttonTitle = self.buttonTitle;
    } else {
        config.buttonHeight = 0;
    }
    config.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(15), 0, kRealWidth(15));
    const CGFloat width = kScreenWidth - config.containerViewEdgeInsets.left - config.containerViewEdgeInsets.right;
    PayActionSheetView *view = [[PayActionSheetView alloc] initWithFrame:CGRectMake(0, 0, width, 10)];
    view.dataSource = dataArr;
    view.DefaultStr = self.DefaultStr;

    [view layoutyImmediately];
    HDCustomViewActionView *actionView = [HDCustomViewActionView actionViewWithContentView:view config:config];

    @HDWeakify(actionView);
    view.selectedItemHandler = ^(PaySelectableTableViewCellModel *model) {
        @HDStrongify(actionView);
        [actionView dismiss];
        choosedItemHandler(model);
        //        !choosedItemHandler ?: choosedItemHandler(model);
    };
    //    actionView.willDismissHandler = ^(HDActionAlertView *_Nonnull alertView) {
    //        !choosedItemHandler ?: choosedItemHandler(nil);
    //    };
    [actionView show];
}
@end
