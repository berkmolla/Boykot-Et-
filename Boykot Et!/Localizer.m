//
//  Localizer.m
//  Boykot Et!
//
//  Created by Berk Mollamustafaoğlu on 31/10/2014.
//  Copyright (c) 2014 Berk Mollamustafaoğlu. All rights reserved.
//

#import "Localizer.h"
#import "AppDelegate.h"
#import "CompanyStore.h"

@implementation Localizer


+(instancetype)sharedInstance
{
    static dispatch_once_t once;
    static Localizer *sharedInstance;
    
    dispatch_once(&once, ^{
        
        sharedInstance = [[Localizer alloc] initPrivate];
    });
    
    return sharedInstance;
 
    
}
-(instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        // Register for language change notification
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(updateLanguageVariable) name:NSUserDefaultsDidChangeNotification object:nil];
        
        [self updateLanguageVariable];
    }
    
    return self;
}
-(void)updateLanguageVariable
{
    _currentLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:LanguagePreferenceKey];
}

-(void)updateXMLFiles
{
    [[CompanyStore sharedStore] doParsing];
}
@end
