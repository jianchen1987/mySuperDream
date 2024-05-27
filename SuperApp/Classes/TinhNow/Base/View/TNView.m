//
//  TNView.m
//  SuperApp
//
//  Created by seeu on 2020/6/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNView.h"


@interface TNView ()
@property (nonatomic, strong) HDPlaceholderView *hd_placeholderView; ///< 占位控件
@end


@implementation TNView

- (void)showNoDataPlaceHolderNeedRefrenshBtn:(BOOL)needRefrenshBtn refrenshCallBack:(void (^_Nullable)(void))refrenshCallBack {
    UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
    model.title = SALocalizedString(@"no_data", @"暂无数据");
    model.image = @"no_data_placeholder";
    model.needRefreshBtn = needRefrenshBtn;
    model.refreshBtnTitle = SALocalizedString(@"refresh", @"刷新");
    model.backgroundColor = [self.backgroundColor isEqual:UIColor.clearColor] ? UIColor.whiteColor : self.backgroundColor;
    [self showPlaceHolder:model NeedRefrenshBtn:needRefrenshBtn refrenshCallBack:refrenshCallBack];
}
- (void)showErrorPlaceHolderNeedRefrenshBtn:(BOOL)needRefrenshBtn refrenshCallBack:(void (^_Nullable)(void))refrenshCallBack {
    UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
    model.image = @"placeholder_network_error";
    model.title = SALocalizedString(@"network_error", @"网络开小差啦");
    model.needRefreshBtn = needRefrenshBtn;
    model.refreshBtnTitle = TNLocalizedString(@"tn_button_reload_title", @"重新加载");
    model.backgroundColor = [self.backgroundColor isEqual:UIColor.clearColor] ? UIColor.whiteColor : self.backgroundColor;
    [self showPlaceHolder:model NeedRefrenshBtn:needRefrenshBtn refrenshCallBack:refrenshCallBack];
}
- (void)showPlaceHolder:(UIViewPlaceholderViewModel *)placeHolder NeedRefrenshBtn:(BOOL)needRefrenshBtn refrenshCallBack:(void (^)(void))refrenshCallBack {
    if (!self.hd_placeholderView) {
        self.hd_placeholderView = [[HDPlaceholderView alloc] init];
        [self addSubview:self.hd_placeholderView];
    }
    __weak __typeof(self) weakSelf = self;
    self.hd_placeholderView.tappedRefreshBtnHandler = ^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf removePlaceHolder];
        !refrenshCallBack ?: refrenshCallBack();
    };
    self.hd_placeholderView.hidden = false;
    [self.hd_placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
    }];
    self.hd_placeholderView.model = placeHolder;
}
- (void)removePlaceHolder {
    if (self.hd_placeholderView) {
        [self.hd_placeholderView removeFromSuperview];
        self.hd_placeholderView = nil;
    }
}

#pragma mark -设置分组cell圆角
- (void)setCornerRadiusForSectionCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView needSetAlone:(BOOL)needSetAlone {
    CGFloat cornerRadius = 8.0;
    NSInteger sectionCount = [tableView numberOfRowsInSection:indexPath.section];
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    cell.layer.mask = nil;

    if (needSetAlone) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cornerRadius];
        shapeLayer.path = path.CGPath;
        cell.layer.mask = shapeLayer;
    } else {
        if (sectionCount > 1) {
            if (indexPath.row == 0) {
                CGRect bounds = cell.bounds;
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
                shapeLayer.path = path.CGPath;
                cell.layer.mask = shapeLayer;
            } else if (indexPath.row == sectionCount - 1) {
                CGRect bounds = cell.bounds;
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                                 cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
                shapeLayer.path = path.CGPath;
                cell.layer.mask = shapeLayer;
            }
        } else {
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cornerRadius];
            shapeLayer.path = path.CGPath;
            cell.layer.mask = shapeLayer;
        }
    }
}
@end
