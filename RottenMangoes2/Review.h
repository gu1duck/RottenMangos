//
//  Review.h
//  RottenMangoes2
//
//  Created by Jeremy Petter on 2015-06-08.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Review : NSManagedObject

@property (nonatomic, retain) NSString * critic;
@property (nonatomic, retain) NSString * freshness;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * publication;
@property (nonatomic, retain) NSString * quote;

@end
