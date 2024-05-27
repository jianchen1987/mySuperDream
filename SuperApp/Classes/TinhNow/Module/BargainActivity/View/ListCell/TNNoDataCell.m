//
//  TNNoDataCell.m
//  SuperApp
//
//  Created by 张杰 on 2020/11/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNNoDataCell.h"
#import "HDAppTheme+TinhNow.h"


@interface TNNoDataCell ()
/// 无数据文案
@property (strong, nonatomic) UILabel *noDataLabel;
/// 图片
@property (strong, nonatomic) UIImageView *nodataImageView;
/// <#name#>
@property (strong, nonatomic) UIStackView *stackView;
@end


@implementation TNNoDataCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.stackView];
    [self.stackView addArrangedSubview:self.nodataImageView];
    [self.stackView addArrangedSubview:self.noDataLabel];
}
- (void)updateConstraints {
    [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    [self.nodataImageView sizeToFit];
    [super updateConstraints];
}
- (void)setModel:(TNNoDataCellModel *)model {
    _model = model;
    self.noDataLabel.text = model.noDataText;
    self.noDataLabel.font = model.font;
    self.noDataLabel.textColor = model.textColor;
    if (HDIsStringNotEmpty(model.imageName)) {
        self.nodataImageView.hidden = NO;
        self.nodataImageView.image = [UIImage imageNamed:model.imageName];
    } else {
        self.nodataImageView.hidden = YES;
    }
    [self setNeedsUpdateConstraints];
}
/** @lazy noDataLabel */
- (UILabel *)noDataLabel {
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc] init];
        _noDataLabel.numberOfLines = 0;
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noDataLabel;
}
/** @lazy imageView */
- (UIImageView *)nodataImageView {
    if (!_nodataImageView) {
        _nodataImageView = [[UIImageView alloc] init];
    }
    return _nodataImageView;
}
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.spacing = kRealWidth(5);
        _stackView.alignment = UIStackViewAlignmentCenter;
    }
    return _stackView;
}
@end


@implementation TNNoDataCellModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.font = HDAppTheme.TinhNowFont.standard17;
        self.textColor = [UIColor hd_colorWithHexString:@"#A7A7A7"];
        self.noDataText = @"暂无数据";
    }
    return self;
}

@end
