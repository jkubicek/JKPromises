//
//  Promise+Producer.h
//  Promises
//
//  Created by Jim Kubicek on 5/12/13.
//  Copyright (c) 2013 Jim Kubicek. All rights reserved.
//

#import "Promise.h"

/** These methods are not required for *consumers* of promises, but if you would 
 * like to add Promises to your API, you will need to use these methods.
 */

@interface Promise ()

/** The reference object can optionally be set to hold a strong reference to an
 * id. Helpful for Promise factories that may not be able to hold a reference to 
 * the object doing the asynchronous calculations.
 */
@property (strong) id referenceObject;

- (void)completeSuccess:(id)object;
- (void)completeFailure:(id)object error:(NSError *)error;
- (void)progress:(CGFloat)prog;

@end
