//
//  ProfListeElevesTableViewController.h
//  Televoting
//
//  Created by Thomas Mac on 06/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GroupeModel.h"
#import "UserModel.h"
#import "AbsenceModel.h"
#import "RetardModel.h"

#import "Cours.h"

#import "ListeCoursView.h"

@interface ProfListeElevesTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, GroupeModelProtocol, UserModelProtocol, AbsenceModelProtocol, RetardModelProtocol>

@property(nonatomic, weak) Cours *coursSelected;

@property(nonatomic, weak) ListeCoursView *listeCoursView;

@end
