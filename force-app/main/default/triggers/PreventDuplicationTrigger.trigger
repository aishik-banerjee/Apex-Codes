trigger PreventDuplicationTrigger on Account (before insert, before update) {

    if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
            PreventDuplicationClass.preventDuplicate(Trigger.New, Trigger.oldMap);
        }
    }
}