//
//  WMShoppingCartSelecedAllView.m
//  SuperApp
//
//  Created by 张杰 on 2020/11/25.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMShoppingCartSelectedAllView.h"
#import "WMOperationButton.h"


@interface WMShoppingCartSelectedAllView ()
/// 选择状态按钮
@property (nonatomic, strong) HDUIButton *selectAllBTN;
/// 评价按钮
@property (nonatomic, strong) WMOperationButton *deleteBTN;
/// 删除失效按钮
@property (nonatomic, strong) HDUIButton *deleteFailBTN;

@end


@implementation WMShoppingCartSelectedAllView
- (void)hd_setupViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.selectAllBTN];
    [self addSubview:self.deleteBTN];
    [self addSubview:self.deleteFailBTN];
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.10].CGColor;
    self.layer.shadowOpacity = 0.5;
}
- (void)updateConstraints {
    [self.selectAllBTN sizeToFit];
    [self.selectAllBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(kRealWidth(12));
        make.size.mas_equalTo(self.selectAllBTN.bounds.size);
    }];
    [self.deleteBTN sizeToFit];
    [self.deleteBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.deleteBTN.bounds.size);
        make.right.equalTo(self.mas_right).offset(-kRealWidth(12));
        make.centerY.equalTo(self.mas_centerY);
    }];

    [self.deleteFailBTN sizeToFit];
    [self.deleteFailBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.deleteFailBTN.isHidden) {
            make.size.mas_equalTo(self.deleteFailBTN.bounds.size);
            make.right.equalTo(self.deleteBTN.mas_left).offset(-kRealWidth(8));
            make.centerY.equalTo(self.mas_centerY);
        }
    }];
    [super updateConstraints];
}

- (void)setSelectedBtnStatus:(BOOL)isSelectedAll {
    self.selectAllBTN.selected = isSelectedAll;
}

- (void)setDeleteBtnEnabled:(BOOL)enabled {
    if (enabled == YES) {
        self.deleteBTN.userInteractionEnabled = YES;
        self.deleteBTN.layer.borderColor = HDAppTheme.WMColor.mainRed.CGColor;
        [self.deleteBTN setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateNormal];
    } else {
        self.deleteBTN.userInteractionEnabled = NO;
        self.deleteBTN.layer.borderColor = HDAppTheme.color.G4.CGColor;
        [self.deleteBTN setTitleColor:HDAppTheme.color.G4 forState:UIControlStateNormal];
    }
}
#pragma mark - 点击全选
- (void)clickedSelectAllBTNHandler:(HDUIButton *)btn {
    self.selectAllBTN.selected = !self.selectAllBTN.selected;
    if (self.selectedAllClickCallBack) {
        self.selectedAllClickCallBack(self.selectAllBTN.isSelected);
    }
}
#pragma mark - 点击删除
- (void)clickedDeleteBTNHandler {
    if (self.deleteClickCallBack) {
        self.deleteClickCallBack();
    }
}

- (void)clickedDeleteFailBTNHandler {
    if (self.deleteFailClickCallBack) {
        self.deleteFailClickCallBack();
    }
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if (hidden == YES) {
        self.selectAllBTN.selected = NO; //如果隐藏就重置状态
    }
}

#pragma mark - getter
- (BOOL)isSelectedAll {
    return self.selectAllBTN.selected;
}

- (void)setFailGoodCount:(NSInteger)failGoodCount {
    _failGoodCount = failGoodCount;
    self.deleteFailBTN.hidden = !self.failGoodCount;
    [self.deleteFailBTN setTitle:[NSString stringWithFormat:WMLocalizedString(@"wm_shopcar_good_fail_clear", @"清空失效商品(%zd)"), failGoodCount] forState:UIControlStateNormal];
    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (WMOperationButton *)deleteBTN {
    if (!_deleteBTN) {
        WMOperationButton *button = [WMOperationButton buttonWithStyle:WMOperationButtonStyleHollow];
        button.titleEdgeInsets = UIEdgeInsetsMake(8, 20, 8, 20);
        button.titleLabel.font = HDAppTheme.font.standard3Bold;
        [button setTitle:WMLocalizedStringFromTable(@"delete", @"删除", @"Buttons") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickedDeleteBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        button.borderWidth = 1;
        button.userInteractionEnabled = NO;
        button.layer.borderColor = HDAppTheme.color.G4.CGColor;
        [button setTitleColor:HDAppTheme.color.G4 forState:UIControlStateNormal];
        _deleteBTN = button;
    }
    return _deleteBTN;
}
- (HDUIButton *)selectAllBTN {
    if (!_selectAllBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        //        button.hd_eventTimeInterval = CGFLOAT_MIN;
        [button setImage:[UIImage imageNamed:@"yn_car_select_nor"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"yn_car_select_sel"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"yn_car_select_disable"] forState:UIControlStateDisabled];
        button.titleLabel.font = HDAppTheme.font.standard3;
        [button setTitleColor:HDAppTheme.color.G1 forState:UIControlStateNormal];
        [button setTitle:WMLocalizedStringFromTable(@"wm_all_select_btn", @"全选", @"Buttons") forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.spacingBetweenImageAndTitle = kRealWidth(9);
        [button addTarget:self action:@selector(clickedSelectAllBTNHandler:) forControlEvents:UIControlEventTouchUpInside];
        _selectAllBTN = button;
    }
    return _selectAllBTN;
}

- (HDUIButton *)deleteFailBTN {
    if (!_deleteFailBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:12];
        [button setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        [button addTarget:self action:@selector(clickedDeleteFailBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        _deleteFailBTN = button;
    }
    return _deleteFailBTN;
}
@end
