trigger CasesStatusonAccount on Case (after insert, after update, after delete, after undelete) {

    Set<Id> accIds = new Set<Id>();
    List<Account> lstOfAccounts = new List<Account>();
    Map<Id,List<Case>> mapOfAccts = new Map<Id,List<Case>>();
    Integer newCs = 0;
    Integer closed = 0;
    Integer escalated = 0;
    Integer working = 0;

    if(Trigger.isAfter){

        if(Trigger.isInsert || Trigger.isUndelete){
            for(Case caseObj: Trigger.new){
                if(caseObj.AccountId != null){
                    accIds.add(caseObj.AccountId);
                }
            }
        }

        if(Trigger.isDelete){
            for(Case caseObj: Trigger.old){
                if(caseObj.AccountId != null){
                    accIds.add(caseObj.AccountId);
                }
            }
        }

        if(Trigger.isUpdate){
            for(Case caseObj: Trigger.new){
                if(caseObj.AccountId != Trigger.oldMap.get(caseObj.Id).AccountId){
                    if(caseObj.AccountId != null){
                        accIds.add(caseObj.AccountId);
                    }
                    if(Trigger.oldMap.get(caseObj.Id).AccountId != null){
                        accIds.add(Trigger.oldMap.get(caseObj.Id).AccountId);
                    }
                }
                if(caseObj.Status != Trigger.oldMap.get(caseObj.Id).Status){
                    accIds.add(caseObj.AccountId);
                }
            }
        }


        for(Case caseObj : [Select Id, AccountId, Status from Case where AccountId IN: accIds]){
            if(!mapOfAccts.containsKey(caseObj.AccountId)){
                mapOfAccts.put(caseObj.AccountId, new List<Case>());
            }
            mapOfAccts.get(caseObj.AccountId).add(caseObj);
        }

        for(Id accId : mapOfAccts.keySet()){
        
            for(Case cs : mapOfAccts.get(accId)){
                if(cs.Status == 'New'){
                    newCs = newCs + 1;
                }
                else if(cs.Status == 'Working'){
                    working = working + 1;
                }else if(cs.Status == 'Escalated'){
                    escalated = escalated + 1;
                }else{
                    closed = closed + 1;
                }
            }

            
            Account acc = new Account();
            acc.Id = accId;
            acc.Description = 'New : ' + String.valueOf(newCs) + ', Working : ' + String.valueOf(working) + ', Escalated : ' + String.valueOf(escalated) + ', Closed : ' + String.valueOf(closed);

            lstOfAccounts.add(acc);
        }
    }

    if(!lstOfAccounts.isEmpty()){
        update lstOfAccounts;
    }
}