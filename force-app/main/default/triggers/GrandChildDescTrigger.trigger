trigger GrandChildDescTrigger on OpportunityLineItem (after insert, after update, after delete, after undelete) {

    Set<Id> oppIds = new Set<Id>();
    List<Account> lstOfAccounts = new List<Account>();
    Map<Id,String> mapOfAccts = new Map<Id,String>();

    if(Trigger.isAfter){

        if(Trigger.isInsert || Trigger.isUndelete){
            for(OpportunityLineItem opp : Trigger.new){
                if(opp.OpportunityId != null){
                    oppIds.add(opp.OpportunityId);
                }
            }
        }

        if(Trigger.isDelete){
            for(OpportunityLineItem opp : Trigger.old){
                if(opp.OpportunityId != null){
                    oppIds.add(opp.OpportunityId);
                }
            }
        }

        if(Trigger.isUpdate){
            for(OpportunityLineItem opp : Trigger.new){
                if(opp.OpportunityId != Trigger.oldMap.get(opp.Id).OpportunityId){
                    if(opp.OpportunityId != null){
                        oppIds.add(opp.OpportunityId);
                    }
                    if(Trigger.oldMap.get(opp.Id).OpportunityId != null){
                        oppIds.add(Trigger.oldMap.get(opp.Id).OpportunityId);
                    }
                }
                if(opp.Description != Trigger.oldMap.get(opp.Id).Description){
                    oppIds.add(opp.OpportunityId);
                }
            }
        }

        for(Opportunity opp : [SELECT Id, AccountId,(SELECT Id, Description FROM OpportunityLineItems ORDER BY LastModifiedDate DESC LIMIT 1) FROM Opportunity WHERE Id IN:oppIds]){
            mapOfAccts.put(opp.AccountId, opp.OpportunityLineItems[0].Description);
        }

        for(Id i : mapOfAccts.keySet()){
            Account acct = new Account();
            acct.Id = i;
            acct.Description = String.valueOf(mapOfAccts.get(i));
            lstOfAccounts.add(acct);
        }

        System.debug('List of Accounts '+ lstOfAccounts);

        if(!lstOfAccounts.isEmpty()){
            update lstOfAccounts;
        }

}
}