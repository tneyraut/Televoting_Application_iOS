//
//  PropositionReponse.h
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 11/04/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropositionReponse : NSObject

@property (nonatomic) int proposition_reponse_id;
@property (nonatomic) int participant_id;
@property (nonatomic) int question_id;
@property (nonatomic) int reponse_id;

@end
