//
//  SATagTableViewCell.m
//  SuperApp
//
//  Created by VanJay on 2020/5/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATagTableViewCell.h"
#import "UIView+FrameChangedHandler.h"


@interface SATagTableViewCell ()
@property (nonatomic, strong) HDFloatLayoutView *floatLayoutView; ///< 所有标签
@end


@implementation SATagTableViewCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.floatLayoutView];
}

- (void)updateConstraints {
    [self.floatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        CGFloat floatLayoutViewWidth = self.frame.size.width - 2 * 10;
        make.top.equalTo(self.contentView).offset(5);
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo([self.floatLayoutView sizeThatFits:CGSizeMake(floatLayoutViewWidth, CGFLOAT_MAX)]);
    }];
    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout {
    return true;
}

#pragma mark - private methods
- (void)reloadDataWithDataSource:(NSArray<SAImageLabelCollectionViewCellModel *> *)dataSource {
    [self.floatLayoutView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    for (SAImageLabelCollectionViewCellModel *model in dataSource) {
        HDUIGhostButton *button = HDUIGhostButton.new;
        [button setTitleColor:HexColor(0x5D667F) forState:UIControlStateNormal];
        [button setTitle:model.title forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.font.standard3;
        button.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:247 / 255.0 blue:250 / 255.0 alpha:0.7];
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        [button sizeToFit];
        button.hd_associatedObject = model;
        [button addTarget:self action:@selector(clickedButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self.floatLayoutView addSubview:button];
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - event response
- (void)clickedButtonHandler:(HDUIGhostButton *)button {
    SAImageLabelCollectionViewCellModel *model = button.hd_associatedObject;
    if ([self.delegate respondsToSelector:@selector(storeSearchCollectionViewTableViewCell:didSelectedTag:)]) {
        [self.delegate storeSearchCollectionViewTableViewCell:self didSelectedTag:model];
    }
}

#pragma mark - getters and setters
- (void)setDataSource:(NSArray<SAImageLabelCollectionViewCellModel *> *)dataSource {
    _dataSource = dataSource;

    [self hd_setFrameNonZeroOnceHandler:^(CGRect frame) {
        [self reloadDataWithDataSource:dataSource];
    }];
}

#pragma mark - lazy load
- (HDFloatLayoutView *)floatLayoutView {
    if (!_floatLayoutView) {
        _floatLayoutView = HDFloatLayoutView.new;
        _floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 8, 10);
    }
    return _floatLayoutView;
}
@end
