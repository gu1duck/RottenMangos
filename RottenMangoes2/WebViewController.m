//
//  WebViewController.m
//  RottenMangoes2
//
//  Created by Jeremy Petter on 2015-05-27.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest* reviewRequest = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:reviewRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
