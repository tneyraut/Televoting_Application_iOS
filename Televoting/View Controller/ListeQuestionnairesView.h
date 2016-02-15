//
//  ListeQuestionnairesView.h
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 11/04/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QuestionnaireModel.h"
#import "QuestionModel.h"
#import "ReponseModel.h"
#import "PropositionReponseModel.h"

@interface ListeQuestionnairesView : UITableViewController <UITableViewDataSource, UITableViewDelegate, QuestionnaireModelProtocol, QuestionModelProtocol, ReponseModelProtocol, PropositionReponseModelProtocol>

@property(nonatomic,strong) NSMutableArray *questionsReponses;

@property(nonatomic,strong) NSMutableArray *reponsesEffectuees;

@property(nonatomic) int user_id;

@property(nonatomic) int cours_id;

@end
