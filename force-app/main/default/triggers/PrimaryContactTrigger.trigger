trigger PrimaryContactTrigger on Contact (before insert, before update) {

    Set<Id> accIds = new Set<Id>();
    Map<Id, Integer> mapOfAccounts = new Map<Id, Integer>();

    if(Trigger.isBefore){

        if(Trigger.isInsert){
            for(Contact con : Trigger.new){
                if(con.AccountId != null){
                    accIds.add(con.AccountId);
                }
            }
        }

        if(Trigger.isUpdate){
            for(Contact con : Trigger.new){
                if(con.AccountId != Trigger.oldMap.get(con.Id).AccountId){
                    if(con.AccountId != null){
                        accIds.add(con.AccountId);
                    }
                    if(Trigger.oldMap.get(con.Id).AccountId != null){
                        accIds.add(Trigger.oldMap.get(con.Id).AccountId);
                    }
                }
                if(con.Level__c != Trigger.oldMap.get(con.Id).Level__c && con.AccountId!= null){
                    accIds.add(con.AccountId);
                }
            }
        }

        for(Account acc : [SELECT Id, (SELECT Id FROM Contacts WHERE Level__c = 'Primary') FROM Account WHERE Id IN : accIds]){
            if(acc.Contacts.size() >= 1){
                mapOfAccounts.put(acc.Id, acc.Contacts.size());
            }
        }

        for(Contact con : Trigger.new){
            if(mapOfAccounts.containsKey(con.AccountId)){
                con.addError('Only 1 Primary Contact allowed per Account');
            }
        }
    }
}