trigger PreventContactDuplicationTrigger on Contact (before insert, before update) {

    if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
            PreventContactDuplicationClass.preventDuplication(Trigger.new, Trigger.oldMap);
        }
    }

}