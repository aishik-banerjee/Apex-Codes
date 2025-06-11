public with sharing class PreventDeletionActiveAccountClass {

    public static void preventDeletion(List<Account> accList){

        for(Account acc:accList){
            if(acc.Active__c == 'Yes'){
                acc.addError('Sorry! You cannot delete this Account as it is active');
            }
    }
}
}