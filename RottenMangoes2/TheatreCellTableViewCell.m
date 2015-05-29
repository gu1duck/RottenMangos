//
//  TheatreCellTableViewCell.m
//  RottenMangoes2
//
//  Created by Jeremy Petter on 2015-05-28.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "TheatreCellTableViewCell.h"

@interface TheatreCellTableViewCell ()



@end

@implementation TheatreCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTheatre:(Theatre *)theatre{
    _theatre = theatre;
    [self setup];
    
}

-(void)setup{
    self.titleLabel.text = self.theatre.title;
    self.detailLabel.text = [NSString stringWithFormat:@"%.02f km",self.theatre.distance/1000];
}

@end
