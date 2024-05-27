//
//  SATableViewCell.m
//  SuperApp
//
//  Created by VanJay on 2020/3/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"


@implementation SATableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    return [self cellWithTableView:tableView identifier:nil];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *_Nullable)identifier {
    if (HDIsStringEmpty(identifier)) {
        identifier = NSStringFromClass(self);
    }
    // 创建 cell
    SATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self hd_setupViews];
        [self hd_bindViewModel];

        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)hd_setupViews {
}

- (void)hd_bindViewModel {
}

+ (CGFloat)skeletonViewHeight {
    return 0;
}
@end
