//
//  MovieReviewsController.h
//  RottenMangoes2
//
//  Created by Jeremy Petter on 2015-05-27.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieReviewsController : UITableViewController

@property (nonatomic) Movie* movie;
@property (nonatomic) NSManagedObjectContext* managedObjectContext;

@end
