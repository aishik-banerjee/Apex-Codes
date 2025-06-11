public with sharing class CreateContactWhenActiveClass {
    
    public static void createContact(List<Account> accList, Map<Id, Account> oldMap){

        System.debug(accList);
        System.debug('OldMap ' + oldMap);

        List<Contact> lstOfContacts  = new List<Contact>();

        for(Account acc : accList){
            System.debug('acc '+ acc.Active__c);
            
            System.debug(acc);
            if((oldMap == null && acc.Active__c == 'Yes') || (acc.Active__c == 'Yes' && acc.Active__c != oldMap.get(acc.Id).Active__c)){
                Contact con = new Contact();
                con.LastName = acc.Name;
                con.AccountId = acc.Id;
                con.Phone = acc.Phone;
                lstOfContacts.add(con);
                System.debug('Hello Contact');
                System.debug('Contact '+ lstOfContacts);
                System.debug('Contacts '+ con);
                System.debug('Contacts '+ con.AccountId);
            }
        }

        if(!lstOfContacts.isEmpty()){
            insert lstOfContacts;
        }
    }
}