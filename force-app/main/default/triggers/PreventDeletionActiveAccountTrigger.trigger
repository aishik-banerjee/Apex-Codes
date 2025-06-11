trigger PreventDeletionActiveAccountTrigger on Account (before delete) {

    if(Trigger.isBefore){
        if(Trigger.isDelete){
            PreventDeletionActiveAccountClass.preventDeletion(Trigger.old);
        }
    }
}