//
//  DetailViewController.m
//  Boykot Et!
//
//  Created by Berk Mollamustafaoğlu on 11/10/2014.
//  Copyright (c) 2014 Berk Mollamustafaoğlu. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ownerLabel;
@property (weak, nonatomic) IBOutlet UILabel *sectorLabel;
@property (weak, nonatomic) IBOutlet UILabel *responsibilityLabel;
@property (weak, nonatomic) IBOutlet UILabel *reason;

@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *companyOwner;
@property (weak, nonatomic) IBOutlet UILabel *companySector;
@property (weak, nonatomic) IBOutlet UILabel *companyResponsibility;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)configureView {
    // Update the user interface for the detail item.
    if (!self.company) {
        
        // If there is no company selected, load the empty company XIB and set label
        NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"CompanyDetails" owner:self options:nil];
              self.view = [xib objectAtIndex:0];
        self.detailDescriptionLabel.text = NSLocalizedString(@"No company selected", @"The detail view controller when no company is selected");
    }
    if (self.company) {
        
        // Paint background based on the list the company is on
        if ([self.company.whichlist isEqualToString:@"boykot"])
            self.view.backgroundColor = [UIColor redColor];
        else
            self.view.backgroundColor = [UIColor greenColor];
        
        UIColor * color = [UIColor colorWithRed:255/255.0f green:248/255.0f blue:192/255.0f alpha:1.0f];
        UIView *labelBackgroundView = [self.view.subviews objectAtIndex:0];
        labelBackgroundView.backgroundColor = color;
        //labelBackgroundView.clipsToBounds = YES;
        
        
        [self setFontsandLabels];
        self.title = NSLocalizedString(@"Company Details", @"Company details title");
        
    }
    
    UIButton *infoButtonItem = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButtonItem addTarget:self action:@selector(goToInfoPage) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButtonItem];
    
    
}
-(void)goToInfoPage
{
    [self performSegueWithIdentifier:@"showInfo" sender:self];

}
-(UIFont *)changeFontForTitleLabels
{
    UIFontDescriptor *userFont = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    float userFontSize = [userFont pointSize];
    UIFont *font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:userFontSize];
    return font;
    
}
-(UIFont *)changeFontForCompanyDetailLabels;
{
    UIFontDescriptor *userFont = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    float userFontSize = [userFont pointSize];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:userFontSize];
    return font;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setFontsandLabels
{
    // Set fonts
    [self.companyName setFont:[self changeFontForCompanyDetailLabels]];
    [self.companyOwner setFont:[self changeFontForCompanyDetailLabels]];
    [self.companyResponsibility setFont: [self changeFontForCompanyDetailLabels]];
    [self.companySector setFont:[self changeFontForCompanyDetailLabels]];
    [self.reason setFont:[self changeFontForCompanyDetailLabels]];
    
    [self.nameLabel setFont:[self changeFontForTitleLabels]];
    [self.sectorLabel setFont:[self changeFontForTitleLabels]];
    [self.responsibilityLabel setFont:[self changeFontForTitleLabels]];
    [self.ownerLabel setFont:[self changeFontForTitleLabels]];
    
    
    // Set labels
    self.nameLabel.text = NSLocalizedString(@"Name:", @"nameLabel in Detail View Controller");
    self.ownerLabel.text = NSLocalizedString(@"Owner:", @"ownerLabel in Detail View Controller");
    self.sectorLabel.text = NSLocalizedString(@"Sector:", @"sectorLabel in Detail View Controller");
    self.responsibilityLabel.text = NSLocalizedString(@"Responsibility:", @"responsibilityLabel in Detail View Controller");
    
    self.companyName.text = self.company.isim;
    self.companyOwner.text = self.company.sahibi;
    self.companySector.text = self.company.isalani;
    self.companyResponsibility.text = self.company.sorumluluk;
    self.reason.text = self.company.gerekce;
    
    
    [self.reason setLineBreakMode:NSLineBreakByWordWrapping];
    [self.reason setNumberOfLines:0];
    [self.reason setAdjustsFontSizeToFitWidth:YES];
    [self.reason setMinimumScaleFactor:0.5];
    //[self.reason setPreferredMaxLayoutWidth:200];
    
}

@end
