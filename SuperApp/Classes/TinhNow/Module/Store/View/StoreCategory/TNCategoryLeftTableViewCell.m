//
//  TNCategoryLeftTableViewCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/7/9.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCategoryLeftTableViewCell.h"
#import "HDAppTheme+TinhNow.h"
#import "TNCategoryModel.h"
#import "TNFirstLevelCategoryModel.h"


@interface TNCategoryLeftTableViewCell ()
/// 文本
@property (strong, nonatomic) HDLabel *titleLabel;
/// 线条
@property (strong, nonatomic) UIView *leftLine;
@end


@implementation TNCategoryLeftTableViewCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.leftLine];
}
- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.leftLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(kRealWidth(2));
    }];
    [super updateConstraints];
}
- (void)setModel:(TNFirstLevelCategoryModel *)model {
    _model = model;
    //    if (!HDIsObjectNil(model.menuName) && HDIsStringNotEmpty(model.menuName.desc)) {
    //        self.titleLabel.text = model.menuName.desc;
    //    }else{
    self.titleLabel.text = model.name;
    //    }
    if (model.isSelected) {
        self.titleLabel.textColor = HDAppTheme.TinhNowColor.C1;
        self.leftLine.hidden = NO;
        self.titleLabel.backgroundColor = [UIColor whiteColor];
    } else {
        self.titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        self.leftLine.hidden = YES;
        self.titleLabel.backgroundColor = HexColor(0xF7F7F9);
    }
}
/** @lazy titleLabel */
- (HDLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[HDLabel alloc] init];
        _titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 2;
        _titleLabel.backgroundColor = HexColor(0xF7F7F9);
        _titleLabel.hd_edgeInsets = UIEdgeInsetsMake(0, kRealWidth(10), 0, kRealWidth(10));
    }
    return _titleLabel;
}
/** @lazy leftLine */
- (UIView *)leftLine {
    if (!_leftLine) {
        _leftLine = [[UIView alloc] init];
        _leftLine.backgroundColor = HDAppTheme.TinhNowColor.C1;
    }
    return _leftLine;
}
@end
