//
//  PromiseTests.m
//  Promises
//
//  Created by Jim Kubicek on 5/12/13.
//  Copyright (c) 2013 Jim Kubicek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Promise+Producer.h"

@interface PromiseTests : XCTestCase

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
    XCTAssertNotNil(promise, @"Promise should be initialized");
}

- (void)testCompletionHandlerCalled {
    NSString *testObject = @"test object";
    __block BOOL promiseCalled = NO;
    Promise *testPromise = [self task];
    [testPromise then:^Promise *(id object) {
        XCTAssertEqualObjects(object, testObject, @"The test object should be"
                             " passed to the promise");
        promiseCalled = YES;
        return nil;
    }];

    [testPromise completeSuccess:testObject];
    XCTAssertTrue(promiseCalled, @"the promise should have been called");
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

    XCTAssertTrue(promise1Called, @"The first completion block should have been"
                 " called");
    XCTAssertTrue(promise2Called, @"The second completion block should have been"
                 " called");
}

- (void)testAsyncCompletions {
    __block BOOL promiseCalled = NO;
    Promise *testPromise = [self asyncTask];
    [testPromise then:^Promise *(id object) {
        promiseCalled = YES;
        return nil;
    }];

    NSDate *start = [NSDate date];
    while (promiseCalled == NO) {
        NSTimeInterval time = ABS([start timeIntervalSinceNow]);
        XCTAssertTrue(time < 5.f, @"Timed out waiting for promise to be called");
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

- (void)testAsyncChains {
    __block BOOL promise1Called = NO;
    __block BOOL promise2Called = NO;
    Promise *testPromise1 = [self asyncTask];
    __block Promise *testPromise2 = [self asyncTask];
    [[testPromise1 then:^Promise *(id object) {
        promise1Called = YES;
        return testPromise2;
    }] then:^Promise *(id object) {
        promise2Called = YES;
        return nil;
    }];
    NSDate *start = [NSDate date];
    while (promise1Called == NO && promise2Called == NO) {
        NSTimeInterval time = ABS([start timeIntervalSinceNow]);
        XCTAssertTrue(time < 5.f, @"Timed out waiting for promises to be called");
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

- (void)testFailureInTestCallsLastFailureBlock {
    __block BOOL failureCalled = NO;

    Promise *testPromise1 = [self task];
    Promise *testPromise2 = [self task];
    Promise *testPromise3 = [self task];

    [[[testPromise1 then:^Promise *(id object) {
        return testPromise2;
    }] then:^Promise *(id object) {
        return testPromise3;
    }] then:^Promise *(id object) {
        // do nothing
        return nil;
    } failure:^(id object, NSError *error) {
        failureCalled = YES;
    }];

    [testPromise1 completeFailure:nil error:nil];

    XCTAssertTrue(failureCalled, @"Early failure propigates to later promises");
}

- (void)testFinallyBlockOnSuccess {
    __block BOOL finallyCalled = NO;
    Promise *promise = [self task];
    [promise finally:^{
        finallyCalled = YES;
    }];
    [promise completeSuccess:nil];
    XCTAssertTrue(finallyCalled, @"No matter what, the finally block should be"
                 " called");
}

- (void)testChainedPromisesWithFinallyBlock {
    __block BOOL finally = NO;

    Promise *testPromise1 = [self task];
    Promise *testPromise2 = [self task];
    Promise *testPromise3 = [self task];

    [[[[testPromise1 then:^Promise *(id object) {
        return testPromise2;
    }] then:^Promise *(id object) {
        return testPromise3;
    }] then:^Promise *(id object) {
        return nil;
    }] finally:^{
        finally = YES;
    }];

    [testPromise1 completeSuccess:nil];

    XCTAssertTrue(finally, @"The finally block should always be called");
}

- (void)testChainedAsyncPromisesWithFinallyBlock {
    __block BOOL finally = NO;
    __block BOOL test3Called = NO;

    Promise *testPromise1 = [self asyncTask];

    [[[[testPromise1 then:^Promise *(id object) {
        NSLog(@"test 1");
        return [self asyncTask];
    }] then:^Promise *(id object) {
        NSLog(@"test 2");
        return [self asyncTask];
    }] then:^Promise *(id object) {
        test3Called = YES;
        NSLog(@"test 3");
        return nil;
    }] finally:^{
        NSLog(@"finally");
        finally = YES;
    }];
    NSLog(@"starting while loop");
    int i = 0;
    NSDate *start = [NSDate date];
    while (finally == NO) {
        NSLog(@"cycle #%i", i++);
        NSTimeInterval time = ABS([start timeIntervalSinceNow]);
        XCTAssertTrue(time < 5.f, @"Timed out waiting for promises to be called");
        if (time < 5.f) break;
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    XCTAssertTrue(test3Called, @"Test three shall have been called before the"
                 " finally block is called");
}

#pragma mark - Helper Methods

- (Promise *)task {
    return [[Promise alloc] init];
}

- (Promise *)asyncTask {
    Promise *promise = [[Promise alloc] init];
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [promise completeSuccess:nil];
    });
    return promise;
}

@end
