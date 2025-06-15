trigger GrandChildTrigger on OpportunityLineItem (after insert, after update, after delete, after undelete) {

    Set<Id> oppIds = new Set<Id>();
    List<Account> lstOfAccounts = new List<Account>();
    Map<Id,Integer> mapOfAccts = new Map<Id,Integer>();

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
            }
        }

        for(Opportunity opp : [SELECT Id, AccountId FROM Opportunity WHERE Id IN:oppIds]){
            mapOfAccts.put(opp.AccountId, 0);
        }

        for(AggregateResult aggr : [SELECT Opportunity.AccountId accId, COUNT(Id) totalCount FROM OpportunityLineItem WHERE Opportunity.AccountId IN :mapOfAccts.keySet() GROUP BY Opportunity.AccountId]){
            mapOfAccts.put((Id)aggr.get('accId'), (Integer)aggr.get('totalCount'));
        }

        for(Id i : mapOfAccts.keySet()){
            Account acct = new Account();
            acct.Id = i;
            acct.Description = 'Total Opportunity Line Items' + String.valueOf(mapOfAccts.get(i));
            lstOfAccounts.add(acct);
        }

        System.debug('List of Accounts '+ lstOfAccounts);

        if(!lstOfAccounts.isEmpty()){
            update lstOfAccounts;
        }
    }
}