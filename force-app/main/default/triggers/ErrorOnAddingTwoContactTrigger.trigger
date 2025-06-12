trigger ErrorOnAddingTwoContactTrigger on Contact (before insert, before update) {

    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        ErrorOnAddingTwoContactClass.errorTwoContact(Trigger.new, Trigger.oldMap);
    }
}