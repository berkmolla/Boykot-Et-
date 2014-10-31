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

@interface SearchResultsTableViewController ()

@end

@implementation SearchResultsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
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
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    
    Company *company = self.filteredArray[indexPath.row];
    assert(cell != nil);
    
    cell.textLabel.text = company.isim;
    
    return cell;
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
