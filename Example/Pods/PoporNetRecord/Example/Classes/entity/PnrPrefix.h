
//
//  PnrPrefix.h
//  PoporNetRecord
//
//  Created by apple on 2019/3/11.
//  Copyright © 2019 wangkq. All rights reserved.
//

#ifndef PnrPrefix_h
#define PnrPrefix_h

#import "PnrEntity.h"

typedef void(^PnrBlockPVoid) (void);
typedef void(^PnrBlockPPnrEntity) (PnrEntity * pnrEntity);
typedef void(^PnrResubmitBlock)(PnrEntity * pnrEntity, NSDictionary * formDic);

#endif /* PnrPrefix_h */
