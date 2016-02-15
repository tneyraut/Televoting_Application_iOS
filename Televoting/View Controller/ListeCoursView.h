//
//  ListeCoursView.h
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 15/03/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CoursModel.h"
#import "UserModel.h"
#import "ParticipantModel.h"

#import "IdentificationView.h"

@interface ListeCoursView : UITableViewController <UITableViewDataSource, UITableViewDelegate, CoursModelProtocol, UserModelProtocol, ParticipantModelProtocol>

@property(nonatomic,weak) IdentificationView *identificationView;

@property(nonatomic,weak) NSString *login;

@property(nonatomic,weak) NSString *password;

@property(nonatomic) BOOL demandeIdentification;

@end
