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

- (void)testCompletionHandlerCalled {
    NSString *testObject = @"test object";
    __block BOOL promiseCalled = NO;
    Promise *testPromise = [self task];
    [testPromise then:^Promise *(id object) {
        STAssertEqualObjects(object, testObject, @"The test object should be"
                             " passed to the promise");
        promiseCalled = YES;
        return nil;
    }];

    [testPromise completeSuccess:testObject];
    STAssertTrue(promiseCalled, @"the promise should have been called");
}

- (void)testChainReturnBlocks {
    __block BOOL promise1Called = NO;
    __block BOOL promise2Called = NO;
    Promise *testPromise1 = [self task];
    __block Promise *testPromise2 = [self task];
    [[testPromise1 then:^Promise *(id object) {
        promise1Called = YES;
        return testPromise2;
    }] then:^Promise *(id object) {
        promise2Called = YES;
        return nil;
    }];

    [testPromise1 completeSuccess:nil];
    [testPromise2 completeSuccess:nil];

    STAssertTrue(promise1Called, @"The first completion block should have been"
                 " called");
    STAssertTrue(promise2Called, @"The second completion block should have been"
                 " called");
}

#pragma mark - Helper Methods

- (Promise *)task {
    return [[Promise alloc] init];
}


@end
