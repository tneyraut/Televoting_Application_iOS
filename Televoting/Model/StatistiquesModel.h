//
//  StatistiquesModel.h
//  Televoting
//
//  Created by Thomas Mac on 13/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StatistiquesModelProtocol <NSObject>

- (void) statistiquesDownloaded:(NSArray*)items;

@end

@interface StatistiquesModel : NSObject <NSURLConnectionDataDelegate>

@property(nonatomic) int mode;

@property(nonatomic, weak) id<StatistiquesModelProtocol> delegate;

- (void) getStatistiquesParticipantsByQuestionnaire:(int)questionnaire_id;

- (void) getStatistiquesQuestionsByQuestionnaire:(int)questionnaire_id;

- (void) getStatistiquesByQuestion:(int)question_id;

- (void) getStatistiquesReponsesByQuestion:(int)question_id questionnaire_id:(int)questionnaire_id;

@end
