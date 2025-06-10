public with sharing class UpdateParentByChildClass {
    
    public static void updateParent(List<Contact> conList, Map<Id, Contact> oldMap){

        Set<Id> accIds = new Set<Id>();
        List<Account> lstOfAccounts = new List<Account>();

        for(Contact con:conList){
            if(con.AccountId != null && con.Description != oldMap.get(con.Id).Description){
                accIds.add(con.AccountId);
            }
        }

        Map<Id, Account> mapOfAccounts = new Map<Id, Account>([SELECT Id, Description FROM Account WHERE Id IN :accIds]);

        if(!mapOfAccounts.isEmpty()){
            for(Contact con : conList){
            Account acc = mapOfAccounts.get(con.AccountId);
            acc.Description = con.Description;
            lstOfAccounts.add(acc);
        }

        if(!lstOfAccounts.isEmpty()){
            update lstOfAccounts;
        }
        }
    }
}