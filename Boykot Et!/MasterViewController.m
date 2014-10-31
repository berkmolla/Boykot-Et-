//
//  MasterViewController.m
//  Boykot Et!
//
//  Created by Berk Mollamustafaoğlu on 11/10/2014.
//  Copyright (c) 2014 Berk Mollamustafaoğlu. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "CompanyStore.h"
#import "Company.h"
#import "SearchResultsTableViewController.h"

@interface MasterViewController () <UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, UIViewControllerRestoration>

@property (nonatomic, strong) NSArray *companyArray;

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) SearchResultsTableViewController *searchResultsController;
@property (nonatomic, strong) NSMutableArray *searchArray;

@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;


@end

@implementation MasterViewController

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    
    self.companyArray = [[CompanyStore sharedStore] allItems];
    self.searchResultsController = [[SearchResultsTableViewController alloc] init];
    self.searchResultsController.tableView.restorationIdentifier = @"SearchResultsTableView";

    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultsController];
    
    self.searchController.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;

    self.searchController.searchBar.delegate = self;
    self.searchResultsController.tableView.delegate = self;
    
    self.definesPresentationContext = YES;
    
    self.title = NSLocalizedString(@"List", @"The title for the list");
  
    self.searchController.restorationIdentifier = NSStringFromClass([self.searchController class]);
    self.searchController.searchBar.restorationIdentifier = NSStringFromClass([self.searchController.searchBar.restorationIdentifier class]);

    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // restore the searchController's active state
    if (self.searchControllerWasActive) {
        self.searchController.active = self.searchControllerWasActive;
        _searchControllerWasActive = NO;
        
        if (self.searchControllerSearchFieldWasFirstResponder) {
            [self.searchController.searchBar becomeFirstResponder];
            _searchControllerSearchFieldWasFirstResponder = NO;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)insertNewObject:(id)sender {
//    if (!self.objects) {
//        self.objects = [[NSMutableArray alloc] init];
//    }
//    [self.objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        Company *company = [[Company alloc] init];
        
        NSIndexPath *indexPath = [sender indexPathForSelectedRow];
        
        if (sender == self.tableView) {
            
            NSPredicate *predicate = [[NSPredicate alloc] init];
            
            if (indexPath.section == 1) {
                predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                    return [[evaluatedObject whichlist] isEqualToString:@"boykot"];
                }];
                
            }
            else if (indexPath.section == 0) {
                predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                    return [[evaluatedObject whichlist] isEqualToString:@"destek"];
                }];
            }
            
            NSArray *filteredArray = [self.companyArray filteredArrayUsingPredicate:predicate];
            company = filteredArray[indexPath.row];
        }
        else {
            company = self.searchResultsController.filteredArray[indexPath.row];
            NSLog(@"%@", company.isim);
        }
        
        DetailViewController *dvController = (DetailViewController *)[[segue destinationViewController] topViewController];
        //DetailViewController *dvController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        dvController.company = company;
        
        //[self.navigationController showDetailViewController:dvController sender:self];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showDetail" sender:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSPredicate *predicate = [[NSPredicate alloc] init];
    NSArray *filteredArray = [[NSArray alloc] init];
    
    if (section == 1) {
        predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [[evaluatedObject whichlist] isEqualToString:@"boykot"];
        }];
        
    }
    else if (section == 0) {
        predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [[evaluatedObject whichlist] isEqualToString:@"destek"];
        }];
    }
    
    // Filter the company array based on which list the objects are in
    filteredArray = [self.companyArray filteredArrayUsingPredicate:predicate];
    
    // Return number of objects in the list (which determines number of rows in that section)
    return [filteredArray count];

}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = [[NSString alloc] init];
    
    if (section == 1) {
        title = NSLocalizedString(@"Boykot listesi", @"The header title for the boykot list");
    }
    if (section == 0) {
        title = NSLocalizedString(@"Destek listesi", @"The header title for the destek list");
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Company *company = [[Company alloc] init];
    NSPredicate *predicate = [[NSPredicate alloc] init];

        if (indexPath.section == 1) {
            predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                return [[evaluatedObject whichlist] isEqualToString:@"boykot"];
            }];
        
        }
        else if (indexPath.section == 0) {
            predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                return [[evaluatedObject whichlist] isEqualToString:@"destek"];
            }];
        }
   
        NSArray *filteredArray = [self.companyArray filteredArrayUsingPredicate:predicate];
        company = filteredArray[indexPath.row];
    
    cell.textLabel.text = company.isim;
    
    cell.textLabel.font = [self tableViewFonts];
    return cell;

}
-(UIFont *)tableViewFonts
{
    UIFontDescriptor *userFont = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    float userFontSize = [userFont pointSize];
    UIFont *font = [UIFont fontWithName:@"ArialHebrew-Bold" size:userFontSize];
    
    return font;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}
-(void)presentSearchController:(UISearchController *)searchController
{
    [self.searchController.searchBar becomeFirstResponder];
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSMutableArray *searchResults = [self.companyArray mutableCopy];
    NSString *searchString = searchController.searchBar.text;
            
//    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
//        return [[evaluatedObject sorumluluk] containsString:searchString];
//    }];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isim CONTAINS[cd] %@", searchString];
    
    [searchResults filterUsingPredicate:predicate];
    
    
    [searchResults sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *name1 = [obj1 isim];
        NSString *name2 = [obj2 isim];
        
        return [name1 caseInsensitiveCompare:name2];
    }];
    
    
    self.searchResultsController.filteredArray = searchResults;
    
    [self.searchResultsController.tableView reloadData];
}

#pragma mark - state restoration
static NSString *SearchControllerIsActiveKey = @"SearchControllerIsActiveKey";
static NSString *SearchBarTextKey = @"SearchBarTextKey";
static NSString *SearchBarIsFirstResponderKey = @"SearchBarIsFirstResponderKey";

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    UISearchController *searchController = self.searchController;
    
    // encode the search controller's active state
    BOOL searchDisplayControllerIsActive = searchController.isActive;
    [coder encodeBool:searchDisplayControllerIsActive forKey:SearchControllerIsActiveKey];
    
    // encode the first responser status
    if (searchDisplayControllerIsActive) {
        [coder encodeBool:[searchController.searchBar isFirstResponder] forKey:SearchBarIsFirstResponderKey];
    }
    
    // encode the search bar text
    [coder encodeObject:searchController.searchBar.text forKey:SearchBarTextKey];
}
-(void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    // restore the active state:
    // we can't make the searchController active here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerWasActive = [coder decodeBoolForKey:SearchControllerIsActiveKey];
    
    // restore the first responder status:
    // we can't make the searchController first responder here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerSearchFieldWasFirstResponder = [coder decodeBoolForKey:SearchBarIsFirstResponderKey];
    
    // restore the text in the search field
    self.searchController.searchBar.text = [coder decodeObjectForKey:SearchBarTextKey];
}
+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)path
                                                            coder:(NSCoder *)coder
{
    return [[self alloc] init];
}


@end
