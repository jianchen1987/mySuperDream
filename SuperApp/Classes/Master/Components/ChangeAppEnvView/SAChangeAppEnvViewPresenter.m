//
//  SAChangeAppEnvViewPresenter.m
//  SuperApp
//
//  Created by VanJay on 2020/4/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAChangeAppEnvViewPresenter.h"
#import "SAChangeAppEnvView.h"
#import <HDUIKit/HDCustomViewActionView.h>


@implementation SAChangeAppEnvViewPresenter

+ (void)showChangeAppEnvView {
    [self showChangeAppEnvViewViewWithChoosedItemHandler:nil];
}

+ (void)showChangeAppEnvViewViewWithChoosedItemHandler:(SAChangeAppEnvViewChoosedItemHandler)choosedItemHandler {
    HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
    config.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(15), 0, kRealWidth(15));
    config.title = @"切换环境";
    config.buttonTitle = SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons");
    const CGFloat width = kScreenWidth - config.containerViewEdgeInsets.left - config.containerViewEdgeInsets.right;
    SAChangeAppEnvView *view = [[SAChangeAppEnvView alloc] initWithFrame:CGRectMake(0, 0, width, 10)];
    [view layoutyImmediately];
    HDCustomViewActionView *actionView = [HDCustomViewActionView actionViewWithContentView:view config:config];

    @HDWeakify(actionView);
    view.selectedItemHandler = ^(SAAppEnvConfig *model) {
        @HDStrongify(actionView);
        !choosedItemHandler ?: choosedItemHandler(model);

        [actionView dismiss];
    };
    actionView.willDismissHandler = ^(HDActionAlertView *_Nonnull alertView) {
        !choosedItemHandler ?: choosedItemHandler(nil);
    };
    [actionView show];
}
@end
