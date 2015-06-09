//
//  Theatre.h
//  RottenMangoes2
//
//  Created by Jeremy Petter on 2015-06-08.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Theatre : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;

@end
