//
//  AsyncDemo.h
//  Promises
//
//  Created by Jim Kubicek on 5/11/13.
//  Copyright (c) 2013 Jim Kubicek. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Promise;

@interface AsyncDemo : NSObject

- (Promise *)fetchImageAtURL:(NSURL *)url;

@end
