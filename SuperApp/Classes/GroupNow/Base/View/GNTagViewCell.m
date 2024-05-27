//
//  GNTagViewCell.m
//  SuperApp
//
//  Created by wmz on 2021/6/2.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNTagViewCell.h"
#import "GNInternationalizationModel.h"


@interface GNTagViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, HDCollectionViewBaseFlowLayoutDelegate>

@property (nonatomic, strong) NSArray<GNCellModel *> *tagData;

@property (nonatomic, strong) UICollectionView *tagCollectionView;

@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) HDCollectionViewVerticalLayout *flowLayout;

@end


@implementation GNTagViewCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = HDAppTheme.color.gn_mainBgColor;
    [self.contentView addSubview:self.view];
    [self.contentView addSubview:self.lineView];
    [self.view addSubview:self.tagCollectionView];
}

- (void)updateConstraints {
    [self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.tagCollectionView layoutIfNeeded];
    [self.tagCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.model.contentInset.left);
        make.right.mas_equalTo(-self.model.contentInset.right);
        make.top.mas_equalTo(self.model.contentInset.top);
        make.height.mas_equalTo(self.model.height ?: self.tagCollectionView.collectionViewLayout.collectionViewContentSize.height);
        make.bottom.mas_equalTo(-self.model.contentInset.bottom);
    }];
    self.view.userInteractionEnabled = self.tagCollectionView.userInteractionEnabled = self.model.userEnable;
    [super updateConstraints];
}

- (void)setGNModel:(GNTagViewCellModel *)data {
    self.model = data;
    [self.tagCollectionView layoutIfNeeded];
    self.lineView.hidden = self.model.lineHidden;
    self.tagCollectionView.backgroundColor = data.collectionViewBgColor;
    self.view.backgroundColor = self.model.backgroundColor;
    NSMutableArray<GNCellModel *> *marr = [NSMutableArray new];
    for (id data in self.model.tagArr) {
        if ([data isKindOfClass:NSString.class]) {
            GNCellModel *model = GNCellModel.new;
            model.title = data;
            [marr addObject:model];
        } else if ([data isKindOfClass:GNCellModel.class]) {
            [marr addObject:data];
        } else if ([data isKindOfClass:GNInternationalizationModel.class]) {
            [marr addObject:data];
        }
    }
    if (!marr.count && data.showEmpty) {
        GNCellModel *model = GNCellModel.new;
        model.title = data.showEmpty;
        [marr addObject:model];
    }
    self.flowLayout.minimumInteritemSpacing = data.minimumInteritemSpacing;
    self.flowLayout.minimumLineSpacing = data.minimumInteritemSpacing;
    self.tagData = [NSArray arrayWithArray:marr];
    [self.tagCollectionView reloadData];
    [self.tagCollectionView layoutIfNeeded];
    [self setNeedsUpdateConstraints];
}

