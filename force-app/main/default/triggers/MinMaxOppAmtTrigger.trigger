trigger MinMaxOppAmtTrigger on Opportunity (after insert, after update, after delete, after undelete) {

    Set<Id> accIds = new Set<Id>();

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

        //SOLUTION 1 USING AGGREGATE QUERY

        /*List<AggregateResult> aggResult = [SELECT MIN(Amount) minAmount, MAX(Amount) maxAmount, AccountId accId FROM Opportunity WHERE AccountId IN :accIds GROUP BY AccountId];
        List<Account> lstOfAccounts = new List<Account>();
        List<Account> lstOfAccts = new List<Account>();

        for(Id i : accIds){
            Account acc = new Account();
            acc.Id = i;
            acc.Description = 'Min Amount: 0,'+ ' Max Amount: 0';
            lstOfAccounts.add(acc);
        }

        if(!lstOfAccounts.isEmpty()){
            update lstOfAccounts;
        }

        for(AggregateResult agg : aggResult){
            Account acc = new Account();
            acc.Id = (Id) agg.get('accId');
            acc.Description = 'Min Amount: ' + String.valueOf(agg.get('minAmount')) + ' Max Amount: ' + String.valueOf(agg.get('maxAmount'));
            lstOfAccts.add(acc);
        }

        if(!lstOfAccts.isEmpty()){
            update lstOfAccts;
        }*/

        //SOLUTION 2 USING MAPS

        Map<Id, Decimal> mapOfMaxAmts = new Map<Id, Decimal>();
        Map<Id, Decimal> mapOfMinAmts = new Map<Id, Decimal>();
        List<Account> lstOfAccounts = new List<Account>();

        for(Opportunity opp : [SELECT Id, AccountId, Amount FROM Opportunity WHERE AccountId IN :accIds]){
            if(!mapOfMaxAmts.containsKey(opp.AccountId)){
                mapOfMaxAmts.put(opp.AccountId, opp.Amount);
            }else{
                mapOfMaxAmts.put(opp.AccountId, Math.max(mapOfMaxAmts.get(opp.AccountId), opp.Amount));
            }

            if(!mapOfMinAmts.containsKey(opp.AccountId)){
                mapOfMinAmts.put(opp.AccountId, opp.Amount);
            }else{
                mapOfMinAmts.put(opp.AccountId, Math.min(mapOfMinAmts.get(opp.AccountId), opp.Amount));
            }
        }

        for(Id i : accIds){
            Account acc = new Account();
            acc.Id = i;
            acc.Description = 'Min Amount: ' + String.valueOf(mapOfMinAmts.get(i)) + ' Max Amount: ' + String.valueOf(mapOfMaxAmts.get(i));
            lstOfAccounts.add(acc);
        }

        if(!lstOfAccounts.isEmpty()){
            update lstOfAccounts;
        }
    }

}