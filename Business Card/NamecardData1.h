//
//  NamecardData1.h
//  Business Card
//
//  Created by Kar Mun Pui on 7/06/14.
//  Copyright (c) 2014 Kar Mun Pui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NamecardData1 : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * identity;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSString * title;

@end
