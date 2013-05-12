//
//  AsyncDemo.m
//  Promises
//
//  Created by Jim Kubicek on 5/11/13.
//  Copyright (c) 2013 Jim Kubicek. All rights reserved.
//

#import "PromiseProducer.h"
#import "Promise+Producer.h"

@implementation PromiseProducer

- (Promise *)fetchImageAtURL:(NSURL *)url {
    Promise *promise = [[Promise alloc] init];
    __weak Promise *weakPromise = promise;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakPromise completeSuccess:image];
        });
    });
    return promise;
}

@end
