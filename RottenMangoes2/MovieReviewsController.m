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


@interface MovieReviewsController ()<mapViewControllerDelegate>
@property (nonatomic) NSMutableArray* reviews;

@end

@implementation MovieReviewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    NSString* reviewString = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies/%@/reviews.json?apikey=sr9tdu3checdyayjz85mff8j&page_limit=3", self.movie.rottenTomatoesID];
    NSURL* reviewURL = [NSURL URLWithString:reviewString];
    
    NSURLRequest* reviewRequest = [NSURLRequest requestWithURL:reviewURL];
    
    NSURLSessionTask* getReviews = [[NSURLSession sharedSession] dataTaskWithRequest:reviewRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        self.reviews = [@[] mutableCopy];
        NSDictionary* reviews = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error][@"reviews"];
        for(NSDictionary* dictionary in reviews){
            Review* review = [[Review alloc] init];
            review.critic = dictionary[@"critic"];
            review.publication = dictionary[@"publication"];
            review.freshness = dictionary[@"freshness"];
            review.link = [NSURL URLWithString:dictionary[@"links"][@"review"]];
            review.quote = dictionary[@"quote"];
            
            [self.reviews addObject:review];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }
    }];
    [getReviews resume];
    
    
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
        cell.headerImageView.image =self.movie.image;
        cell.headerSynopsisLabel.text = self.movie.synopsis;
        cell.headerTitleLabel.text = self.movie.title;
        
        return cell;
        
    }
    ReviewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"reviewCell" forIndexPath:indexPath];
    
    Review* review = self.reviews[indexPath.row];
    cell.reviewerField.text = review.critic;
    cell.publicationField.text = review.publication;
    cell.freshnessField.text = review.freshness;
    cell.quoteField.text = review.quote;
    cell.linkField.text = [review.link absoluteString];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"webView"]){
        NSIndexPath* indexPath = [[self.tableView indexPathsForSelectedRows]firstObject];
        Review* review = self.reviews[indexPath.row];
        WebViewController* controller = segue.destinationViewController;
        controller.url = review.link;
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
