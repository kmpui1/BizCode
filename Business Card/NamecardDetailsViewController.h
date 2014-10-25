//
//  NamecardDetailsViewController.h
//  Business Card
//
//  Namecard details will be downloaded from the database so that all updates will be loaded and saved into the core data. Users can to add the namecard details into the address book.
//
//
//  Created by Kar Mun Pui on 7/06/14.
//  Copyright (c) 2014 Kar Mun Pui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AddNamecardViewController.h"
#import "NamecardData1.h"
#import "NamecardsViewController.h"

@interface NamecardDetailsViewController : UIViewController <ABNewPersonViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *namecardTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *namecardNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *namecardPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *namecardCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *namecardPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *namecardEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *namecardAddressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, retain) id qrstring;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) int page;
@property (nonatomic, retain) NSString * namecardName;
@property (nonatomic, retain) NSString * namecardId;
@property (strong) NSManagedObject *namecard;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (strong,nonatomic) UIManagedDocument *document;

- (IBAction)addContact:(id)sender;
- (IBAction)done:(id)sender;

@end
