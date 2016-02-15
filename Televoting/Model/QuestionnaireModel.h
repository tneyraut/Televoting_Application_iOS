//
//  QuestionnaireModel.h
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 11/04/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QuestionnaireModelProtocol <NSObject>

- (void) questionnaireDownloaded : (NSArray*) items;

@end

@interface QuestionnaireModel : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic,weak) id<QuestionnaireModelProtocol> delegate;

- (void) getQuestionnairesByCours:(int)cours_id user_id:(int)userID;

- (void) getAllQuestionnairesByCours:(int)cours_id;

- (void) updateQuestionnaire:(int)questionnaire_id questionnaire_name:(NSString*)questionnaire_name mode_examen:(BOOL)mode_examen pause:(BOOL)pause lancee:(BOOL)lancee malus:(float)malus;

- (void) creerQuestionnaire:(int)cours_id questionnaire_name:(NSString*)questionnaire_name;

- (void) reinitialisationQuestionnaire:(int)questionnaire_id;

- (void) supprimerQuestionnaire:(int)questionnaire_id;

@end
