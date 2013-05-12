//
//  ViewController.m
//  Promises
//
//  Created by Jim Kubicek on 5/11/13.
//  Copyright (c) 2013 Jim Kubicek. All rights reserved.
//

#import "PromiseConsumingViewController.h"
#import "Promise.h"
#import "PromiseProducer.h"

@interface PromiseConsumingViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView1;
@property (strong, nonatomic) IBOutlet UIImageView *imageView2;

@end

@implementation PromiseConsumingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    PromiseProducer *d = [[PromiseProducer alloc] init];
    NSURL *url1 = [NSURL URLWithString:@"https://raw.github.com/jkubicek/deal-with-it/master/han_and_lando_deal.png"];
    NSURL *url2 = [NSURL URLWithString:@"https://raw.github.com/jkubicek/deal-with-it/master/deal_with_it.gif"];
    
    [[[d fetchImageAtURL:url1] then:^Promise *(id object) {
        self.imageView1.image = object;
        return [d fetchImageAtURL:url2];
    }] then:^Promise *(id object) {
        self.imageView2.image = object;
        return nil;
    }];
}

@end
