//
//  MapViewController.m
//  RottenMangoes2
//
//  Created by Jeremy Petter on 2015-05-28.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "MapViewController.h"
#import "Theatre.h"
#import "TheatreCellTableViewCell.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) CLLocationManager* locationManager;
@property (nonatomic) BOOL initialLocation;
@property (nonatomic) NSMutableArray* theatres;
@property (nonatomic) CLLocation* userLocation;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
}

-(void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered{
    //CLLocationManager* locationManager = [[CLLocationManager alloc] init];

    //[locationManager requestWhenInUseAuthorization];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
    self.initialLocation = NO;
    [self.locationManager startUpdatingLocation];
    self.mapView.showsUserLocation = YES;
    
    
    
}

- (IBAction)cancelButton:(id)sender {
    [self.delegate mapViewControllerDidCancel:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation* location = [locations firstObject];
    self.userLocation = location;

    if (!self.initialLocation){
        MKCoordinateRegion region;
        region.center = location.coordinate;
        region.span.latitudeDelta = 0.1;
        region.span.longitudeDelta = 0.1;
        [self.mapView setRegion:region animated:YES];
        CLGeocoder* geoCoder = [[CLGeocoder alloc] init];
        
        [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark* placemark = [placemarks firstObject];
            NSString* postalCode = [placemark.postalCode stringByReplacingOccurrencesOfString:@" "withString:@""];
            NSString* movieName = [self.movie.title stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            
            NSString* urlString = [@"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=" stringByAppendingString:postalCode];
            urlString = [urlString stringByAppendingString:@"&movie="];
            urlString = [urlString stringByAppendingString:movieName];
            NSURL* url = [NSURL URLWithString:urlString];
            [self getTheatresfromURL:url];

        }];
    }
    self.initialLocation = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)getTheatresfromURL:(NSURL*)url{
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod: @"GET"];
    NSURLSessionDataTask *getTheatres = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError* serializationError;
        NSDictionary* theatreData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
        NSArray* theatres = theatreData[@"theatres"];
        NSMutableArray* theatreObjects = [@[] mutableCopy];
        for (NSDictionary* dictionary in theatres){
            Theatre* theatre = [[Theatre alloc] init];
            theatre.name = dictionary[@"name"];
            theatre.address = dictionary[@"address"];
            CLLocationCoordinate2D coordinates;
            coordinates.latitude = [dictionary[@"lat"] floatValue];
            coordinates.longitude = [dictionary[@"lng"] floatValue];
            theatre.coordinates = coordinates;
            CLLocation* location = [[CLLocation alloc] initWithLatitude:coordinates.latitude longitude:coordinates.longitude];
            theatre.location = location;
            theatre.distance = [theatre.location distanceFromLocation:self.userLocation];
            [theatreObjects addObject:theatre];
        }
        [theatreObjects sortedArrayUsingComparator:^NSComparisonResult(Theatre*  obj1, Theatre* obj2) {
            if (obj1.distance > obj2.distance){
                return NSOrderedDescending;
            } else if (obj1.distance < obj2.distance){
                return NSOrderedAscending;
            }
            return NSOrderedSame;
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.theatres = theatreObjects;
            [self placeTheatres];
            [self.tableView reloadData];
            
        });
        
    }];

    [getTheatres resume];
    
}

-(void)placeTheatres{
    for(Theatre* theatre in self.theatres){
        MKPointAnnotation* pin = [[MKPointAnnotation alloc] init];
        pin.coordinate = theatre.coordinates;
        pin.title = theatre.name;
        [self.mapView addAnnotation:pin];
        //NSLog(@"%@, %@", theatre.name, theatre.address);
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.theatres count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TheatreCellTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"theatreCell" forIndexPath:indexPath];
    cell.theatre = self.theatres[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MKMapItem* currentMapItem = [MKMapItem mapItemForCurrentLocation];
    Theatre* theatre = self.theatres[indexPath.row];
    MKPlacemark* theatrePlacemark = [[MKPlacemark alloc] initWithCoordinate:theatre.coordinates addressDictionary:nil];
    MKMapItem* theatreMapItem = [[MKMapItem alloc] initWithPlacemark:theatrePlacemark];
    CLLocationCoordinate2D centre;
    centre.latitude = (self.userLocation.coordinate.latitude + theatre.coordinates.latitude)/2;
    centre.longitude = (self.userLocation.coordinate.longitude + theatre.coordinates.longitude)/2;
    MKCoordinateSpan directionsSpan;
    directionsSpan.latitudeDelta = fabs(self.userLocation.coordinate.latitude - theatre.coordinates.latitude)+0.01;
    directionsSpan.longitudeDelta = fabs(self.userLocation.coordinate.longitude - theatre.coordinates.longitude)+0.01;
    
    [MKMapItem openMapsWithItems:@[currentMapItem, theatreMapItem] launchOptions:@{@"MKLaunchOptionsDirectionsModeKey":@"MKLaunchOptionsDirectionsModeDriving",
                                                                                       // @"MKLaunchOptionsMapCenterKey":[NSValue valueWithMKCoordinate:theatre.coordinates],
                                                                                   //@"MKLaunchOptionsMapSpanKey":[NSValue valueWithMKCoordinateSpan:directionsSpan]
                                                                                   }];
}


@end
