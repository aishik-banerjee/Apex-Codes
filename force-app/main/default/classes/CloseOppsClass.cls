public with sharing class CloseOppsClass {
    
    public static void closeMethod(List<Account> accList, Map<Id, Account> oldMap){

        Set<Id> accIds = new Set<Id>();
        List<Opportunity> lstOfOpps = new List<Opportunity>();

        for(Account acc : accList){
            accIds.add(acc.Id);
        }

        Date day30 = Date.today() - 30;

        for(Opportunity opp : [SELECT Id, StageName, CreatedDate FROM Opportunity WHERE AccountId IN :accIds]){
            if(opp.StageName != 'Closed Won' && opp.CreatedDate < day30 ){
                opp.StageName = 'Closed Lost';
                opp.CloseDate = Date.today();
                lstOfOpps.add(opp);
            }
        }

        if(!lstOfOpps.isEmpty()){
            update lstOfOpps;
        }
    }
}