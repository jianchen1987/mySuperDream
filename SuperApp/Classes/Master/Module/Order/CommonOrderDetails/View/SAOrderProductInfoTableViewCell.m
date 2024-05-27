//
//  SAOrderProductInfoTableViewCell.m
//  SuperApp
//
//  Created by seeu on 2022/4/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAOrderProductInfoTableViewCell.h"
#import "SAOrderDetailsProductView.h"


@interface SAOrderProductInfoTableViewCell ()

@property (nonatomic, strong) UIView *titleContainer;
@property (nonatomic, strong) UIImageView *storeLogoImageView;
@property (nonatomic, strong) SALabel *storeNameLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *productContainer;

@end


@implementation SAOrderProductInfoTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.titleContainer];
    [self.titleContainer addSubview:self.storeLogoImageView];
    [self.titleContainer addSubview:self.storeNameLabel];
    [self.titleContainer addSubview:self.line];
    [self.contentView addSubview:self.productContainer];
}

- (void)updateConstraints {
    [self.titleContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
    }];

    [self.storeLogoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleContainer.mas_left).offset(HDAppTheme.value.padding.left);
        make.top.equalTo(self.titleContainer.mas_top).offset(kRealHeight(8));
        make.centerY.equalTo(self.titleContainer);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(30), kRealWidth(30)));
    }];

    [self.storeNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.storeLogoImageView.mas_right).offset(5);
        make.right.equalTo(self.titleContainer.mas_right).offset(-HDAppTheme.value.padding.right);
        make.centerY.equalTo(self.storeLogoImageView);
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleContainer.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.titleContainer.mas_right).offset(-HDAppTheme.value.padding.right);
        make.bottom.equalTo(self.titleContainer.mas_bottom);
        make.height.mas_equalTo(PixelOne);
    }];

    [self.productContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.top.equalTo(self.titleContainer.mas_bottom);
    }];

    UIView *refView = nil;
    for (int i = 0; i < self.productContainer.subviews.count; i++) {
        UIView *productView = self.productContainer.subviews[i];
        [productView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.productContainer);
            if (refView) {
                make.top.equalTo(refView.mas_bottom);
            } else {
                make.top.equalTo(self.productContainer.mas_top);
            }

            if ([productView isEqual:self.productContainer.subviews.lastObject]) {
                make.bottom.equalTo(self.productContainer.mas_bottom);
            }
        }];
        refView = productView;
    }

    [super updateConstraints];
}

#pragma mark - setter
- (void)setModel:(SAOrderProductInfoTableViewCellModel *)model {
    _model = model;

    [HDWebImageManager setImageWithURL:model.storeLogo placeholderImage:[UIImage imageNamed:@"business_outsize"] imageView:self.storeLogoImageView];
    self.storeNameLabel.text = model.storeName;
    [self.productContainer hd_removeAllSubviews];
    [model.productList enumerateObjectsUsingBlock:^(SAGoodsModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        SAOrderDetailsProductView *productRow = SAOrderDetailsProductView.new;
        productRow.model = obj;
        [self.productContainer addSubview:productRow];
    }];

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (UIView *)titleContainer {
    if (!_titleContainer) {
        _titleContainer = UIView.new;
    }
    return _titleContainer;
}

- (UIImageView *)storeLogoImageView {
    if (!_storeLogoImageView) {
        _storeLogoImageView = UIImageView.new;
        _storeLogoImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.height / 2.0];
        };
    }
    return _storeLogoImageView;
}

- (SALabel *)storeNameLabel {
    if (!_storeNameLabel) {
        _storeNameLabel = SALabel.new;
        _storeNameLabel.textColor = HDAppTheme.color.G1;
        _storeNameLabel.font = HDAppTheme.font.standard2Bold;
        _storeNameLabel.numberOfLines = 1;
        _storeNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _storeNameLabel;
}

- (UIView *)productContainer {
    if (!_productContainer) {
        _productContainer = UIView.new;
    }
    return _productContainer;
}

- (UIView *)line {
    if (!_line) {
        _line = UIView.new;
        _line.backgroundColor = HDAppTheme.color.G4;
    }
    return _line;
}

@end


@implementation SAOrderProductInfoTableViewCellModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"productList": SAGoodsModel.class};
}

@end
