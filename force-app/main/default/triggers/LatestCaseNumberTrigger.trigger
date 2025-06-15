trigger LatestCaseNumberTrigger on Case (after insert) {

    Map<Id,String> mapOfCaseNumbers = new Map<Id,String>();
    List<Account> lstOfAccounts = new List<Account>();

    if(Trigger.isAfter && Trigger.isInsert){
        for(Case cs :Trigger.new){
            if(cs.AccountId != null){
                mapOfCaseNumbers.put(cs.AccountId, cs.CaseNumber);
            }
        }
    }

    for(Account acc : [SELECT Id, Description FROM Account WHERE Id IN :mapOfCaseNumbers.keySet()]){
        acc.Description = mapOfCaseNumbers.get(acc.Id);
        lstOfAccounts.add(acc);
    }

    if(!lstOfAccounts.isEmpty()){
        update lstOfAccounts;
    }
}