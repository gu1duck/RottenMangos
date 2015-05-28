//
//  MapViewController.h
//  RottenMangoes2
//
//  Created by Jeremy Petter on 2015-05-28.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Movie.h"


@class MapViewController;
@protocol mapViewControllerDelegate <NSObject>

-(void)mapViewControllerDidCancel:(MapViewController*)mapController;


@end

@interface MapViewController : UIViewController

@property (nonatomic, weak) id<mapViewControllerDelegate> delegate;
@property (nonatomic) Movie* movie;

@end
