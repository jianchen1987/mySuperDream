//
//  TinhNowTests.m
//  SuperAppTests
//
//  Created by seeu on 2020/6/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCategoryDTO.h"
#import "TNGoodsDTO.h"
#import "TNItemModel.h"
#import "TNPaymentDTO.h"
#import "TNQueryGoodsCategoryRspModel.h"
#import "TNQueryGoodsRspModel.h"
#import "TNSearchSortFilterModel.h"
#import "TNShoppingCarDTO.h"
#import "TNShoppingCarItemModel.h"
#import "TNStoreDTO.h"
#import "TNUserDTO.h"
#import <XCTest/XCTest.h>


@interface TinhNowTests : XCTestCase

@end


@implementation TinhNowTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testQueryGoodsApi {
    XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"QueryGoodsList"];
    TNGoodsDTO *dto = TNGoodsDTO.new;
    TNSearchSortFilterModel *filter = TNSearchSortFilterModel.new;
    [dto queryGoodsListWithPageNo:1 pageSize:10 filterModel:filter success:^(TNQueryGoodsRspModel *_Nonnull rspModel) {
        [exp fulfill];
    } failure:nil];

    [self waitForExpectations:@[exp] timeout:10];
}

- (void)testCategoryApi {
    XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"queryCategory"];
    TNCategoryDTO *dto = TNCategoryDTO.new;

    [dto queryGoodsCategorySuccess:^(TNQueryGoodsCategoryRspModel *_Nonnull rspModel) {
        [exp fulfill];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];

    [self waitForExpectations:@[exp] timeout:10];
}

- (void)testRecommendGoodsListApi {
    XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"recommendGoodsList"];
    TNGoodsDTO *dto = TNGoodsDTO.new;
    [dto queryRecommendGoodsListWithPageNo:1 pageSize:10 success:^(TNQueryGoodsRspModel *_Nonnull rspModel) {
        [exp fulfill];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];

    [self waitForExpectations:@[exp] timeout:10];
}

- (void)testTinhNowUserDiff {
    XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"tinhnowUserDiff"];
    TNUserDTO *dto = TNUserDTO.new;
    [dto getTinhNowUserDifferenceWithUserNo:SAUser.shared.operatorNo success:^(TNGetTinhNowUserDiffRspModel *_Nonnull rspModel) {
        [exp fulfill];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];

    [self waitForExpectations:@[exp] timeout:10];
}

- (void)testStoreInfoAPi {
    XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"storeInfo"];
    TNStoreDTO *dto = TNStoreDTO.new;
    [dto queryStoreInfoWithStoreNo:@"TN3" operatorNo:SAUser.shared.operatorNo success:^(TNStoreInfoRspModel *_Nonnull rspModel) {
        [exp fulfill];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];

    [self waitForExpectations:@[exp] timeout:10];
}

- (void)testAddFavoriteAPi {
    XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"addFavorite"];
    TNStoreDTO *dto = TNStoreDTO.new;
    [dto addStoreFavoritesWithStoreNo:@"1" success:^{
        [exp fulfill];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];

    [self waitForExpectations:@[exp] timeout:10];
}

- (void)testCancelFavoriteAPi {
    XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"cancelFavorite"];
    TNStoreDTO *dto = TNStoreDTO.new;
    [dto cancelStoreFavoriteWithStoreNo:@"1" success:^{
        [exp fulfill];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];

    [self waitForExpectations:@[exp] timeout:10];
}

- (void)testShoppingCarQueryAPI {
    XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"queryShoppingCar"];
    TNShoppingCarDTO *dto = TNShoppingCarDTO.new;
    [dto queryUserShoppingCarSuccess:^(TNQueryUserShoppingCarRspModel *_Nonnull rspModel) {
        [exp fulfill];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];

    [self waitForExpectations:@[exp] timeout:10];
}

- (void)testAddItemToShoppingCarApi {
    XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"addItemToShopping"];
    TNShoppingCarDTO *dto = TNShoppingCarDTO.new;
    TNItemModel *model = TNItemModel.new;
    model.storeNo = @"TN1";
    model.goodsSkuId = @"10";
    model.goodsId = @"14";
    model.quantity = @2;
    [dto addItem:model toShoppingCarSuccess:^(TNAddItemToShoppingCarRspModel *_Nonnull item) {
        [exp fulfill];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];

    [self waitForExpectations:@[exp] timeout:10];
}

- (void)testDeleteItemFromShoppingCarAPI {
    XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"deleteItem"];
    TNShoppingCarDTO *dto = TNShoppingCarDTO.new;
    TNShoppingCarItemModel *model = TNShoppingCarItemModel.new;
    model.itemDisplayNo = @"1278969482868490240";
    [dto deleteItem:model fromShoppingCarSuccess:^{
        [exp fulfill];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];

    [self waitForExpectations:@[exp] timeout:10];
}

- (void)testReduceItemFromShoppingCarAPI {
    XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"reduce"];
    TNShoppingCarDTO *dto = TNShoppingCarDTO.new;
    TNShoppingCarItemModel *model = TNShoppingCarItemModel.new;
    model.itemDisplayNo = @"1278974098725208064";
    [dto increaseQuantifyOfItem:model quantify:@10 inShoppingCarSuccess:^{
        [exp fulfill];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];

    [self waitForExpectations:@[exp] timeout:10];
}

- (void)testIncreaseItemFromShoppingCarAPI {
    XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"increase"];
    TNShoppingCarDTO *dto = TNShoppingCarDTO.new;
    TNShoppingCarItemModel *model = TNShoppingCarItemModel.new;
    model.itemDisplayNo = @"1278969482868490240";
    [dto decreaseQuantifyOfItem:model quantify:@10 inShoppingCarSuccess:^{
        [exp fulfill];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];

    [self waitForExpectations:@[exp] timeout:10];
}

- (void)testClearCarApi {
    XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"clearALl"];
    TNShoppingCarDTO *dto = TNShoppingCarDTO.new;

    [dto clearShoppingCarWithStoreDisplayNo:@"" success:^{
        [exp fulfill];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];

    [self waitForExpectations:@[exp] timeout:10];
}

- (void)testGetPaymentMethod {
    XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"getPaymentType"];
    TNPaymentDTO *dto = TNPaymentDTO.new;
    [dto getPaymentMethodsSuccess:^(TNGetPaymentMethodsRspModel *_Nonnull rspModel) {
        [exp fulfill];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];
    [self waitForExpectations:@[exp] timeout:10];
}

- (void)testGetShippingMethod {
    XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"getshipping"];
    TNPaymentDTO *dto = TNPaymentDTO.new;
    [dto getShippingMethodsSuccess:^(TNGetShippingMethodsRspModel *_Nonnull rspModel) {
        [exp fulfill];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];
    [self waitForExpectations:@[exp] timeout:10];
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
