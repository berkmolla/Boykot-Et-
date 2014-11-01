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
#import "CompanyCell.h"
#import "Localizer.h"

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
    
    
    self.searchController.restorationIdentifier = NSStringFromClass([self.searchController class]);
    self.searchController.searchBar.restorationIdentifier = NSStringFromClass([self.searchController.searchBar.restorationIdentifier class]);
    
    [self setTitlesAndLabelsBasedOnLanguage];
    
    // Change user defaults notification
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(reloadInterfaceAfterLanguageChange) name:NSUserDefaultsDidChangeNotification object:nil];

    
}

-(void)setTitlesAndLabelsBasedOnLanguage
{
    NSString *language = [[Localizer sharedInstance] currentLanguage];
    
    if ([language isEqualToString:@"tr"])
        self.title = @"Şirket listesi";
    else if ([language isEqualToString:@"en"])
        self.title = @"Company list";
}

-(void)reloadInterfaceAfterLanguageChange
{
    
    NSLog(@"language chaned");
    [self setTitlesAndLabelsBasedOnLanguage];
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // Table view Cell
    UINib *nib = [UINib nibWithNibName:@"CompanyCell" bundle:nil];
    
    // Register the nib
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
    
   
    
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
        
        NSString *language = [[Localizer sharedInstance] currentLanguage];
        
        if ([language isEqualToString:@"en"])
            title = @"Boycott list";
        else if ([language isEqualToString:@"tr"])
            title = @"Boykot listesi";
    }
    if (section == 0) {
        
        NSString *language = [[Localizer sharedInstance] currentLanguage];
        
        if ([language isEqualToString:@"en"])
            title = @"Support list";
        else if ([language isEqualToString:@"tr"])
            title = @"Destek listesi";
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompanyCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
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
    
    cell.nameLabel.text = company.isim;
    cell.nameLabel.font = [self tableViewFonts];
    cell.listLabel.text = company.whichlist;
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - Search Controller
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
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
