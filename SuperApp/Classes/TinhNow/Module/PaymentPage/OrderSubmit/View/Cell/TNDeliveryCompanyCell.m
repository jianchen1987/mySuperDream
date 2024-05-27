//
//  TNDeliveryComponyCell.m
//  SuperApp
//
//  Created by 张杰 on 2023/7/18.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "TNDeliveryCompanyCell.h"
#import "TNView.h"

@interface TNDeliveryItemView : TNView
/// 公司图片
@property (strong, nonatomic) UIImageView *companyImageView;
/// 公司名字
@property (strong, nonatomic) UILabel *nameLabel;
/// 选中按钮
@property (strong, nonatomic) UIImageView *selectImageView;
/// 推荐按钮
@property (strong, nonatomic) HDLabel *recommendTagLabel;

@property (strong, nonatomic) TNDeliveryComponyModel *model;
/// 点击事件
@property (nonatomic, copy) void (^clickItemCallBack)(TNDeliveryComponyModel *model);
@end

@implementation TNDeliveryItemView

- (void)hd_setupViews {
    [self addSubview:self.companyImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.recommendTagLabel];
    [self addSubview:self.selectImageView];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self addGestureRecognizer:tap];
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    !self.clickItemCallBack ?: self.clickItemCallBack(self.model);
}

- (void)setModel:(TNDeliveryComponyModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.logo placeholderImage:[UIImage imageNamed:@"delivery_compony_placehold"] imageView:self.companyImageView];
    self.nameLabel.text = model.deliveryCorp;
    if (model.isSelected == YES) {
        self.selectImageView.image = [UIImage imageNamed:@"tinhnow-selected"];
    } else {
        self.selectImageView.image = [UIImage imageNamed:@"tinhnow-unSelected"];
    }
    self.recommendTagLabel.hidden = !model.recommend;
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.companyImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top).offset(kRealHeight(6));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(24), kRealWidth(24)));
        make.bottom.equalTo(self.mas_bottom).offset(-kRealHeight(6));
    }];

    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.companyImageView);
        make.left.equalTo(self.companyImageView.mas_right).offset(kRealWidth(4));
        if (self.recommendTagLabel.isHidden) {
            make.right.lessThanOrEqualTo(self.selectImageView.mas_left).offset(-kRealWidth(15));
        }
    }];
    if (!self.recommendTagLabel.isHidden) {
        [self.recommendTagLabel sizeToFit];
        [self.recommendTagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.companyImageView);
            make.left.equalTo(self.nameLabel.mas_right).offset(kRealWidth(4));
            make.right.lessThanOrEqualTo(self.selectImageView.mas_left).offset(-kRealWidth(15));
        }];
    }
    [self.selectImageView sizeToFit];
    [self.selectImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.companyImageView);
        make.right.equalTo(self.mas_right);
    }];
    [super updateConstraints];
}

/** @lazy companyImageView */
- (UIImageView *)companyImageView {
    if (!_companyImageView) {
        _companyImageView = [[UIImageView alloc] init];
        _companyImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:2];
        };
    }
    return _companyImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}
- (HDLabel *)recommendTagLabel {
    if (!_recommendTagLabel) {
        _recommendTagLabel = [[HDLabel alloc] init];
        _recommendTagLabel.font = [UIFont systemFontOfSize:11];
        _recommendTagLabel.textColor = HexColor(0xFF8818);
        _recommendTagLabel.backgroundColor = [HexColor(0xFF8818) colorWithAlphaComponent:0.1];
        _recommendTagLabel.hd_edgeInsets = UIEdgeInsetsMake(2, 6, 2, 6);
        _recommendTagLabel.text = TNLocalizedString(@"tn_recommend_k", @"推荐");
        _recommendTagLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:2];
        };
    }
    return _recommendTagLabel;
}
/** @lazy selectImageView */
- (UIImageView *)selectImageView {
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] init];
        _selectImageView.image = [UIImage imageNamed:@"tinhnow-unSelected"];
    }
    return _selectImageView;
}
@end

@interface TNDeliveryCompanyCell ()
@property (nonatomic, strong) UIView *deliverView;
@end

@implementation TNDeliveryCompanyCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.deliverView];
}
- (void)setModel:(TNDeliveryCompanyCellModel *)model {
    _model = model;
    if (HDIsArrayEmpty(model.dataSource)) {
        return;
    }
    [self.deliverView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *lastView = nil;
    for (int i = 0; i < model.dataSource.count; i++) {
        TNDeliveryComponyModel *itemModel = model.dataSource[i];
        //创建支付方式视图
        TNDeliveryItemView *itemView = [[TNDeliveryItemView alloc] init];
        itemView.tag = i;
        itemView.model = itemModel;
        [self.deliverView addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.deliverView);
            if (lastView == nil) {
                make.top.equalTo(self.deliverView.mas_top);
            } else {
                make.top.equalTo(lastView.mas_bottom);
            }
            if (i == model.dataSource.count - 1) {
                make.bottom.equalTo(self.deliverView.mas_bottom);
            }
        }];
        lastView = itemView;
        @HDWeakify(self);
        itemView.clickItemCallBack = ^(TNDeliveryComponyModel *_Nonnull companyModel) {
            @HDStrongify(self);
            if (companyModel.isSelected) {
                return;
            }
            [model.dataSource enumerateObjectsUsingBlock:^(TNDeliveryComponyModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                obj.isSelected = NO;
            }];
            companyModel.isSelected = YES;
            if (self.selectedItemHandler) {
                self.selectedItemHandler(companyModel);
            }
        };
    }
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.deliverView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(10));
    }];
    [super updateConstraints];
}

- (UIView *)deliverView {
    if (!_deliverView) {
        _deliverView = [[UIView alloc] init];
    }
    return _deliverView;
}

@end


@implementation TNDeliveryCompanyCellModel


@end
