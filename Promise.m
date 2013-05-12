//
//  Promise.m
//  Promises
//
//  Created by Jim Kubicek on 2/1/13.
//  Copyright (c) 2013 Jim Kubicek. All rights reserved.
//

#import "Promise.h"

@interface Promise ()

/** This property ensures that we stick around until one of the completion 
 * blocks is called. 
 */
@property (strong) Promise *strongSelf;

/** This is the promise returned from the `then` method. 
 */
@property (strong) Promise *returnedPromise;

// Callbacks
@property (copy) PromiseSuccess success;
@property (copy) PromiseFailure failure;
@property (copy) PromiseProgress progress;

@end

@implementation Promise

#pragma mark - Constructors

#pragma mark - Initialization

#pragma mark - Then

- (Promise *)then:(PromiseSuccess)success {
    return [self then:success failure:nil progress:nil];
}

- (Promise *)then:(PromiseSuccess)success failure:(PromiseFailure)failure {
    return [self then:success failure:failure progress:nil];
}


- (Promise *)then:(PromiseSuccess)success
          failure:(PromiseFailure)failure
         progress:(PromiseProgress)prog
{
    self.strongSelf = self;
    
    self.success = success;
    self.failure = failure;
    self.progress = prog;

    Promise *returnPromise = [[Promise alloc] init];
    self.returnedPromise = returnPromise;
    return returnPromise;
}

#pragma mark - Producer methods

- (void)completeSuccess:(id)object {
    if (self.success) {
        [self populateReturnPromiseWithPromise:self.success(object)];
    }
    self.strongSelf = nil;
}

- (void)completeFailure:(id)object error:(NSError *)error {
    if (self.failure) {
        [self populateReturnPromiseWithPromise:self.failure(object, error)];
    }
    self.strongSelf = nil;
}

- (void)progress:(CGFloat)prog {
    if (self.progress) {
        self.progress(prog);
    }
}

#pragma Private Internals

- (void)populateReturnPromiseWithPromise:(Promise *)promise {
    promise.success = self.returnedPromise.success;
    promise.failure = self.returnedPromise.failure;
    promise.progress = self.returnedPromise.progress;
    promise.strongSelf = promise;
}

@end
