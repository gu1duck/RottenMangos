//
//  ReviewCell.m
//  RottenMangoes2
//
//  Created by Jeremy Petter on 2015-05-27.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "ReviewCell.h"

@implementation ReviewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithReview:(Review*)review{
    self.reviewerField.text = review.critic;
    self.publicationField.text = review.publication;
    self.freshnessField.text = review.freshness;
    self.quoteField.text = review.quote;
    self.linkField.text = review.link;
}

@end
