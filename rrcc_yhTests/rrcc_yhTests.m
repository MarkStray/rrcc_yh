//
//  rrcc_yhTests.m
//  rrcc_yhTests
//
//  Created by lawwilte on 15-5-4.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

//#import "AppDelegate.h"

@interface rrcc_yhTests : XCTestCase

@end

@implementation rrcc_yhTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

// 常用断言
- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

// 性能测试
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

// 自定义
- (void)testApplication {
    //XCTFail(@"NO implentation for \"%s\"",__PRETTY_FUNCTION__);
}

@end
