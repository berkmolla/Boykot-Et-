//
//  DetailViewController.m
//  Boykot Et!
//
//  Created by Berk Mollamustafaoğlu on 11/10/2014.
//  Copyright (c) 2014 Berk Mollamustafaoğlu. All rights reserved.
//

#import "DetailViewController.h"
#import "Localizer.h"

@interface DetailViewController () <UIViewControllerRestoration>
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
        
        NSString *language = [[Localizer sharedInstance] currentLanguage];
        
        if ([language isEqualToString:@"en"])
            self.detailDescriptionLabel.text = @"No company selected";
        else if ([language isEqualToString:@"tr"])
            self.detailDescriptionLabel.text = @"Şirket seçilmedi";
    }
    if (self.company) {
        
        // Paint background based on the list the company is on
        if ([self.company.whichlist isEqualToString:@"boykot"])
            self.view.backgroundColor = [UIColor redColor];
        else
            self.view.backgroundColor = [UIColor colorWithRed:186/255.0f green:245/255.0f blue:121/255.0f alpha:1.0f];
        
        UIColor * color = [UIColor colorWithRed:255/255.0f green:248/255.0f blue:192/255.0f alpha:1.0f];
        UIView *labelBackgroundView = [self.view.subviews objectAtIndex:0];
        labelBackgroundView.backgroundColor = color;
        
        
        [self setFontsandLabels];
        
    }
    
    UIButton *infoButtonItem = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButtonItem addTarget:self action:@selector(goToInfoPage) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButtonItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setFontsandLabels) name:NSUserDefaultsDidChangeNotification object:nil];
    
    
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    NSString *language = [[Localizer sharedInstance] currentLanguage];
    
    if ([language isEqualToString:@"en"]) {
        self.nameLabel.text = @"Name:";
        self.ownerLabel.text = @"Owner:";
        self.sectorLabel.text = @"Sector:";
        self.responsibilityLabel.text = @"Responsibility:";
        
        self.title = @"Company Details";
    }
    else if ([language isEqualToString:@"tr"]) {
        self.nameLabel.text = @"İsim:";
        self.ownerLabel.text = @"Sahibi:";
        self.sectorLabel.text = @"İş Alanı:";
        self.responsibilityLabel.text = @"Sorumluluk:";
        self.title = @"Şirket bilgileri";
    }
    
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

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(configureView) name:NSUserDefaultsDidChangeNotification object:nil];
    }
    
    return self;
}

#pragma mark - state restoration

+(UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    DetailViewController *vc = nil;
    
    UIStoryboard *storyboard = [coder decodeObjectForKey:UIStateRestorationViewControllerStoryboardKey];
    
    if (storyboard) {
        vc = (DetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        vc.restorationIdentifier = [identifierComponents lastObject];
        vc.restorationClass = [DetailViewController class];
    }
    return vc;
}
-(void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];

    [coder encodeObject:self.company forKey:@"company"];
    
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];

    self.company = [coder decodeObjectForKey:@"company"];
        
}
@end
