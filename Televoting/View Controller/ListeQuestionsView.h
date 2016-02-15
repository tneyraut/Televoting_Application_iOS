//
//  ListeQuestionsView.h
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 11/04/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QuestionModel.h"
#import "ReponseModel.h"
#import "PropositionReponseModel.h"
#import "ParticipantModel.h"

#import "Question.h"
#import "Reponse.h"
#import "Questionnaire.h"

@interface ListeQuestionsView : UITableViewController <UITableViewDataSource, UITableViewDelegate, QuestionModelProtocol, ReponseModelProtocol, PropositionReponseModelProtocol, ParticipantModelProtocol>

@property(nonatomic,weak) Questionnaire *questionnaireChoisi;

@property(nonatomic) int user_id;

@property(nonatomic) BOOL reponseEffectuee;

@property(nonatomic,strong) NSMutableArray *reponsesEffectuees;

@property(nonatomic,strong) NSMutableArray *bonnesReponses;

@end
