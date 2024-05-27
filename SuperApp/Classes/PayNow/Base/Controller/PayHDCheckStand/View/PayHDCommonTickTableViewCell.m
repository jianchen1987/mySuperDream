//
//  PayHDCommonTickTableViewCell.m
//  customer
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDCommonTickTableViewCell.h"
#import "HDAppTheme.h"
#import "HDCommonDefines.h"
#import "HDCommonLabel.h"
#import "Masonry.h"
#import "PNUtilMacro.h"


@implementation PayHDCommonTickTableViewCellModel

- (instancetype)init {
    if (self = [super init]) {
        _titleColor = [HDAppTheme.color G2];
        _titleFont = [HDAppTheme.font standard3];
        _subTitleColor = [HDAppTheme.color G2];
        _subTitleFont = [HDAppTheme.font standard4];
        _VMargin = kRealWidth(14);
        _labelMargin = kRealWidth(3);
        _disabled = NO;
        _selected = NO;
        _disabledColor = [HDAppTheme.color G3];
        _hideBottomLine = NO;
    }
    return self;
}

@end


@interface PayHDCommonTickTableViewCell ()
@property (nonatomic, strong) UILabel *titleLB;    ///< 名称
@property (nonatomic, strong) UILabel *subTitleLB; ///< 名称
@property (nonatomic, strong) UIImageView *tickIV; ///< 打勾图片
@property (nonatomic, strong) UIView *bottomLine;  ///< 底部线条
@end


@implementation PayHDCommonTickTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 新建标识
    static NSString *ID = @"PayHDCommonTickTableViewCell";

    // 创建cell
    PayHDCommonTickTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 去除选中样式
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        // 初始化子控件
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    _titleLB = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLB];

    _subTitleLB = [[UILabel alloc] init];
    [self.contentView addSubview:_subTitleLB];

    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = [HDAppTheme.color G4];
    [self.contentView addSubview:_bottomLine];

    _tickIV = [[UIImageView alloc] init];
    _tickIV.image = [UIImage imageNamed:@"common_tick"];
    [self.contentView addSubview:_tickIV];
}

- (void)updateConstraints {
    [super updateConstraints];

    [self.imageView sizeToFit];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(kRealWidth(15));
        make.size.mas_equalTo(self.imageView.image.size);
    }];

    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(kRealWidth(15));
        make.top.equalTo(self.contentView).offset(kRealWidth(14));
        if (self.tickIV.isHidden) {
            make.right.equalTo(self.contentView).offset(-kRealWidth(15));
        } else {
            make.right.equalTo(self.tickIV.mas_left).offset(-kRealWidth(15));
        }
        if (self.subTitleLB.isHidden) {
            if (self.bottomLine.isHidden) {
                make.bottom.equalTo(self.contentView).offset(-self.model.VMargin);
            }
        }
    }];

    [self.subTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(kRealWidth(15));
        if (self.tickIV.isHidden) {
            make.right.equalTo(self.contentView).offset(-kRealWidth(15));
        } else {
            make.right.equalTo(self.tickIV.mas_left).offset(-kRealWidth(15));
        }

        if (self.titleLB.isHidden) {
            make.top.equalTo(self.contentView).offset(self.model.VMargin);
        } else {
            make.top.equalTo(self.titleLB.mas_bottom).offset(self.model.labelMargin);
        }

        if (self.bottomLine.isHidden) {
            make.bottom.equalTo(self.contentView).offset(-self.model.VMargin);
        } else {
            make.bottom.equalTo(self.bottomLine.mas_top).offset(-self.model.VMargin);
        }
    }];

    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.equalTo(self.imageView.mas_right).offset(kRealWidth(15));
        make.right.bottom.equalTo(self.contentView);
    }];

    [self.tickIV sizeToFit];
    [self.tickIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-kRealWidth(15));
        make.size.mas_equalTo(self.tickIV.image.size);
    }];
}

#pragma mark - getters and setters
- (void)setModel:(PayHDCommonTickTableViewCellModel *)model {
    _model = model;

    self.imageView.image = [UIImage imageNamed:model.imageName];

    self.titleLB.hidden = !WJIsStringNotEmpty(model.title);
    if (WJIsStringNotEmpty(model.title)) {
        self.titleLB.text = model.title;
        self.titleLB.textColor = model.disabled ? model.disabledColor : model.titleColor;
        self.titleLB.font = model.titleFont;
    }

    self.subTitleLB.hidden = !WJIsStringNotEmpty(model.subTitle);
    if (WJIsStringNotEmpty(model.subTitle)) {
        self.subTitleLB.text = model.subTitle;
        self.subTitleLB.textColor = model.disabled ? model.disabledColor : model.subTitleColor;
        self.subTitleLB.font = model.subTitleFont;
    }

    self.bottomLine.hidden = model.hideBottomLine;

    self.tickIV.hidden = model.disabled || !model.selected;

    [self setNeedsUpdateConstraints];
}
@end
