trigger HighestOpportunityonAccTrigger on Opportunity (after insert, after update, after delete, after undelete) {

    Set<Id> accIds = new Set<Id>();
    List<Account> lstOfAccounts = new List<Account>();

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

        if(!accIds.isEmpty()){

            List<Account> accountList = [SELECT Id,Description,(SELECT Id, Amount, Name FROM Opportunities WHERE Amount != null ORDER BY Amount DESC LIMIT 1) FROM Account WHERE Id IN :accIds];

            for(Account acc : accountList){
                if(!acc.Opportunities.isEmpty()){
                    acc.Description = acc.Opportunities[0].Name;
                    lstOfAccounts.add(acc);
                }else{
                    acc.Description = '';
                    lstOfAccounts.add(acc);
                } 
            }

            if(!lstOfAccounts.isEmpty()){
                update lstOfAccounts;
            }
        }
    }
}