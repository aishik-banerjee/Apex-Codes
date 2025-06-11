trigger CreateContactWhenActive on Account (after insert, after update) {

    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate){
            CreateContactWhenActiveClass.createContact(Trigger.New, Trigger.oldMap);
        }
    }

}