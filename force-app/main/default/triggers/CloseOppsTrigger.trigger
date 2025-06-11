trigger CloseOppsTrigger on Account (after update) {

    if(Trigger.isAfter && Trigger.isUpdate){
        CloseOppsClass.closeMethod(Trigger.New, Trigger.oldMap);
    }

}