trigger AccountContactTrigger on Account (after insert) {

    List<Contact> lstOfContacts = new List<Contact>();
    List<Account> lstOfAccounts = new List<Account>();
    Set<Id> accIds = new Set<Id>();

    if(Trigger.isAfter && Trigger.isInsert){
        for(Account acc : Trigger.new){
            Contact con = new Contact();
            con.LastName = acc.Name;
            con.AccountId = acc.Id;
            accIds.add(acc.Id);
            lstOfContacts.add(con);
        }

        if(!lstOfContacts.isEmpty()){
            insert lstOfContacts;
        }

        List<Account> accList = [SELECT Id,(SELECT Id FROM Contacts ORDER BY CreatedDate DESC LIMIT 1) FROM Account WHERE Id IN :accIds];

        for(Account acc : accList){
            acc.Contact__c = acc.Contacts[0].Id;
            lstOfAccounts.add(acc);
        }

        if(!lstOfAccounts.isEmpty()){
            update lstOfAccounts;
        }
    }

}