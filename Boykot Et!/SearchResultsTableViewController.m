//
//  SearchResultsTableViewController.m
//  Boykot Et!
//
//  Created by Berk Mollamustafaoğlu on 26/10/2014.
//  Copyright (c) 2014 Berk Mollamustafaoğlu. All rights reserved.
//

#import "Company.h"
#import "SearchResultsTableViewController.h"
#import "DetailViewController.h"
#import "CompanyCell.h"

@interface SearchResultsTableViewController ()

@end

@implementation SearchResultsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UINib *nib = [UINib nibWithNibName:@"CompanyCell" bundle:nil];
    
    // Register the nib
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cellID"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.filteredArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompanyCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    
    Company *company = self.filteredArray[indexPath.row];
    assert(cell != nil);
    
    cell.nameLabel.text = company.isim;
    cell.listLabel.text = company.whichlist;
    
    cell.nameLabel.font = [self tableViewFonts];
    cell.listLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
    cell.listLabel.textColor = ([company.whichlist isEqualToString:@"boykot"]) ? [UIColor redColor] : [UIColor colorWithRed:186/255.0f green:245/255.0f blue:121/255.0f alpha:1.0f];
    
    
    
    return cell;
}

-(UIFont *)tableViewFonts
{
    UIFontDescriptor *userFont = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    float userFontSize = [userFont pointSize];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:userFontSize];
    
    return font;
    
}

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        self.tableView.restorationIdentifier = @"SearchResultsTableView";
    }
    
    return self;
}

@end
