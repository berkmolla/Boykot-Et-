//
//  Company.m
//  Boykot Et!
//
//  Created by Berk Mollamustafaoğlu on 11/10/2014.
//  Copyright (c) 2014 Berk Mollamustafaoğlu. All rights reserved.
//

#import "Company.h"

@interface Company() <NSCoding>

@end

@implementation Company

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.isalani forKey:@"isalani"];
    [aCoder encodeObject:self.sahibi forKey:@"sahibi"];
    [aCoder encodeObject:self.isim forKey:@"isim"];
    [aCoder encodeObject:self.gerekce forKey:@"gerekce"];
    [aCoder encodeObject:self.whichlist forKey:@"whichlist"];
    [aCoder encodeObject:self.sorumluluk forKey:@"sorumluluk"];
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        _isalani = [aDecoder decodeObjectForKey:@"isalani"];
        _sahibi = [aDecoder decodeObjectForKey:@"sahibi"];
        _isim = [aDecoder decodeObjectForKey:@"isim"];
        _gerekce = [aDecoder decodeObjectForKey:@"gerekce"];
        _whichlist = [aDecoder decodeObjectForKey:@"whichlist"];
        _sorumluluk = [aDecoder decodeObjectForKey:@"sorumluluk"];
    }
    return self;
}

@end
