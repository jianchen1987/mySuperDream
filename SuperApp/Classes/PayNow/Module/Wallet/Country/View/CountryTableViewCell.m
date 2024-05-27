//
//  CountryTableViewCell.m
//  customer
//
//  Created by 谢 on 2019/1/9.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "CountryTableViewCell.h"
#import "Masonry.h"


@interface CountryTableViewCell ()
@property (strong, nonatomic) UIImageView *selectImage;
@end


@implementation CountryTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 新建标识
    static NSString *ID = @"CountryTableViewCell";

    // 创建cell
    CountryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

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
    _selectImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chckstand_selected"]];
    // 默认隐藏
    _selectImage.hidden = true;

    [self.contentView addSubview:_selectImage];
}

- (void)updateConstraints {
    [super updateConstraints];

    [self.selectImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-kRealWidth(20));
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setShowTickView:(BOOL)showTickView {
    _showTickView = showTickView;

    self.selectImage.hidden = !showTickView;

    [self setNeedsUpdateConstraints];
}

@end
