//
//  UserNamecardViewController.h
//  Business Card
//
//  Allows user to view his/her own namecard. User can choose to edit his/her profile details or profile image by clicking edit button.
//  When user click on the QR Code button, it will show the qr code of his/her profile.
//
//  Created by Kar Mun Pui on 6/06/14.
//  Copyright (c) 2014 Kar Mun Pui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDetailsViewController.h"
#import "QRCodeViewController.h"

@interface UserNamecardViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *idnumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)QRCode:(id)sender;

@property (nonatomic, strong) UIImage *image;
@property (strong) NSManagedObject *user;
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) UIManagedDocument *document;

@end
