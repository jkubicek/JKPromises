//
//  Promise.h
//  Promises
//
//  Created by Jim Kubicek on 2/1/13.
//  Copyright (c) 2013 Jim Kubicek. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Promise;

typedef Promise *(^PromiseSuccess)(id object);
typedef Promise *(^PromiseFailure)(id object, NSError *error);
typedef void (^PromiseProgress)(CGFloat prog);

@interface Promise : NSObject

// Consumers of promises only need to concern themselves with these three methods
- (Promise *)then:(PromiseSuccess)success;
- (Promise *)then:(PromiseSuccess)success failure:(PromiseFailure)failure;
- (Promise *)then:(PromiseSuccess)success failure:(PromiseFailure)failure progress:(PromiseProgress)prog;

@end
