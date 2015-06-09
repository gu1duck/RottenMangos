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
#import "CoreDataStack.h"

@interface MovieCollection () <NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>


@property (nonatomic) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic) NSManagedObjectContext* managedObjectContext;

@end

@implementation MovieCollection

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CoreDataStack* stack = [[CoreDataStack alloc] init];
    self.managedObjectContext = stack.managedObjectContext;
    
    NSURL* moviesApi = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=sr9tdu3checdyayjz85mff8j&page_limit=50"];
    NSMutableURLRequest* moviesRequest = [NSMutableURLRequest requestWithURL:moviesApi];
    [moviesRequest setHTTPMethod: @"GET"];
    
    NSURLSessionTask* getMovies = [[NSURLSession sharedSession] dataTaskWithRequest:moviesRequest
                                                                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                      
                                                                      if (error) {
                                                                          NSLog(@"NSURL get fucked up. %@: %@", error, error.description);
                                                                      }
                                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                                          NSError* parseError;
                                                                          NSMutableDictionary* parsedData = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                                            options:0
                                                                                                                                              error:&parseError];
                                                                          if (parseError){
                                                                              NSLog(@"JSON Parsing fucked up, yo. %@:%@", error, error.description);
                                                                          }
                                                                          NSArray* movies = parsedData[@"movies"];
                                                                          
                                                                          NSEntityDescription* entity = [NSEntityDescription entityForName:NSStringFromClass([Movie class]) inManagedObjectContext:self.managedObjectContext];
                                                                          
                                                                          for(NSDictionary* dictionary in movies){
                                                                              if (![self itemWithId: dictionary[@"id"] isInFetchedResultsController: self.fetchedResultsController]){
                                                                                  Movie* movie = [[Movie alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
                                                                                  movie.title = dictionary[@"title"];
                                                                                  movie.synopsis = dictionary[@"synopsis"];
                                                                                  movie.rottenTomatoesID = dictionary[@"id"];
                                                                                  movie.imageURL = dictionary[@"posters"][@"thumbnail"];
                                                                                  
                                                                                  [self.managedObjectContext insertObject:movie];
                                                                                  
                                                                              }
                                                                          }
                                                                          for(Movie* movie in self.fetchedResultsController.fetchedObjects){
                                                                              if(![self itemWithId: movie.rottenTomatoesID isInArrayOfDictionaries: movies]){
                                                                                  
                                                                                  [self.managedObjectContext deleteObject:movie];
                                                                                  
                                                                              }
                                                                              
                                                                          }
                                                                          NSError *saveError;
                                                                          [self.managedObjectContext save:&saveError];
                                                                          if (saveError){
                                                                              NSLog(@"Error saving changes to the object context, doofus. %@: %@", error, error.description);
                                                                          }
                                                                          
                                                                          [self.collectionView reloadData];
                                                                      });
                                                                  }];
    [getMovies resume];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
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
//        NSIndexPath* moviePath = [[self.collectionView indexPathsForSelectedItems] firstObject];
//        Movie* movie = [self.movies objectAtIndex:moviePath.row];
//        MovieReviewsController* controller = segue.destinationViewController;
//        controller.movie = movie;
    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.fetchedResultsController.sections count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"movieCell" forIndexPath:indexPath];
    
    Movie* thisMovie = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.movieTitleLabel.text = thisMovie.title;
    
    if (thisMovie.image){
        cell.movieImageView.image = [UIImage imageWithData:thisMovie.image];
    } else {
        NSURL* url = [NSURL URLWithString:thisMovie.imageURL];
        NSMutableURLRequest* imageRequest = [NSMutableURLRequest requestWithURL:url];
        NSURLSessionDownloadTask* getImage = [[NSURLSession sharedSession] downloadTaskWithRequest:imageRequest completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            if (error){
                NSLog(@"Image download fucked up %@, %@", error, error.description);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                thisMovie.image = [NSData dataWithContentsOfURL:location];
                cell.movieImageView.image = [UIImage imageWithData:thisMovie.image];
                NSError* saveError;
                [self.managedObjectContext save:&saveError];
                if (saveError){
                    NSLog(@"Error saving image, brah. %@: %@", error, error.description);
                }
            });
        }];
        [getImage resume];
    }
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

#pragma mark - Core Data

-(NSFetchedResultsController*)fetchedResultsController{
    if (_fetchedResultsController){
        return _fetchedResultsController;
    }
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([Movie class]) inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:50];
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSFetchedResultsController* fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                               managedObjectContext:self.managedObjectContext
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:@"collection"];
    fetchedResultsController.delegate = self;
    self.fetchedResultsController = fetchedResultsController;
    NSError* error;
    [self.fetchedResultsController performFetch:&error];
    if (error){
        NSLog(@"Your fetch fucked up, dog. %@: %@", error, error.description);
    }
    
    return _fetchedResultsController;
}

#pragma mark - NSFetchResultsControllerDelegate methods

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
//    switch (type) {
//        case NSFetchedResultsChangeInsert:
//            [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
//            break;
//        case NSFetchedResultsChangeDelete:
//            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
//            break;
//        case NSFetchedResultsChangeUpdate:
//            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
//            break;
//            
//        default:
//            break;
//    }
}

#pragma mark - helper methods
-(BOOL) itemWithId:(NSString*)tomatoesID isInFetchedResultsController: (NSFetchedResultsController*) fetchedResultsController{
    for (Movie* movie in fetchedResultsController.fetchedObjects){
        if([movie.rottenTomatoesID isEqualToString:tomatoesID]){
            return YES;
        }
    }
    return NO;
}

-(BOOL) itemWithId: (NSString*)rottenTomatoesId isInArrayOfDictionaries: (NSArray*)array{
    for (NSDictionary* dictionary in array){
        NSString* dictionaryId = dictionary[@"id"];
        if ([dictionaryId isEqualToString:rottenTomatoesId]){
            return YES;
        }
    }
    return NO;
}

@end
