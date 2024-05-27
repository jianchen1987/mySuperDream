//
//  TNCategoryChooseView.m
//  SuperApp
//
//  Created by 张杰 on 2021/5/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCategoryChooseView.h"
#import "TNCategoryChooseCell.h"
#import "TNCategoryModel.h"


@interface TNCategoryChooseView () <UITableViewDelegate, UITableViewDataSource>
/// 一级分类视图
@property (strong, nonatomic) UITableView *leftTableView;
/// 二级分类
@property (strong, nonatomic) UITableView *rightTableView;
/// 分割线
@property (strong, nonatomic) UIView *lineView;
/// 二级分类数据源
@property (strong, nonatomic) NSMutableArray<TNCategoryModel *> *rightDataArr;
@end


@implementation TNCategoryChooseView

- (void)hd_setupViews {
    [self addSubview:self.leftTableView];
    [self addSubview:self.rightTableView];
    [self addSubview:self.lineView];
}
- (void)updateConstraints {
    [self.leftTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(self.rightTableView);
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(PixelOne);
    }];
    [self.rightTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.left.equalTo(self.lineView.mas_right);
    }];
    [super updateConstraints];
}
#pragma mark - setter
- (void)setCategoryArr:(NSArray<TNCategoryModel *> *)categoryArr {
    _categoryArr = categoryArr;
    if (HDIsArrayEmpty(categoryArr)) {
        return;
    }
    [self.rightDataArr removeAllObjects];
    NSInteger index = 0;
    NSInteger targetIndex = 0;
    for (TNCategoryModel *leftModel in categoryArr) {
        if (leftModel.isSelected) {
            leftModel.tempIsSelected = YES;
            //插入全部分类
            TNCategoryModel *firstModel = [self getAllCategoryModel];
            [self.rightDataArr addObject:firstModel];
            if (!HDIsArrayEmpty(leftModel.children)) {
                [self.rightDataArr addObjectsFromArray:leftModel.children];
            }
            BOOL hasSelected = NO;
            for (TNCategoryModel *rightModel in self.rightDataArr) {
                if (rightModel.isSelected) {
                    rightModel.tempIsSelected = YES;
                    hasSelected = YES;
                }
            }
            if (hasSelected == NO && !HDIsArrayEmpty(self.rightDataArr)) {
                firstModel.isSelected = YES;
                firstModel.tempIsSelected = YES;
            }
            targetIndex = index;
        }
        index++;
    }

    [self reload];
    if (targetIndex > 3) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:targetIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        });
    }
    [self checkRightDataSelected];
}
- (TNCategoryModel *)getAllCategoryModel {
    TNCategoryModel *model = [[TNCategoryModel alloc] init];
    model.name = TNLocalizedString(@"tn_title_all", @"全部");
    return model;
}
#pragma mark - reload
- (void)reload {
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
}
#pragma mark - 重置
- (void)reset {
    [self.categoryArr enumerateObjectsUsingBlock:^(TNCategoryModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.tempIsSelected = NO;
        [obj.children enumerateObjectsUsingBlock:^(TNCategoryModel *_Nonnull subObj, NSUInteger idx, BOOL *_Nonnull stop) {
            subObj.tempIsSelected = NO;
            subObj.isSelected = NO; //重置后原本的二级分类都要重置
        }];
    }];
    [self.rightDataArr removeAllObjects];
    if (self.checkCanConfirm) {
        self.checkCanConfirm(NO);
    }
    [self reload];
}
#pragma mark - 验证确定按钮是否可以点击
- (void)checkRightDataSelected {
    __block BOOL canConfirm = NO;
    if (!HDIsArrayEmpty(self.rightDataArr)) {
        [self.rightDataArr enumerateObjectsUsingBlock:^(TNCategoryModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if (obj.tempIsSelected) {
                canConfirm = YES;
                *stop = YES;
            }
        }];
    }
    if (self.checkCanConfirm) {
        self.checkCanConfirm(canConfirm);
    }
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return self.categoryArr.count;
    } else {
        return self.rightDataArr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建 cell
    TNCategoryChooseCell *cell = [TNCategoryChooseCell cellWithTableView:tableView];
    if (tableView == self.leftTableView) {
        cell.model = self.categoryArr[indexPath.row];
        @HDWeakify(self);
        cell.tapClickCallBack = ^(TNCategoryModel *_Nonnull selectedModel) {
            @HDStrongify(self);
            if (selectedModel.tempIsSelected) {
                return;
            }
            [self.categoryArr enumerateObjectsUsingBlock:^(TNCategoryModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                obj.tempIsSelected = NO;
            }];
            [self.rightDataArr enumerateObjectsUsingBlock:^(TNCategoryModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                obj.tempIsSelected = NO;
            }];
            selectedModel.tempIsSelected = YES;
            //插入全部分类
            [self.rightDataArr removeAllObjects];
            TNCategoryModel *firstModel = [self getAllCategoryModel];
            [self.rightDataArr addObject:firstModel];
            if (!HDIsArrayEmpty(selectedModel.children)) {
                [self.rightDataArr addObjectsFromArray:selectedModel.children];
            }
            [self reload];
            [self checkRightDataSelected];
        };
    } else {
        cell.model = self.rightDataArr[indexPath.row];
        @HDWeakify(self);
        cell.tapClickCallBack = ^(TNCategoryModel *_Nonnull selectedModel) {
            @HDStrongify(self);
            //点击要区分是否点击的是全部
            TNCategoryModel *firstModel = self.rightDataArr.firstObject;
            if (HDIsStringNotEmpty(selectedModel.menuId)) {
                selectedModel.tempIsSelected = !selectedModel.tempIsSelected;
                firstModel.tempIsSelected = NO;
            } else {
                if (selectedModel.tempIsSelected == NO) {
                    [self.rightDataArr enumerateObjectsUsingBlock:^(TNCategoryModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                        obj.tempIsSelected = NO;
                    }];
                }
                selectedModel.tempIsSelected = !selectedModel.tempIsSelected;
            }

            [self.rightTableView reloadData];
            [self checkRightDataSelected];
        };
    }
    return cell;
}
/** @lazy leftTableView */
- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.allowsSelection = YES;
        _leftTableView.rowHeight = 40;
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 15.0, *)) {
            _leftTableView.sectionHeaderTopPadding = 0;
        }
    }
    return _leftTableView;
}
/** @lazy rightTableView */
- (UITableView *)rightTableView {
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.rowHeight = 40;
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.showsVerticalScrollIndicator = NO;
        _rightTableView.showsHorizontalScrollIndicator = NO;
    }
    return _rightTableView;
}
/** @lazy lineView */
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HexColor(0xD6DBE8);
    }
    return _lineView;
}
/** @lazy rightDataArr */
- (NSMutableArray<TNCategoryModel *> *)rightDataArr {
    if (!_rightDataArr) {
        _rightDataArr = [NSMutableArray array];
    }
    return _rightDataArr;
}
@end
