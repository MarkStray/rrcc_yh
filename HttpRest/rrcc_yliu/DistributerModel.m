//
//  distributerModel.m
//  rrcc_yh
//
//  Created by user on 15/10/8.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "DistributerModel.h"

//
@implementation DistributerModel

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.id = [aDecoder decodeObjectForKey:@"id"];
        self.sitename = [aDecoder decodeObjectForKey:@"sitename"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.distance = [aDecoder decodeObjectForKey:@"distance"];
        self.isDefault = [aDecoder decodeBoolForKey:@"isDefault"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeObject:self.sitename forKey:@"sitename"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.distance forKey:@"distance"];
    [aCoder encodeBool:self.isDefault forKey:@"isDefault"];
}


@end

//
@implementation RegionModel

@end

//
@implementation HotBrandModel

@end

//
@implementation QAModel

@end

//
@implementation ActionModel

@end

//
@implementation StatusModel

@end

//
@implementation TopUpModel

@end

//
@implementation CreditRoleModel

@end














