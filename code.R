library(plyr)
library(dplyr)
library(plotly)
library(ggplot2)
library(mice)
library(randomForest)
library(dummies)
train_full_sq = train %>% filter(full_sq<400 | is.na(full_sq))
train_full_life_sq = train_full_sq %>% filter(life_sq<400 | is.na(life_sq))
tempData = mice(data=train_full_life_sq[c('full_sq','life_sq')])
completeData = complete(tempData,1)
train_full_sq_imp = train_full_life_sq
train_full_sq_imp$life_sq = completeData$life_sq
train_full_sq_imp$price_doc = as.numeric(train_full_sq_imp$price_doc)
train_full_sq_imp$full_sq = as.numeric(train_full_sq_imp$full_sq)
train_full_sq_imp$full_all = as.numeric(train_full_sq_imp$full_all)
train_full_sq_imp$life_sq= as.numeric(train_full_sq_imp$life_sq)
train_full_sq_imp$max_floor= as.numeric(train_full_sq_imp$max_floor)
train_max_floor=transform(train_full_sq_imp,max_floor_group=cut(max_floor,include.lowest=TRUE, breaks=c(0,5,10,15,20,25),labels=c(0,5,10,15,20)))
train_max_floor$max_floor_group = as.factor(train_max_floor$max_floor_group)
levels(train_max_floor$max_floor_group)
train_max_floor$max_floor_group  = addNA(train_max_floor$max_floor_group)
levels(train_max_floor$max_floor_group)
train_max_floor$floor = as.numeric(train_max_floor$floor)
train_max_floor$floor[train_max_floor$floor==0]<-NA
train_floor=transform(train_max_floor,floor_group=cut(floor,include.lowest=TRUE, breaks=c(1,2,4,8,12,77),labels=c(1,2,4,8,12)))
train_floor$floor_group  = addNA(train_floor$floor_group)
train_room = train_floor
train_room$num_room = as.numeric(train_room$num_room)
train_room=transform(train_room,room_group=cut(num_room,include.lowest=TRUE, breaks=c(0,1,2,4),labels=c(0,1,2)))
train_room$floor_group  = addNA(train_room$floor_group)
train_kitch  = train_room
train_kitch$kitch_sq = as.numeric(train_kitch$kitch_sq)
train_kitch=transform(train_kitch,kitch_group=cut(kitch_sq,include.lowest=TRUE, breaks=c(0,5,8,15),labels=c(0,5,10)))
train_kitch$kitch_group = as.factor(train_kitch$kitch_group)
train_kitch$kitch_group  = addNA(train_kitch$kitch_group)
train_state = train_kitch
train_state$state = as.numeric(train_state$state)
train_state$state[which(train_state$state=='33')]<-3
train_state$state = as.factor(train_state$state)
train_state$material = as.factor(train_state$material)
train_state$product_type = as.factor(train_state$product_type)

args = train_state[c('full_sq','price_doc','life_sq','full_all','floor_group','max_floor_group','material','room_group','kitch_group','state','product_type')]

test_args = test[c('full_sq','life_sq','floor','max_floor','material','num_room','kitch_sq','state','product_type')]
args$num_room = as.factor(args$num_room)
args$material = as.factor(args$material)
args$full_sq = as.numeric(args$full_sq)
args$price_doc = as.numeric(args$price_doc)
args=data.frame(args)
output=train_state[c('price_doc')]
test_args$num_room = as.factor(test_args$num_room)
test_args$material = as.factor(test_args$material)
test_args$full_sq = as.numeric(test_args$full_sq)
test_args$floor = as.numeric(test_args$floor)
test_args$max_floor = as.factor(test_args$max_floor)
test_args$state = as.factor(test_args$state)
test_args$product_type=as.factor(test_args$product_type)
test_args=data.frame(test_args)

output$price_doc = as.numeric(output$price_doc)
#model<-randomForest(data=args,output,keep.forest = TRUE)
model<-randomForest(price_doc ~ .,data=args,keep.forest = TRUE)
