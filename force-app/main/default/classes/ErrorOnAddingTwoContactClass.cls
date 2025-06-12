public with sharing class ErrorOnAddingTwoContactClass {

    public static void errorTwoContact(List<Contact> conList, Map<Id, Contact> oldMap){

        Set<Id> accIds = new Set<Id>();
        Map<Id, Integer> mapOfAccts = new Map<Id, Integer>();
        
        for(Contact con : conList){
            if((oldMap == null && con.AccountId != null) || (con.AccountId != null && con.AccountId != oldMap.get(con.Id).AccountId)){
                accIds.add(con.AccountId);
            }
        }

        for(Account acc : [SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id IN :accIds]){
            mapOfAccts.put(acc.Id, acc.Contacts.size());
        }

        for(Contact con : conList){
            if(mapOfAccts.containsKey(con.AccountId) && mapOfAccts.get(con.AccountId) >= 2){
                con.addError('No More Contacts can be added');
            }
        }
    }
}