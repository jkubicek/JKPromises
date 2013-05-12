//
//  ViewController.m
//  Promises
//
//  Created by Jim Kubicek on 5/11/13.
//  Copyright (c) 2013 Jim Kubicek. All rights reserved.
//

#import "ViewController.h"
#import "Promise.h"
#import "AsyncDemo.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    AsyncDemo *d = [[AsyncDemo alloc] init];
    NSURL *url = [NSURL URLWithString:@"https://raw.github.com/jkubicek/deal-with-it/master/han_and_lando_deal.png"];
    [[d fetchImageAtURL:url] then:^(id object) {
        self.imageView.image = object;
    }];
}

@end
