//
//  SASelectableTableViewCell.m
//  SuperApp
//
//  Created by VanJay on 2020/4/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SASelectableTableViewCell.h"


@interface SASelectableTableViewCell ()
/// 选中按钮
@property (nonatomic, strong) HDUIButton *selectedBTN;
/// 底部图片
@property (nonatomic, strong) UIImageView *bottomImageView;
@end


@implementation SASelectableTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.selectedBTN];
    [self.contentView addSubview:self.bottomImageView];

    self.textLabel.font = HDAppTheme.font.standard2;
    self.textLabel.textColor = HDAppTheme.color.G1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.selectedBTN.selected = selected;
}

- (void)updateConstraints {
    if (!self.imageView.isHidden) {
        [self.imageView sizeToFit];
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.model.imageSize);
            make.left.equalTo(self.contentView.mas_left);
            make.top.greaterThanOrEqualTo(self.contentView).offset(kRealWidth(15));
            make.centerY.equalTo(self.contentView);
        }];
    }

    UIView *bottomView = self.bottomImageView.isHidden ? (self.detailTextLabel.isHidden ? nil : self.detailTextLabel) : self.bottomImageView;
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.imageView.isHidden) {
            make.left.equalTo(self.imageView.mas_right).offset(kRealWidth(15));
        } else {
            make.left.equalTo(self.contentView.mas_left);
        }
        make.right.equalTo(self.selectedBTN.mas_left).offset(-kRealWidth(15));
        if (bottomView) {
            make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(15));
            make.bottom.equalTo(bottomView.mas_top).offset(-kRealHeight(10));
        } else {
            make.centerY.equalTo(self.contentView.mas_centerY);
        }
    }];

    if (!self.detailTextLabel.isHidden) {
        [self.detailTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textLabel.mas_left);
            make.right.equalTo(self.selectedBTN.mas_left).offset(-kRealWidth(15));
            make.top.equalTo(self.textLabel.mas_bottom).offset(kRealWidth(15));
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
        }];
    }

    if (!self.bottomImageView.isHidden) {
        [self.bottomImageView sizeToFit];
        [self.bottomImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(60));
            make.top.equalTo(self.textLabel.mas_bottom).offset(kRealWidth(15));
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
        }];
    }

    [self.selectedBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [super updateConstraints];
}

#pragma mark - setter
- (void)setModel:(SASelectableTableViewCellModel *)model {
    _model = model;

    self.imageView.hidden = !model.image;
    if (!self.imageView.isHidden) {
        self.imageView.image = model.image;
    }
    self.textLabel.text = model.text;
    self.textLabel.textColor = model.textColor;
    self.textLabel.font = model.textFont;

    if (HDIsStringNotEmpty(model.subTitle)) {
        self.detailTextLabel.hidden = NO;
        self.detailTextLabel.text = model.subTitle;
        self.detailTextLabel.font = model.subTitleFont;
        self.detailTextLabel.textColor = model.subTitleColor;
    } else {
        self.detailTextLabel.hidden = YES;
    }

    if (model.bottomImage) {
        [self.bottomImageView setHidden:NO];
        self.bottomImageView.image = model.bottomImage;
    } else {
        [self.bottomImageView setHidden:YES];
    }

    if (model.selectedImage) {
        [self.selectedBTN setImage:model.selectedImage forState:UIControlStateSelected];
        [self.selectedBTN setImage:nil forState:UIControlStateNormal];
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (HDUIButton *)selectedBTN {
    if (!_selectedBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"lanUnSelect"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"lanSelect"] forState:UIControlStateSelected];
        button.adjustsButtonWhenHighlighted = false;
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        button.userInteractionEnabled = false;
        _selectedBTN = button;
    }
    return _selectedBTN;
}
/** @lazy bottomImageView */
- (UIImageView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc] init];
        _bottomImageView.hidden = YES;
    }
    return _bottomImageView;
}
@end
