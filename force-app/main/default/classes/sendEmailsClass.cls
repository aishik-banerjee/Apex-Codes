public with sharing class sendEmailsClass {
    
    public static void sendMail(List<Account> accList, Map<Id,Account> oldMap){

        Set<Id> accIds = new Set<Id>();
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();

        for(Account acc : accList){
            if(acc.Type != oldMap.get(acc.Id).Type){
                accIds.add(acc.Id);
            }
        }

        for(Contact con : [SELECT Id, Email, Phone, AccountId, Name FROM Contact WHERE AccountId IN :accIds]){
            if(con.Email != null){

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTargetObjectId(con.Id);
                mail.setSenderDisplayName('System Administrator');
                mail.setSubject('Account Update Info.');

                String body = 'Dear '+ con.Name +',<br/>';
                body += 'Your account info has been updated successfully.';

                mail.setHtmlBody(body);
                mail.toAddresses = new String [] {con.Email};
                emailList.add(mail);
            }
        }

        if(!emailList.isEmpty()){
            Messaging.sendEmail(emailList);
        }

    }
}