#pragma mark delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.model.userEnable)
        return;
    for (GNCellModel *model in self.tagData) {
        if ([model isKindOfClass:GNCellModel.class]) {
            if (model == self.tagData[indexPath.row]) {
                model.select = YES;
                [GNEvent eventResponder:self target:nil key:@"GNTagClick" indexPath:indexPath info:@{@"data": model}];
            } else {
                model.select = NO;
            }
        }
    }
    [collectionView reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GNTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GNTagCollectionViewCell" forIndexPath:indexPath];
    GNCellModel *cellModel = self.tagData[indexPath.row];
    cell.contentView.layer.cornerRadius = self.model.cornerRadius;
    [cell.nameLb setTitle:cellModel.title forState:UIControlStateNormal];
    cell.nameLb.contentHorizontalAlignment = self.model.textAligment;
    [cell.nameLb setImage:nil forState:UIControlStateNormal];
    cell.nameLb.spacingBetweenImageAndTitle = 0;
    cell.nameLb.titleLabel.font = self.model.titleFont;
    ;
    if ([cellModel isKindOfClass:GNCellModel.class]) {
        if (self.model.history) {
            cell.contentView.layer.backgroundColor = self.model.bgColor.CGColor;
            [cell.nameLb setTitleColor:self.model.textColor forState:UIControlStateNormal];
        } else {
            if (self.model.userEnable) {
                cell.contentView.layer.backgroundColor = cellModel.isSelected ? self.model.bgSelectColor.CGColor : self.model.bgColor.CGColor;
                [cell.nameLb setTitleColor:self.tagData[indexPath.row].isSelected ? self.model.textSelectColor : self.model.textColor forState:UIControlStateNormal];
            } else {
                cell.contentView.layer.backgroundColor = self.model.bgColor.CGColor;
                [cell.nameLb setTitleColor:self.model.textColor forState:UIControlStateNormal];
            }
        }
        [cell.nameLb setImage:cellModel.image forState:UIControlStateNormal];
        cell.nameLb.spacingBetweenImageAndTitle = cellModel.image ? kRealWidth(5) : 0;
    } else if ([cellModel isKindOfClass:GNInternationalizationModel.class]) {
        cell.contentView.layer.backgroundColor = self.model.bgColor.CGColor;
        [cell.nameLb setTitleColor:self.model.textColor forState:UIControlStateNormal];
        cell.contentView.layer.cornerRadius = kRealHeight(6);
        cell.contentView.layer.borderWidth = self.model.hideBorder ? 0 : 1;
        cell.contentView.layer.borderColor = HDAppTheme.color.gn_333Color.CGColor;
    }
    if (self.model.showEmpty && (!self.model.tagArr || !self.model.tagArr.count)) {
        [cell.nameLb setTitleColor:[UIColor hd_colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        cell.contentView.layer.cornerRadius = kRealHeight(6);
        cell.contentView.layer.borderWidth = self.model.hideBorder ? 0 : 1;
        cell.contentView.layer.borderColor = HDAppTheme.color.gn_B6B6B6.CGColor;
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tagData.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    GNCellModel *model = self.tagData[indexPath.row];
    if (!model.width) {
        model.width = ceilf([model.title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, kRealWidth(30)) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                   attributes:@{NSFontAttributeName: [HDAppTheme.font gn_ForSize:13]}
                                                      context:nil]
                                .size.width);
    }
    CGFloat width = model.width + (GNStringNotEmpty(model.title) ? self.model.space : 0) + ([model isKindOfClass:GNCellModel.class] ? (model.image ? kRealWidth(20) : 0) : 0);
    return CGSizeMake(MIN(kScreenWidth - HDAppTheme.value.gn_marginL * 2, width), self.model.itemSizeH);
}

- (Class)yb_classOfCell {
    return GNTagViewCell.class;
}

- (UICollectionView *)tagCollectionView {
    if (!_tagCollectionView) {
        _tagCollectionView = [[GNCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 2 * HDAppTheme.value.gn_marginL, kRealHeight(28)) collectionViewLayout:self.flowLayout];
        _tagCollectionView.delegate = self;
        _tagCollectionView.dataSource = self;
        _tagCollectionView.scrollEnabled = NO;
        _tagCollectionView.backgroundColor = UIColor.redColor;
        [_tagCollectionView registerClass:GNTagCollectionViewCell.class forCellWithReuseIdentifier:@"GNTagCollectionViewCell"];
    }
    return _tagCollectionView;
}

- (HDCollectionViewVerticalLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = HDCollectionViewVerticalLayout.new;
        _flowLayout.delegate = self;
    }
    return _flowLayout;
}

- (UIView *)view {
    if (!_view) {
        _view = UIView.new;
        _view.backgroundColor = HDAppTheme.color.gn_mainBgColor;
    }
    return _view;
}

@end


@implementation GNTagCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.nameLb];
        [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(3);
            make.right.bottom.mas_equalTo(-3);
        }];
    }
    return self;
}

- (HDUIButton *)nameLb {
    if (!_nameLb) {
        _nameLb = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _nameLb.titleLabel.font = [HDAppTheme.font gn_ForSize:13];
        _nameLb.userInteractionEnabled = NO;
    }
    return _nameLb;
}

@end
