//
//  Theatre.h
//  RottenMangoes2
//
//  Created by Jeremy Petter on 2015-05-28.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Theatre : NSObject

@property (nonatomic) NSString* name;
@property (nonatomic) NSString* address;
@property (nonatomic) CLLocationCoordinate2D coordinates;
@property (nonatomic) CLLocation* location;
@property (nonatomic) float distance;



@end
