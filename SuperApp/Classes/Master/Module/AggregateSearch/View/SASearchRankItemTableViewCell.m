//
//  SASearchRankItemTableViewCell.m
//  SuperApp
//
//  Created by Tia on 2022/12/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SASearchRankItemTableViewCell.h"


@interface SASearchRankItemTableViewCell ()
/// 排名icon
@property (nonatomic, strong) UIImageView *rankIconView;
/// 信息icon
@property (nonatomic, strong) UIImageView *iconView;
/// 文言
@property (nonatomic, strong) UILabel *label;

@end


@implementation SASearchRankItemTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.rankIconView];
    [self.contentView addSubview:self.label];
}

- (void)updateConstraints {
    [self.rankIconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(6);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];

    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.bottom.equalTo(self.contentView);
    }];

    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconView);
        make.left.equalTo(self.iconView.mas_right).offset(4);
        make.right.mas_equalTo(-8);
    }];

    [super updateConstraints];
}

#pragma mark setter
- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;

    NSString *imageName = [NSString stringWithFormat:@"search_rank_0%ld", indexPath.row + 1];

    _rankIconView.image = [UIImage imageNamed:imageName];
}

- (void)setModel:(SASearchThematicListModel *)model {
    _model = model;

    self.label.text = model.content;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(40, 40)]];
}

#pragma mark - lazy load
- (UIImageView *)rankIconView {
    if (!_rankIconView) {
        _rankIconView = UIImageView.new;
        _rankIconView.image = [UIImage imageNamed:@"search_rank_01"];
    }
    return _rankIconView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = UIImageView.new;
        _iconView.layer.cornerRadius = 4;
        _iconView.layer.masksToBounds = YES;
    }
    return _iconView;
}

- (UILabel *)label {
    if (!_label) {
        _label = UILabel.new;
        _label.textColor = HDAppTheme.color.sa_C333;
        _label.font = HDAppTheme.font.sa_standard14;
        _label.numberOfLines = 2;
        _label.hd_lineSpace = 4;
    }
    return _label;
}

@end
