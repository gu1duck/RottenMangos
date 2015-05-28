//
//  MovieCollection.m
//  
//
//  Created by Jeremy Petter on 2015-05-27.
//
//

#import "MovieCollection.h"
#import "Movie.h"
#import "MovieCell.h"
#import "MovieReviewsController.h"

@interface MovieCollection ()

@property (nonatomic) NSMutableArray* movies;

@end

@implementation MovieCollection

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.movies = [@[] mutableCopy];
    
    NSURL* moviesApi = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=sr9tdu3checdyayjz85mff8j&page_limit=50"];
    NSMutableURLRequest* moviesRequest = [NSMutableURLRequest requestWithURL:moviesApi];
    [moviesRequest setHTTPMethod: @"GET"];
    
    NSURLSessionTask* getMovies = [[NSURLSession sharedSession] dataTaskWithRequest:moviesRequest
                                                                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                      NSError* parseError = nil;
                                                                      NSMutableDictionary* parsedData = [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:0
                                                                                    error:&parseError];
                                                                      NSArray* movies = parsedData[@"movies"];
                                                                      for(NSDictionary* dictionary in movies){
                                                                          Movie* movie = [[Movie alloc] init];
                                                                          movie.title = dictionary[@"title"];
                                                                          movie.synopsis = dictionary[@"synopsis"];
                                                                          movie.rottenTomatoesID = dictionary[@"id"];
                                                                          movie.imageURL = [NSURL URLWithString:dictionary[@"posters"][@"thumbnail"]];
                                                                          
                                                                          
                                                                          [self.movies addObject:movie];
                                                                          
                                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                                              [self.collectionView reloadData];
                                                                          });
                                                                          
                                                                          
                                                                      }
                                                                  }];
    [getMovies resume];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showReviews"]){
        NSIndexPath* moviePath = [[self.collectionView indexPathsForSelectedItems] firstObject];
        Movie* movie = [self.movies objectAtIndex:moviePath.row];
        MovieReviewsController* controller = segue.destinationViewController;
        controller.movie = movie;
    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.movies count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"movieCell" forIndexPath:indexPath];
    
    Movie* thisMovie = self.movies[indexPath.row];
    cell.movieTitleLabel.text = thisMovie.title;
    NSMutableURLRequest* imageRequest = [NSMutableURLRequest requestWithURL:thisMovie.imageURL];

    NSURLSessionDownloadTask* getImage = [[NSURLSession sharedSession] downloadTaskWithRequest:imageRequest completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        thisMovie.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.movieImageView.image = thisMovie.image;
        });
    }];
    [getImage resume];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
