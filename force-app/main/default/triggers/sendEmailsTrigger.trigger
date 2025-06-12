trigger sendEmailsTrigger on Account (after update) {

    if(Trigger.isAfter && Trigger.isUpdate){
        sendEmailsClass.sendMail(Trigger.new, Trigger.oldMap);
    }
}