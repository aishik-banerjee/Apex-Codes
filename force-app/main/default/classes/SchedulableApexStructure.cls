public with sharing class SchedulableApexStructure implements Schedulable{
    
    public void execute(SchedulableContext SC){
        Database.executeBatch(new BatchApexStructure());
    }
}