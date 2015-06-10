//
//  ReviewCell.h
//  RottenMangoes2
//
//  Created by Jeremy Petter on 2015-05-27.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Review.h"

@interface ReviewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *reviewerField;
@property (weak, nonatomic) IBOutlet UILabel *publicationField;
@property (weak, nonatomic) IBOutlet UILabel *freshnessField;
@property (weak, nonatomic) IBOutlet UILabel *quoteField;
@property (weak, nonatomic) IBOutlet UILabel *linkField;

- (void)setupWithReview:(Review*)review;

@end
