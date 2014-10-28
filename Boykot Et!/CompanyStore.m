//
//  CompanyStore.m
//  Boykot Et!
//
//  Created by Berk Mollamustafaoğlu on 11/10/2014.
//  Copyright (c) 2014 Berk Mollamustafaoğlu. All rights reserved.
//

#import "CompanyStore.h"
#import "Company.h"
#import "DataCollector.h"


@interface CompanyStore() <NSXMLParserDelegate>
{
    NSXMLParser *parser;
    
}

@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation CompanyStore

+(instancetype)sharedStore
{
    static dispatch_once_t once;
    static CompanyStore *sharedStore;
    
    dispatch_once(&once, ^{
        
        sharedStore = [[CompanyStore alloc] initPrivate];
    });
    
    return sharedStore;
}

-(instancetype)init
{
    @throw [NSException exceptionWithName:@"Wrong initializer" reason:@"CompanyStore is a singleton and must be referenced with the 'sharedStore' method" userInfo:nil];
}

-(instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        
        NSString *path = [self itemArchivePath];
        
        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!_privateItems) {
            _privateItems = [[NSMutableArray alloc] init];
            
            DataCollector *dataCollector = [[DataCollector alloc] init];
            
            NSArray *boykotArray = [[NSArray alloc] initWithArray:[dataCollector parseXMLFile:@"boykot"]];
            NSArray *destekArray = [[NSArray alloc] initWithArray:[dataCollector parseXMLFile:@"destek"]];
            
            _privateItems = [boykotArray mutableCopy];
            _privateItems = [[_privateItems arrayByAddingObjectsFromArray:destekArray] mutableCopy];
        }
    
    }
    
    return self;
}

-(NSString *)itemArchivePath
{
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *pathURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    
    return [pathURL absoluteString];
}

-(NSArray *)allItems
{
    return [self.privateItems copy];
}

-(BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    
    BOOL success = [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
    
    return success;
}




@end
