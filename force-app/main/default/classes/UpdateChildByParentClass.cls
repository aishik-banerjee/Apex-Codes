public with sharing class UpdateChildByParentClass {
    
    public static void updateChild(List<Account> accList, Map<Id, Account> oldMap){

        Map<Id, Account> mapOfAccounts = new Map<Id, Account>();
        List<Contact> lstOfContacts = new List<Contact>();

        for(Account acc : accList){
            if(acc.Phone != null && acc.Phone != oldMap.get(acc.Id).Phone){
                mapOfAccounts.put(acc.Id, acc);
            }
        }

        for(Contact con : [SELECT Id, AccountId, Phone FROM Contact WHERE AccountId IN :mapOfAccounts.keySet()]){
            if(mapOfAccounts.containsKey(con.AccountId)){
                con.Phone = mapOfAccounts.get(con.AccountId).Phone;
                lstOfContacts.add(con);
            }
        }

        if(!lstOfContacts.isEmpty()){
            update lstOfContacts;
        }
    }

}