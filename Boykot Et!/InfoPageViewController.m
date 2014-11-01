//
//  InfoPageViewController.m
//  Boykot Et!
//
//  Created by Berk Mollamustafaoğlu on 28/10/2014.
//  Copyright (c) 2014 Berk Mollamustafaoğlu. All rights reserved.
//

#import "InfoPageViewController.h"
#import "Localizer.h"

@interface InfoPageViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *infoLabel1;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel2;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel3;
- (IBAction)doneButtonPressed:(id)sender;


@end

@implementation InfoPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    UIColor * color = [UIColor colorWithRed:255/255.0f green:248/255.0f blue:192/255.0f alpha:1.0f];
    self.view.backgroundColor = color;
    
    [self setTitlesAndLabels];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(setTitlesAndLabels) name:NSUserDefaultsDidChangeNotification object:nil];
    


}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setTitlesAndLabels
{
    Localizer *currentPrefs = [Localizer sharedInstance];
    
    if ([currentPrefs.currentLanguage isEqualToString:@"en"])
    {
        self.infoLabel1.text = @"This application contains a list of companies that either took action to help the peaceful protesters during the Taksim Gezi Parkı protests, or refused to help them. The user may search for the name of the company they wish to inquire about and see the details of the company on the company details page (including the reason for their inclusion). Companies that are not included neither helped nor refused to help, making their status 'neutral'.";
        
        self.infoLabel2.text = @"This application is intended for informational purposes only and its contents do not reflect the views of the author. The decision to boycott or support the companies listed here is left solely to the user.";
        
        [self.infoLabel3 setText:@"The Turkish data was taken from boykotet.tk"];
        
    }
    
    else if ([currentPrefs.currentLanguage isEqualToString:@"tr"])
    {
        
        [self.infoLabel1 setText:@"Bu uygulama Taksim Gezi Parkı protestoları sırasında barışçı protestoculara yardım etmek için harekete geçen ya da onlara yardım etmeyi reddeden firmaların listesini içerir. Kullanıcı bilgi almak istediği firmanın adını arayabilir ve ayrıntı sayfasında firmayla ilgili ayrıntıları görebilir (listeye alınma nedeniyle birlikte). Listede olmayan firmalar yardım etmek ya da yardımı reddetmek konusunda bir şey yapmadıkları için statüleri 'tarafsız' olarak düşünülebilir."];
        
        [self.infoLabel2 setText:@"Bu uygulama yalnızca bilgi amacıyla hazırlanmıştır ve içeriği program yazarının görüşlerini yansıtmamaktadır. Buradaki firmaları desteklemek ya da boykot etmek kullanıcının kendisine kalmıştır." ];
        
        [self.infoLabel3 setText:@"Türkçe veriler boykotet.tk sitesinden alınmıştır"];
        
    }
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
