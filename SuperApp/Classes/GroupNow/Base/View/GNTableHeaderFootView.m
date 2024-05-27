//
//  GNTableHeaderFootView.m
//  SuperApp
//
//  Created by wmz on 2021/6/2.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNTableHeaderFootView.h"


@interface GNTableHeaderFootView ()
@property (nonatomic, strong) HDLabel *leftLB;
@end


@implementation GNTableHeaderFootView

+ (instancetype)headerWithTableView:(UITableView *)tableView {
    NSString *ID = NSStringFromClass(self);
    GNTableHeaderFootView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!header) {
        header = [[self alloc] initWithReuseIdentifier:ID];
    }
    return header;
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews {
    [self.contentView addSubview:self.leftLB];
}

- (void)setGNModel:(GNTableHeaderFootViewModel *)data {
    self.model = data;
    self.leftLB.text = data.title;
    self.leftLB.textColor = HDAppTheme.color.gn_333Color;
    self.leftLB.font = data.titleFont;
    self.contentView.backgroundColor = data.backgroundColor;
    if ([self.contentView.subviews indexOfObject:self.leftLB] != NSNotFound) {
        [self.leftLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-self.model.edgeInsets.right);
            make.left.mas_offset(self.model.edgeInsets.left);
            make.top.mas_offset(self.model.edgeInsets.top);
            make.bottom.mas_offset(-self.model.edgeInsets.bottom);
        }];
    }
}

- (HDLabel *)leftLB {
    if (!_leftLB) {
        _leftLB = HDLabel.new;
    }
    return _leftLB;
}

@end
