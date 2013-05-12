//
//  Promise.h
//  Promises
//
//  Created by Jim Kubicek on 2/1/13.
//  Copyright (c) 2013 Smule. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PromiseSuccess)(id object);
typedef void (^PromiseFailure)(id object, NSError *error);
typedef void (^PromiseProgress)(CGFloat prog);

typedef BOOL (^PromiseTask)();

@interface Promise : NSObject

// Consumers of promises only need to concern themselves with these three methods
- (Promise *)then:(PromiseSuccess)success;
- (Promise *)then:(PromiseSuccess)success failure:(PromiseFailure)failure;
- (Promise *)then:(PromiseSuccess)success failure:(PromiseFailure)failure progress:(PromiseProgress)prog;

// Producers of promises, need to use these
- (void)completeSuccess:(id)object;
- (void)completeFailure:(id)object error:(NSError *)error;
- (void)progress:(CGFloat)prog;

@end
