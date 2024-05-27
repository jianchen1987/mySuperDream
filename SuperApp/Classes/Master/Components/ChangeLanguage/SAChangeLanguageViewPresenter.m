//
//  SAChangeLanguageViewPresenter.m
//  SuperApp
//
//  Created by VanJay on 2020/4/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAChangeLanguageViewPresenter.h"
#import "SAChangeLanguageView.h"
#import <HDUIKit/HDCustomViewActionView.h>


@implementation SAChangeLanguageViewPresenter

+ (void)showChangeLanguageView {
    [self showChangeLanguageViewWithChoosedItemHandler:nil];
}

+ (void)showChangeLanguageViewWithChoosedItemHandler:(SAChangeLanguageViewChoosedItemHandler)choosedItemHandler {
    HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
    config.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(15), 0, kRealWidth(15));
    config.title = SALocalizedString(@"choose_language", @"选择语言");
    config.buttonTitle = SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons");
    const CGFloat width = kScreenWidth - config.containerViewEdgeInsets.left - config.containerViewEdgeInsets.right;
    SAChangeLanguageView *view = [[SAChangeLanguageView alloc] initWithFrame:CGRectMake(0, 0, width, 10)];
    [view layoutyImmediately];
    HDCustomViewActionView *actionView = [HDCustomViewActionView actionViewWithContentView:view config:config];

    @HDWeakify(actionView);
    view.selectedItemHandler = ^(SASelectableTableViewCellModel *model) {
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
