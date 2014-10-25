//
//  QRCodeReader.h
//  My Business Card
//
//  User can use this QR Code scanner to scan other QR code, namecard found will be displayed in the namecard details screen.
//  The namecard found will be automatically save into the persistent store.
//
//  Created by Kar Mun Pui on 4/06/14.
//  Copyright (c) 2014 Kar Mun Pui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "NamecardDetailsViewController.h"

@interface QRCodeReader : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (weak,nonatomic) IBOutlet UIView *viewPreview;
@property (weak,nonatomic) IBOutlet UIBarButtonItem *bbitemStart;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

- (IBAction)startStopReading:(id)sender;

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender;

@end
