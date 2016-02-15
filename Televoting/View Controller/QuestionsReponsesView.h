//
//  QuestionsReponsesView.h
//  Televoting
//
//  Created by Thomas Mac on 17/06/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ListeQuestionnairesView.h"

#import "User.h"
#import "Questionnaire.h"

#import "ParticipantModel.h"

@interface QuestionsReponsesView : UITableViewController <UITableViewDataSource, UITableViewDelegate, ParticipantModelProtocol, PropositionReponseModelProtocol>

@property(nonatomic, weak) ListeQuestionnairesView *listeQuestionnairesView;

@property(nonatomic) int user_id;

@property(nonatomic, weak) NSMutableArray *questionsReponses;

@property(nonatomic, weak) Questionnaire *questionnaireChoisi;

@end
