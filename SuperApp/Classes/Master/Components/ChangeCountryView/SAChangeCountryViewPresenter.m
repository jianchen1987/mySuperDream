//
//  SAChangeCountryViewPresenter.m
//  SuperApp
//
//  Created by VanJay on 2020/4/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAChangeCountryViewPresenter.h"
#import "SAChangeCountryView.h"
#import <HDUIKit/HDCustomViewActionView.h>


@implementation SAChangeCountryViewPresenter
+ (void)showChangeCountryView {
    [self showChangeCountryViewViewWithChoosedItemHandler:nil];
}

+ (void)showChangeCountryViewViewWithChoosedItemHandler:(SAChangeCountryViewChoosedItemHandler)choosedItemHandler {
    HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
    config.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(15), 0, kRealWidth(15));
    config.title = SALocalizedString(@"choose_country", @"选择国家");
    config.buttonTitle = SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons");
    const CGFloat width = kScreenWidth - config.containerViewEdgeInsets.left - config.containerViewEdgeInsets.right;
    SAChangeCountryView *view = [[SAChangeCountryView alloc] initWithFrame:CGRectMake(0, 0, width, 10)];
    [view layoutyImmediately];
    HDCustomViewActionView *actionView = [HDCustomViewActionView actionViewWithContentView:view config:config];

    @HDWeakify(actionView);
    view.selectedItemHandler = ^(SACountryModel *model) {
        @HDStrongify(actionView);
        [actionView dismiss];

        !choosedItemHandler ?: choosedItemHandler(model);
    };
    actionView.willDismissHandler = ^(HDActionAlertView *_Nonnull alertView) {
        !choosedItemHandler ?: choosedItemHandler(nil);
    };
    [actionView show];
}
@end
