//
//  WMTagTableViewCell.m
//  SuperApp
//
//  Created by wmz on 2022/4/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMTagTableViewCell.h"
#import "HDFloatLayoutView.h"


@implementation WMTagTableViewCell

- (void)reloadDataWithDataSource:(NSArray<SAImageLabelCollectionViewCellModel *> *)dataSource {
    HDFloatLayoutView *floatLayoutView = [self valueForKey:@"floatLayoutView"];
    if (!floatLayoutView)
        return;
    floatLayoutView.itemMargins = UIEdgeInsetsMake(kRealWidth(15), kRealWidth(8), 0, kRealWidth(8));
    [floatLayoutView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (SAImageLabelCollectionViewCellModel *model in dataSource) {
        HDUIGhostButton *button = HDUIGhostButton.new;
        [button setTitleColor:model.textColor forState:UIControlStateNormal];
        [button setTitle:model.title forState:UIControlStateNormal];
        button.titleLabel.font = model.textFont;
        button.backgroundColor = model.backgroundColor;
        button.titleEdgeInsets = model.edgeInsets;
        [button sizeToFit];
        button.hd_associatedObject = model;
        [button addTarget:self action:NSSelectorFromString(@"clickedButtonHandler:") forControlEvents:UIControlEventTouchUpInside];
        [floatLayoutView addSubview:button];
    }
    [self setNeedsUpdateConstraints];
}

///防止崩溃
- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

@end
