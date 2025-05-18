global with sharing class BatchApexStructure implements Database.Batchable<sObject>, Database.Stateful{

    public Integer recCount = 0;

    global Database.QueryLocator start(Database.BatchableContext BC){

        String query = 'SELECT Id, Active__c, Rating FROM ACCOUNT';
        return Database.getQueryLocator(query);
    
    }
    
    global void execute(Database.BatchableContext BC, List<Account> accList){

        for(Account acc:accList){
            if(acc.Active__c == 'Yes'){
                acc.Rating='Warm';
            }
            else {
                acc.Rating='Cold';
            }
            recCount = recCount + 1;
        }
        update accList;
    }

    public void finish(Database.BatchableContext bc){
        System.debug('Inside Finish Method');
        System.debug('Total Records ' +  recCount);
        System.debug('Batch id ' + BC.getJobId());
   // Get the ID of the AsyncApexJob representing this batch job
   // from Database.BatchableContext.
   // Query the AsyncApexJob object to retrieve the current job's information.
   AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
      TotalJobItems, CreatedBy.Email
      FROM AsyncApexJob WHERE Id =
      :bc.getJobId()];
   // Send an email to the Apex job's submitter notifying of job completion.
   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
   String[] toAddresses = new String[] {a.CreatedBy.Email};
   mail.setToAddresses(toAddresses);
   mail.setSubject('Apex Sharing Recalculation ' + a.Status);
   mail.setPlainTextBody
   ('The batch Apex job processed ' + a.TotalJobItems +
   ' batches with '+ a.NumberOfErrors + ' failures.');
   Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}
}