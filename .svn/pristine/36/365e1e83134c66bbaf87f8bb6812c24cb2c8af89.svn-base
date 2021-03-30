//
//  ChamadasRestKit.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/26/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WebService.h"

@interface ChamadasRestKitTests : XCTestCase <RestKitCallBack>

@end

@implementation ChamadasRestKitTests{
    
    WebService *rk;
}

- (void)setUp {
    [super setUp];
    
    rk = [[WebService alloc]initWithDelegate:self];
    
    if (![rk connected]) return;

    [rk requestType:GET_PLAYER withMethod:@"GET" path:[RKUtil pathForGetPlayer] parameters:nil];
}

- (void)tearDown {
    
    [super tearDown];
}

-(void)callBackType:(CallType)type withdata:(id)data{
    
    XCTAssertNotNil(data);
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
