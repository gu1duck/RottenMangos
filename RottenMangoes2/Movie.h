//
//  Movie.h
//  RottenMangoes
//
//  Created by Jeremy Petter on 2015-05-27.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Movie : NSObject
@property (nonatomic) NSString* synopsis;
@property (nonatomic) NSURL* imageURL;
@property (nonatomic) NSString* title;
@property (nonatomic) UIImage* image;
@property (nonatomic) NSString* rottenTomatoesID;


@end
