trigger RollUpOppAmtTrigger on Opportunity (after insert, after update, after delete, after undelete) {

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

                if(opp.Amount != Trigger.oldMap.get(opp.Id).Amount){
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
    }

    if(!accIds.isEmpty()){

        //SOLUTION 1

        // List<AggregateResult> aggResults = [SELECT AccountId accountId, SUM(Amount) totalAmount FROM Opportunity WHERE AccountId IN : accIds GROUP BY AccountId];
         List<Account> lstOfAccount = new List<Account>();

        // for(AggregateResult ag : aggResults){
        //     Account acc = new Account();
        //     acc.Id = (Id) ag.get('accountId');
        //     acc.AnnualRevenue = (Decimal)ag.get('totalAmount');
        //     lstOfAccount.add(acc);
        // }

        //SOLUTION 2

        for(Account acc : [SELECT Id,AnnualRevenue, (SELECT Id,Amount FROM Opportunities) FROM Account WHERE Id IN :accIds]){
            Decimal total = 0;
            if(acc.Opportunities.size() > 0){
                for(Opportunity opp : acc.Opportunities){
                    total = total + opp.Amount;
                }
                acc.AnnualRevenue = total;
                lstOfAccount.add(acc);
            }else {
                acc.AnnualRevenue = 0;
                lstOfAccount.add(acc);
            }
        }

        if(!lstOfAccount.isEmpty()){
            update lstOfAccount;
        }
    }

}