//
//  DataCollector.m
//  Boykot Et!
//
//  Created by Berk Mollamustafaoğlu on 24/10/2014.
//  Copyright (c) 2014 Berk Mollamustafaoğlu. All rights reserved.
//

#import "DataCollector.h"
#import "Company.h"
@interface DataCollector () <NSXMLParserDelegate>

@property (nonatomic, copy) NSString *whichList;

@end

@implementation DataCollector
{
    NSXMLParser *parser;
    Company *company;
    NSMutableString *elementValue;
    NSMutableArray *companyArray;
}


#pragma mark - XML Parser methods
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"company"]) {
        company = [[Company alloc] init];
    }
    elementValue = [[NSMutableString alloc] init];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [elementValue appendString:string];
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    
    if ([elementName isEqualToString:@"company"]) {
        [companyArray addObject:company];
        company.whichlist = self.whichList;
    }
    else if ([elementName isEqualToString:@"name"])
    {
        company.isim = elementValue;
        elementValue = nil;
        
    }
    
    else if ([elementName isEqualToString:@"isalani"])
    {
        company.isalani = elementValue;
        elementValue = nil;
        
        
    }
    else if ([elementName isEqualToString:@"owner"])
    {
        company.sahibi = elementValue;
        elementValue = nil;
       
        
    }
    else if ([elementName isEqualToString:@"sorumluluk"])
    {
        company.sorumluluk = elementValue;
        elementValue = nil;
        
        
    }
    else if ([elementName isEqualToString:@"gerekce"])
    {
        company.gerekce = elementValue;
        elementValue = nil;

    }
    

    
    
}

-(void)parserDidStartDocument:(NSXMLParser *)parser{
    companyArray = [[NSMutableArray alloc] init];
}

-(NSArray *)parseXMLFile:(NSString *)list
{
    self.whichList = list;

    if ([self.whichList isEqualToString:@"boykot"]) {
        NSURL *url = [[NSURL alloc] init];
        url = [[NSBundle mainBundle] URLForResource:@"boykot" withExtension:@"xml"];
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        
        parser = [[NSXMLParser alloc] initWithData:data];

    }
    if ([self.whichList isEqualToString:@"destek"]) {
        NSURL *url = [[NSURL alloc] init];
        url = [[NSBundle mainBundle] URLForResource:@"destek" withExtension:@"xml"];
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        parser = [[NSXMLParser alloc] initWithData:data];
    }
    
    parser.delegate = self;
    
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
    

    [companyArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Company *company1 = obj1;
        Company *company2 = obj2;
        
        return [company1.isim caseInsensitiveCompare:company2.isim];
    }];

    return companyArray;
}

@end
