//
//  InfoPageViewController.m
//  Boykot Et!
//
//  Created by Berk Mollamustafaoğlu on 28/10/2014.
//  Copyright (c) 2014 Berk Mollamustafaoğlu. All rights reserved.
//

#import "InfoPageViewController.h"

@interface InfoPageViewController () <UIAlertViewDelegate>
- (IBAction)doneButtonPressed:(id)sender;


@end

@implementation InfoPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    UIColor * color = [UIColor colorWithRed:255/255.0f green:248/255.0f blue:192/255.0f alpha:1.0f];
    self.view.backgroundColor = color;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)openBoykotEt:(id)sender {
    
    UIAlertView *openSafari = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"Are you sure you want to open Safari?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    [openSafari show];
 
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://boykotet.tk"]];

}

@end
