//
//  Participant.h
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 11/04/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Participant : NSObject

@property (nonatomic) int participant_id;
@property (nonatomic) int user_id;
@property (nonatomic) int questionnaire_id;
@property (nonatomic) int nombre_de_fautes;
@property (nonatomic) int nombre_de_bonnes_reponses;
@property (nonatomic) float note;

@end
