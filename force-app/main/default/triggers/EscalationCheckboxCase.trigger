trigger EscalationCheckboxCase on Case (after update) {

    Set<Id> accIds = new Set<Id>();
    Map<Id, Contact> mapOfPrimaryContacts = new Map<Id, Contact>();
    List<Task> lstOfTasks = new List<Task>();

    if(Trigger.isAfter && Trigger.isUpdate){

        for(Case cs : Trigger.new){
            if(cs.IsEscalated == true && cs.IsEscalated != Trigger.oldMap.get(cs.Id).IsEscalated && cs.AccountId != null){
                accIds.add(cs.AccountId);
            }
        }

        for(Contact con : [SELECT Id, AccountId,Level__c FROM Contact WHERE AccountId IN :accIds AND Level__c = 'Primary']){
            mapOfPrimaryContacts.put(con.AccountId, con);
        }
        
       

        for(Case cs : Trigger.new){

             if(cs.IsEscalated == true && cs.IsEscalated != Trigger.oldMap.get(cs.Id).IsEscalated && cs.AccountId != null){

                Contact con = mapOfPrimaryContacts.get(cs.AccountId);

                if(con != null){
                    Task tk = new Task();
                    tk.WhoId = con.Id;
                    tk.Subject = 'Escalate the Case';
                    tk.Status = 'In Progress';
            lstOfTasks.add(tk);
                }

            
             }
        }

        if(!lstOfTasks.isEmpty()){
            insert lstOfTasks;
        }

    }

}