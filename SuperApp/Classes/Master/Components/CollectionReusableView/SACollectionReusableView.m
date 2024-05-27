//
//  SACollectionReusableView.m
//  SuperApp
//
//  Created by VanJay on 2020/8/24.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACollectionReusableView.h"
#import <Masonry/Masonry.h>


@interface SACollectionReusableView ()
@property (nonatomic, strong) UIImageView *imageView;      ///< 图片
@property (nonatomic, strong) UILabel *titleLabel;         ///< 标题
@property (nonatomic, strong) UIView *rightViewContainer;  ///< 右 View
@property (nonatomic, strong) UIImageView *rightImageView; ///< 右按钮图片
@property (nonatomic, strong) UILabel *rightLabel;         ///< 右按钮标题
@property (nonatomic, strong) HDLabel *tagLabel;           ///< 标题标签
@property (nonatomic, strong) UIView *line;                ///< 底部线条
@end


@implementation SACollectionReusableView

+ (instancetype)headerWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath {
    return [self headerWithCollectionView:collectionView forIndexPath:indexPath identifier:nil];
}

+ (instancetype)headerWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath identifier:(NSString *_Nullable)identifier {
    if (HDIsStringEmpty(identifier)) {
        identifier = NSStringFromClass(self);
    }
    // 创建 header
    SACollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];

    if (!header) {
        header = [[self alloc] init];
    }
    return header;
}

#pragma mark - life cycle
- (void)commonInit {
    [self hd_setupViews];

    [self setNeedsUpdateConstraints];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)hd_setupViews {
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.tagLabel];
    [self addSubview:self.rightViewContainer];
    [self addSubview:self.line];
    [self.rightViewContainer addSubview:self.rightImageView];
    [self.rightViewContainer addSubview:self.rightLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedViewHandler)];
    [self addGestureRecognizer:tap];
}

#pragma mark - event response
- (void)clickedRightButtonHandler {
    !self.rightButtonClickedHandler ?: self.rightButtonClickedHandler();
}

- (void)clickedViewHandler {
    !self.viewClickedHandler ?: self.viewClickedHandler(self.model);
}

