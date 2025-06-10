trigger RollUpTrigger on Contact (after insert, after update, after delete, after undelete) {

    Set<Id> accIds = new Set<Id>();
    List<Account> lstOfAccount = new List<Account>();
    if(Trigger.isAfter){

        if(Trigger.isInsert || Trigger.isUndelete){
            for(Contact con : Trigger.New){
                if(con.AccountId != null){
                    accIds.add(con.AccountId);
                }
            }
        }

        if(Trigger.isDelete){
            for(Contact con : Trigger.Old){
                if(con.AccountId != null){
                    accIds.add(con.AccountId);
                }
            }
        }

        if(Trigger.isUpdate){
            for(Contact con:Trigger.New){
                if(con.AccountId != Trigger.oldMap.get(con.Id).AccountId){
                    if(con.AccountId != null){
                        accIds.add(con.AccountId);
                    }
                    if(Trigger.oldMap.get(con.Id).AccountId != null){
                        accIds.add(Trigger.oldMap.get(con.Id).AccountId);
                    }
                }
            }
        }

        for(Account acc : [SELECT Id, Description, (SELECT Id FROM Contacts) FROM Account WHERE Id IN :accIds]){
            if(acc.Contacts != null){
                acc.Description = String.valueOf(acc.Contacts.size());
                lstOfAccount.add(acc);
            }
        }

        /*List<AggregateResult> aggResult = [SELECT AccountId accId, COUNT(Id) totalContacts FROM Contact WHERE AccountId IN :accIds GROUP BY AccountId];

        for(AggregateResult agg : aggResult){
            Account acc = new Account();
            acc.Id=(Id)agg.get('accId');
            acc.Description = String.valueOf(agg.get('totalContacts'));
            lstOfAccount.add(acc);
        }*/

        if(!lstOfAccount.isEmpty()){
            update lstOfAccount;
        }

    }
}