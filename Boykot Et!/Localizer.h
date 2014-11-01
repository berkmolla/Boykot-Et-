//
//  Localizer.h
//  Boykot Et!
//
//  Created by Berk Mollamustafaoğlu on 31/10/2014.
//  Copyright (c) 2014 Berk Mollamustafaoğlu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Localizer : NSObject


@property (nonatomic, copy) NSString *currentLanguage;

+(instancetype)sharedInstance;
-(void)updateXMLFiles;

@end
