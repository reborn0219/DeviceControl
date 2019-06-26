//
//  UserAllHouseModel.m
//  YouLifeApp
//
//  Created by us on 15/11/26.
//  Copyright © 2015年 us. All rights reserved.
//

#import "UserUnitKeyModel.h"

@implementation UserUnitKeyModel

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self.type= [aDecoder decodeObjectForKey:@"type"] ;
    self.name= [aDecoder decodeObjectForKey:@"name"] ;
    self.bluename= [aDecoder decodeObjectForKey:@"bluename"] ;
    self.openkey=[aDecoder decodeObjectForKey:@"openkey"];
    self.version=[aDecoder decodeObjectForKey:@"version"];
    self.communityid=[aDecoder decodeObjectForKey:@"communityid"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.bluename forKey:@"bluename"];
    [aCoder encodeObject:self.openkey forKey:@"openkey"];
    [aCoder encodeObject:self.version forKey:@"version"];
    [aCoder encodeObject:self.communityid forKey:@"communityid"];
}
@end
