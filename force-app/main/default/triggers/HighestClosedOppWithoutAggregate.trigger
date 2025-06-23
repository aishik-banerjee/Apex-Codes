trigger HighestClosedOppWithoutAggregate on Opportunity (after insert, after update, after delete, after undelete) {

    Set<Id> accIds = new Set<Id>();
    List<Account> lstOfAccounts = new List<Account>();
    Map<Id, Decimal> mapOfAccts = new Map<Id, Decimal>();

    if(Trigger.isAfter){

        if(Trigger.isInsert || Trigger.isUndelete){
            for(Opportunity opp : Trigger.new){
                if(opp.AccountId != null){
                    accIds.add(opp.AccountId);
                }
            }
        }

        if(Trigger.isDelete){
            for(Opportunity opp : Trigger.old){
                if(opp.AccountId != null){
                    accIds.add(opp.AccountId);
                }
            }
        }

        if(Trigger.isUpdate){
            for(Opportunity opp : Trigger.new){
                if((opp.Amount != Trigger.oldMap.get(opp.Id).Amount) && opp.AccountId != null){
                    accIds.add(opp.AccountId);
                }
                if(opp.AccountId != Trigger.oldMap.get(opp.Id).AccountId){
                    if(opp.AccountId != null){
                        accIds.add(opp.AccountId);
                    }
                    if(Trigger.oldMap.get(opp.Id).AccountId != null){
                        accIds.add(Trigger.oldMap.get(opp.Id).AccountId);
                    }
                }
            }
        }


        for(Opportunity opp : [SELECT Id, AccountId, Amount FROM Opportunity WHERE AccountId IN :accIds AND IsClosed = true]){
            Decimal maxAmt = mapOfAccts.get(opp.AccountId);
            if(maxAmt == null || opp.Amount > maxAmt){
                mapOfAccts.put(opp.AccountId, opp.Amount);
            }
            }

        for(Id accId : mapOfAccts.keySet()){
            Account acc = new Account();
            acc.Id = accId;
            acc.Description = 'Max opp amount is ' + mapOfAccts.get(accId);
            lstOfAccounts.add(acc);
        }

        if(!lstOfAccounts.isEmpty()){
            update lstOfAccounts;
        }
        }
}
