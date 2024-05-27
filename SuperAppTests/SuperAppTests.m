//
//  SuperAppTests.m
//  SuperAppTests
//
//  Created by VanJay on 2020/4/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAPaymentDTO.h"
#import "SAQueryPaymentStateRspModel.h"
#import "SAUserCenterDTO.h"
#import "SAUserSilentPermissionRspModel.h"
#import <XCTest/XCTest.h>


@interface SuperAppTests : XCTestCase

@end


@implementation SuperAppTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    sleep(10);
}

- (void)testQueryGoodsApi {
    XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"QueryGoodsList"];
    SAPaymentDTO *dto = SAPaymentDTO.new;
    [dto queryOrderPaymentStateWithOrderNo:@"13010126411350016110" success:^(SAQueryPaymentStateRspModel *rspModel) {
        [exp fulfill];
    } failure:nil];

    [self waitForExpectations:@[exp] timeout:10];
}

- (void)testSilentPermission {
    XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"silentPermission"];
    SAUserCenterDTO *dto = SAUserCenterDTO.new;
    [dto userPermissionSilentlyWithParams:@{@"appId": @"111"} success:^(SAUserSilentPermissionRspModel *rspModel) {
        [exp fulfill];
    } failure:nil];

    [self waitForExpectations:@[exp] timeout:10];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
