//
//  WebViewController.h
//  RottenMangoes2
//
//  Created by Jeremy Petter on 2015-05-27.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic) NSURL* url;

@end