#pragma mark - setter
- (void)setModel:(SACollectionReusableViewModel *)model {
    _model = model;

    self.backgroundColor = model.backgroundColor;

    _imageView.hidden = !model.image;

    if (model.image) {
        _imageView.image = model.image;
    }

    if (model.title.length > 0) {
        _titleLabel.text = model.title;
        _titleLabel.font = model.titleFont;
        _titleLabel.textColor = model.titleColor;
    } else if (model.attrTitle) {
        _titleLabel.attributedText = model.attrTitle;
    }

    _rightViewContainer.hidden = model.rightButtonTitle.length <= 0 && !model.rightButtonImage;
    _rightLabel.hidden = model.rightButtonTitle.length <= 0;
    if (!_rightLabel.isHidden) {
        _rightLabel.text = model.rightButtonTitle;
        _rightLabel.font = model.rightButtonTitleFont;
        _rightLabel.textColor = model.rightButtonTitleColor;
    }
    _rightImageView.hidden = !model.rightButtonImage;
    if (!_rightImageView.isHidden) {
        _rightImageView.image = model.rightButtonImage;
    }

    if (model.tag.length > 0) {
        _tagLabel.text = model.tag;
        _tagLabel.hidden = NO;
        _tagLabel.font = model.tagFont;
        _tagLabel.textColor = model.tagColor;
        _tagLabel.backgroundColor = model.tagBackgroundColor;
        _tagLabel.hd_edgeInsets = model.tagTitleEdgeInset;
    } else {
        _tagLabel.hidden = YES;
    }

    if (model.lineHeight > 0) {
        [self.line setHidden:NO];
    } else {
        [self.line setHidden:YES];
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - layout
- (void)updateConstraints {
    const CGFloat marginToBottom = self.model.marginToBottom;
    const UIEdgeInsets edgeInsets = self.model.edgeInsets;

    if (!self.imageView.isHidden) {
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(edgeInsets.left);
            make.size.mas_equalTo(self.imageView.image.size);
            if (marginToBottom > 0) {
                make.centerY.equalTo(self.titleLabel);
            } else {
                make.centerY.equalTo(self);
            }
        }];
    }
    UIView *rightView = self.tagLabel.isHidden ? (self.rightViewContainer.isHidden ? nil : self.rightViewContainer) : self.tagLabel;
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.imageView.isHidden) {
            make.left.equalTo(self).offset(edgeInsets.left);
        } else {
            make.left.equalTo(self.imageView.mas_right).offset(self.model.titleToImageMarin);
        }
        if (marginToBottom > 0) {
            make.bottom.equalTo(self).offset(-marginToBottom);
        } else {
            make.centerY.equalTo(self);
        }
        if (!rightView) {
            make.right.equalTo(self.mas_right).offset(-15);
        } else {
            make.right.lessThanOrEqualTo(rightView.mas_left).offset(-10);
        }
    }];

    if (!self.tagLabel.isHidden) {
        [self.tagLabel sizeToFit];
        [self.tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(10);
            make.centerY.equalTo(self.titleLabel.mas_centerY);
            if (!self.rightViewContainer.isHidden) {
                make.right.lessThanOrEqualTo(self.rightViewContainer.mas_left).offset(-10);
            } else {
                make.right.lessThanOrEqualTo(self.mas_right).offset(-15);
            }
        }];
    }

    if (!self.rightViewContainer.isHidden) {
        if (HDTableHeaderFootViewRightViewAlignmentTitleRightImageLeft == self.model.rightViewAlignment) {
            [self.rightViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (!self.rightImageView.isHidden) {
                    make.left.equalTo(self.rightImageView);
                } else {
                    make.left.equalTo(self.rightLabel);
                }
                make.right.equalTo(self.rightLabel);
                make.height.centerY.equalTo(self);
            }];

            if (!self.rightLabel.isHidden) {
                [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self).offset(-edgeInsets.right);
                    if (marginToBottom > 0) {
                        make.bottom.equalTo(self).offset(-marginToBottom);
                    } else {
                        make.centerY.equalTo(self);
                    }
                }];
            }

            if (!self.rightImageView.isHidden) {
                [self.rightImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    if (self.rightLabel.isHidden) {
                        make.right.equalTo(self).offset(-edgeInsets.right);
                    } else {
                        make.right.equalTo(self.rightLabel.mas_left).offset(-self.model.rightTitleToImageMarin);
                    }
                    make.size.mas_equalTo(self.rightImageView.image.size);
                    if (marginToBottom > 0) {
                        if (!self.rightLabel.isHidden) {
                            make.centerY.equalTo(self.rightLabel);
                        } else {
                            make.bottom.equalTo(self).offset(-marginToBottom);
                        }
                    } else {
                        make.centerY.equalTo(self);
                    }
                }];
            }
        } else if (HDTableHeaderFootViewRightViewAlignmentTitleLeftImageRight == self.model.rightViewAlignment) {
            [self.rightViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (!self.rightLabel.isHidden) {
                    make.left.equalTo(self.rightLabel);
                } else {
                    make.left.equalTo(self.rightImageView);
                }
                make.right.equalTo(self.rightImageView);
                make.height.centerY.equalTo(self);
            }];

            if (!self.rightImageView.isHidden) {
                [self.rightImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self).offset(-edgeInsets.right);
                    make.size.mas_equalTo(self.rightImageView.image.size);
                    if (marginToBottom > 0) {
                        make.bottom.equalTo(self).offset(-marginToBottom);
                    } else {
                        make.centerY.equalTo(self);
                    }
                }];
            }

            if (!self.rightLabel.isHidden) {
                [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    if (self.rightImageView.isHidden) {
                        make.right.equalTo(self).offset(-edgeInsets.right);
                    } else {
                        make.right.equalTo(self.rightImageView.mas_left).offset(-self.model.rightTitleToImageMarin);
                    }

                    if (marginToBottom > 0) {
                        if (!self.rightImageView.isHidden) {
                            make.centerY.equalTo(self.rightImageView);
                        } else {
                            make.bottom.equalTo(self).offset(-marginToBottom);
                        }
                    } else {
                        make.centerY.equalTo(self);
                    }
                }];
            }
        }
    }

    if (!self.line.isHidden) {
        [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(edgeInsets.left);
            make.right.equalTo(self.mas_right).offset(-edgeInsets.right);
            make.bottom.equalTo(self.mas_bottom);
            make.height.mas_equalTo(self.model.lineHeight);
        }];
    }
    [super updateConstraints];
}

#pragma mark - lazy load
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = UIImageView.new;
        _imageView.hidden = true;
    }
    return _imageView;
}

- (UIView *)rightViewContainer {
    if (!_rightViewContainer) {
        _rightViewContainer = UIView.new;
        _rightViewContainer.hidden = true;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedRightButtonHandler)];
        [_rightViewContainer addGestureRecognizer:recognizer];
    }
    return _rightViewContainer;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = UILabel.new;
    }
    return _rightLabel;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = UIImageView.new;
    }
    return _rightImageView;
}

- (HDLabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[HDLabel alloc] init];
    }
    return _tagLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HDAppTheme.color.G5;
    }
    return _line;
}
@end
