//
//  NationalityOptionController.m
//  customer
//
//  Created by 谢 on 2019/1/3.
//  Copyright © 2019 chaos network technology. All rights reserved.
//
#import "NationalityOptionController.h"
#import "CountryTableViewCell.h"
#import "HDCountrySectionModel.h"
#import "HDCountrySliderChooseView.h"
#import "NationalityOptionSearchController.h"


@interface NationalityOptionController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) HDCountrySliderChooseView *countrySliderChooseView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<CountryModel *> *dataSource;

@end


@implementation NationalityOptionController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.boldTitle = PNLocalizedString(@"REGISTER_CHOOSE_NATIONALITY", @"选择国籍");

    //    [self addRightButton:@"pn_search"];

    _countrySliderChooseView = [[HDCountrySliderChooseView alloc] init];
    __weak __typeof(self) weakSelf = self;
    _countrySliderChooseView.selectCountryUnitViewHandler = ^(CountryModel *model) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;

        !strongSelf.choosedCountryHandler ?: strongSelf.choosedCountryHandler(model);

        [strongSelf.navigationController popViewControllerAnimated:true];
    };

    //    [self.viewWrapper addSubview:_countrySliderChooseView];
    [self.view addSubview:_countrySliderChooseView];

    NSArray<NSString *> *popularCountries = @[@"KH", @"VN", @"CN", @"TH", @"KR", @"JP"];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:CountryTableViewCell.class forCellReuseIdentifier:NSStringFromClass(CountryTableViewCell.class)];
    //    [self.viewWrapper addSubview:self.tableView];
    [self.view addSubview:self.tableView];
    NSString *file = [[NSBundle mainBundle] pathForResource:PNLocalizedString(@"COUNTRY_TYPE", @"chineseCountryJson") ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:file];

    NSArray<HDCountrySectionModel *> *countryModels = [NSArray yy_modelArrayWithClass:HDCountrySectionModel.class json:[NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding
                                                                                                                                                         error:nil]];

    self.dataSource = [NSMutableArray array];
    for (HDCountrySectionModel *sectionModel in countryModels) {
        for (CountryModel *model in sectionModel.data) {
            [self.dataSource addObject:model];
        }
    }

    NSArray<CountryModel *> *popularCountriesArray =
        [self.dataSource filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(CountryModel *model, NSDictionary<NSString *, id> *_Nullable bindings) {
                             return [popularCountries containsObject:model.countryCode];
                         }]];
    // 排序
    popularCountriesArray = [popularCountriesArray sortedArrayUsingComparator:^NSComparisonResult(CountryModel *_Nonnull obj1, CountryModel *_Nonnull obj2) {
        return [popularCountries indexOfObject:obj1.countryCode] > [popularCountries indexOfObject:obj2.countryCode];
    }];

    self.countrySliderChooseView.dataSource = popularCountriesArray;
    self.countrySliderChooseView.selectModel = self.selectModel;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    [self.countrySliderChooseView mas_remakeConstraints:^(MASConstraintMaker *make) {
        //        make.width.centerX.top.equalTo(self.viewWrapper);
        make.width.centerX.equalTo(self.view);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        //        make.bottom.width.centerX.equalTo(self.viewWrapper);
        make.bottom.width.centerX.equalTo(self.view);
        make.top.mas_equalTo(self.countrySliderChooseView.mas_bottom);
    }];
}

#pragma mark - private methods
- (void)addRightButton:(NSString *)style {
    // 自定义按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:style] forState:0];
    [button addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:button]];

    //    [self setNavCustomRightView:button];
}

#pragma mark - event response
- (void)search {
    __weak NationalityOptionController *weakSelf = self;
    NationalityOptionSearchController *search = [NationalityOptionSearchController new];

    search.choosedCountryHandler = ^(CountryModel *_Nonnull country) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
        weakSelf.choosedCountryHandler(country);
    };
    [self.navigationController pushViewController:search animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CountryTableViewCell *cell = [CountryTableViewCell cellWithTableView:tableView];

    CountryModel *model = self.dataSource[indexPath.row];
    if ([model.countryCode isEqualToString:self.selectModel.countryCode]) {
        cell.showTickView = true;
    } else {
        cell.showTickView = false;
    }

    cell.textLabel.text = model.countryName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CountryModel *unitDic = self.dataSource[indexPath.row];

    if (self.choosedCountryHandler) {
        self.choosedCountryHandler(unitDic);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSString *)toReadableJSONString:(NSArray *)array {
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];

    if (data == nil) {
        return nil;
    }

    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CountryModel *)selectModel {
    if (!_selectModel) {
        _selectModel = [[CountryModel alloc] init];
    }
    return _selectModel;
}

//- (HDNavigationStyle)navigationBarStyleForViewController:(HDBaseViewController *)viewController {
//    return HDNavigationStyleWhite;
//}

@end
