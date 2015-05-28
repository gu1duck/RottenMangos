//
//  Review.h
//  RottenMangoes2
//
//  Created by Jeremy Petter on 2015-05-27.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Review : NSObject

@property (nonatomic) NSString* critic;
@property (nonatomic) NSString* publication;
@property (nonatomic) NSString* freshness;
@property (nonatomic) NSString* quote;
@property (nonatomic) NSURL* link;

@end
