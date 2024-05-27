//
//  TNCategoryChooseCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/7/1.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCategoryChooseCell.h"
#import "HDAppTheme+TinhNow.h"
#import "TNCategoryModel.h"


@interface TNCategoryChooseCell ()
/// 文本
@property (strong, nonatomic) UILabel *contentLabel;
@end


@implementation TNCategoryChooseCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.contentLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self addGestureRecognizer:tap];
}
- (void)setModel:(TNCategoryModel *)model {
    _model = model;
    NSString *name = model.menuName.desc;
    if (HDIsStringEmpty(name)) {
        name = model.name;
    }
    self.contentLabel.text = name;
    self.contentLabel.textColor = model.tempIsSelected ? HDAppTheme.TinhNowColor.C1 : HDAppTheme.TinhNowColor.G1;
}
- (void)tapClick:(UITapGestureRecognizer *)tap {
    if (self.tapClickCallBack) {
        self.tapClickCallBack(self.model);
    }
}
- (void)updateConstraints {
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    [super updateConstraints];
}
/** @lazy contentLabel */
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = HDAppTheme.TinhNowFont.standard14;
        _contentLabel.textColor = HDAppTheme.TinhNowColor.G1;
    }
    return _contentLabel;
}
@end
