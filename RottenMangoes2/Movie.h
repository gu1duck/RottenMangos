//
//  Movie.h
//  RottenMangoes2
//
//  Created by Jeremy Petter on 2015-06-08.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Movie : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * rottenTomatoesID;
@property (nonatomic, retain) NSString * synopsis;
@property (nonatomic, retain) NSString * title;

@end
