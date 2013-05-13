//
//  PromiseTests.m
//  Promises
//
//  Created by Jim Kubicek on 5/12/13.
//  Copyright (c) 2013 Jim Kubicek. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "Promise+Producer.h"

@interface PromiseTests : SenTestCase

@end

@implementation PromiseTests

#pragma mark - Setup / Teardown

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

#pragma mark - Tests

- (void)testInit {
    Promise *promise = [[Promise alloc] init];
    STAssertNotNil(promise, @"Promise should be initialized");
}


@end
