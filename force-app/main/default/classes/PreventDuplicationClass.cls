public with sharing class PreventDuplicationClass {
    
    public static void preventDuplicate(List<Account> accList, Map<Id, Account> oldMap){

        Set<String> accNames = new Set<String>();
        Map<String,Account> mapOfAccounts = new Map<String,Account>();

        for(Account acc : accList){
            accNames.add(acc.Name.trim().toLowerCase());
        }

        List<Account> accListDB = [SELECT Id, Name FROM Account WHERE Name in : accNames];

            for(Account acc : accListDB){
                mapOfAccounts.put(acc.Name.trim().toLowerCase(), acc);
            }

            for(Account acc : accList){
            if(mapOfAccounts.containsKey(acc.Name.trim().toLowerCase())){
                Account existingAcc = mapOfAccounts.get(acc.Name.trim().toLowerCase());
                // Allow same record update, block true duplicates
                if (acc.Id == null || acc.Id != existingAcc.Id) {
                    acc.addError('Duplicate Account Name Found');
                }
            }
        }
    }
}