//
//  SATableHeaderFooterView.m
//  SuperApp
//
//  Created by VanJay on 2020/6/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableHeaderFooterView.h"


@implementation SATableHeaderFooterView

+ (instancetype)headerWithTableView:(UITableView *)tableView {
    return [self headerWithTableView:tableView identifier:nil];
}

+ (instancetype)headerWithTableView:(UITableView *)tableView identifier:(NSString *_Nullable)identifier {
    if (HDIsStringEmpty(identifier)) {
        identifier = NSStringFromClass(self);
    }
    // 创建 header
    SATableHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];

    if (!header) {
        header = [[self alloc] initWithReuseIdentifier:identifier];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self hd_setupViews];

        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)hd_setupViews {
}

@end
