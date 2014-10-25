//
//  Users.h
//  Business Card
//
//  Created by Kar Mun Pui on 8/06/14.
//  Copyright (c) 2014 Kar Mun Pui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Users : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * idnum;

@end
