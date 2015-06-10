//
//  MovieReviewsController.m
//  RottenMangoes2
//
//  Created by Jeremy Petter on 2015-05-27.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "MovieReviewsController.h"
#import "Review.h"
#import "ReviewCell.h"
#import "ReviewHeader.h"
#import "WebViewController.h"
#import "MapViewController.h"


@interface MovieReviewsController ()<MapViewControllerDelegate>
@property (nonatomic) NSArray* reviews;

@end

@implementation MovieReviewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    Review* review = [self.movie.reviewedBy anyObject];
    
    if ( !review || review.dateUpdated.timeIntervalSinceNow < -86400){
    
        NSString* reviewString = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies/%@/reviews.json?apikey=sr9tdu3checdyayjz85mff8j&page_limit=3", self.movie.rottenTomatoesID];
        NSURL* reviewURL = [NSURL URLWithString:reviewString];
        
        NSURLRequest* reviewRequest = [NSURLRequest requestWithURL:reviewURL];
        
        NSURLSessionTask* getReviews = [[NSURLSession sharedSession] dataTaskWithRequest:reviewRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            self.reviews = [@[] mutableCopy];
            NSDictionary* reviews = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error][@"reviews"];
            
            NSMutableSet *reviewSet =[[NSMutableSet alloc] initWithArray:@[]];
            
            for(NSDictionary* dictionary in reviews){
                NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([Review class]) inManagedObjectContext:self.managedObjectContext];
                Review* review = [[Review alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
                review.critic = dictionary[@"critic"];
                review.publication = dictionary[@"publication"];
                review.freshness = dictionary[@"freshness"];
                review.link = dictionary[@"links"][@"review"];
                review.quote = dictionary[@"quote"];
                
                [reviewSet addObject:review];
                
                
            }
            self.movie.reviewedBy = reviewSet;
            
            dispatch_async(dispatch_get_main_queue(), ^{
            NSError *saveError;
            [self.managedObjectContext save:&saveError];
            if(saveError){
                NSLog(@"That save done fucked up: %@, %@", error, error.description);
            }
                self.reviews = [self.movie.reviewedBy allObjects];
                [self.tableView reloadData];
            });
        }];
        [getReviews resume];
    } else {
        self.reviews = [self.movie.reviewedBy allObjects];
        [self.tableView reloadData];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0){
        return 1;
    }
    return [self.reviews count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0){
        ReviewHeader* cell = [tableView dequeueReusableCellWithIdentifier:@"reviewHeader" forIndexPath:indexPath];
        cell.headerImageView.image =[UIImage imageWithData:self.movie.image];
        cell.headerSynopsisLabel.text = self.movie.synopsis;
        cell.headerTitleLabel.text = self.movie.title;
        
        return cell;
        
    }
    ReviewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"reviewCell" forIndexPath:indexPath];
    
    Review* review = self.reviews[indexPath.row];
    [cell setupWithReview:review];
    
    return cell;
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"webView"]){
        NSIndexPath* indexPath = [[self.tableView indexPathsForSelectedRows]firstObject];
        Review* review = self.reviews[indexPath.row];
        WebViewController* controller = segue.destinationViewController;
        controller.url = [NSURL URLWithString:review.link];
    }
    if ([segue.identifier isEqualToString:@"showMap"]) {
        UINavigationController* navController = segue.destinationViewController;
        MapViewController* controller = [navController.viewControllers firstObject];
        controller.movie = self.movie;
        controller.delegate = self;
    }
}

#pragma mark - MapViewControllerDelegate

-(void)mapViewControllerDidCancel:(MapViewController *)mapController{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
