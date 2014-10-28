//
//  DetailViewController.h
//  Boykot Et!
//
//  Created by Berk Mollamustafaoğlu on 11/10/2014.
//  Copyright (c) 2014 Berk Mollamustafaoğlu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Company.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Company *company;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

