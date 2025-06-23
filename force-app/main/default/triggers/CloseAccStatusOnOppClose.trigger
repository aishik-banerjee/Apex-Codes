trigger CloseAccStatusOnOppClose on Opportunity (after update) {

    Set<Id> accIds = new Set<Id>();
    Map<Id,Opportunity> mapOfAccts = new Map<Id,Opportunity>();
    List<Account> lstOfAccounts = new List<Account>();

    if(Trigger.isAfter && Trigger.isUpdate){

        for(Opportunity opp : Trigger.New){
            if(opp.StageName != Trigger.oldMap.get(opp.Id).StageName && opp.AccountId != null){
                accIds.add(opp.AccountId);
            }
        }

        for(Opportunity opp : [SELECT Id, AccountId,StageName FROM Opportunity WHERE AccountId IN :accIds]){
            if(opp.StageName != 'Closed Won'){
                mapOfAccts.put(opp.AccountId, opp);
            }
        }

        for(Account acc : [SELECT Id, Description FROM Account WHERE Id IN :accIds]){
            if(mapOfAccts.containsKey(acc.Id)){
                acc.Description = 'This Account is open';
            }else{
                acc.Description = 'This Account is closed';
            }

            lstOfAccounts.add(acc);
        }

        if(!lstOfAccounts.isEmpty()){
            update lstOfAccounts;
        }

    }

}