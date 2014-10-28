//
//  CompanyStore.h
//  Boykot Et!
//
//  Created by Berk Mollamustafaoğlu on 11/10/2014.
//  Copyright (c) 2014 Berk Mollamustafaoğlu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;

+(instancetype)sharedStore;

@end
