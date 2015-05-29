//
//  TheatreCellTableViewCell.h
//  RottenMangoes2
//
//  Created by Jeremy Petter on 2015-05-28.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Theatre.h"

@interface TheatreCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (nonatomic) Theatre* theatre;

@end
