//
//  ReviewHeader.h
//  RottenMangoes2
//
//  Created by Jeremy Petter on 2015-05-27.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewHeader : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerSynopsisLabel;

@end
