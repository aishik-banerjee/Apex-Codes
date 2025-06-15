trigger TaskStageNameTrigger on Opportunity (after update) {

    Map<Id,String> mapOfOpps = new Map<Id,String>();
    Map<Id,Id> mapOfTasks = new Map<Id,Id>();
    List<Task> lstOfTasks = new List<Task>();
    List<Task> lstOfTasksToUpdate = new List<Task>();

    if(Trigger.isAfter && Trigger.isUpdate){

        for(Opportunity opp : Trigger.New){
            if(opp.StageName != Trigger.oldMap.get(opp.Id).StageName){
                mapOfOpps.put(opp.Id, opp.StageName);
            }
        }

        for(Task tk : [SELECT Id, Description, WhatId FROM Task WHERE WhatId IN : mapOfOpps.keySet()]){
            mapOfTasks.put(tk.WhatId, tk.Id);
        }

        for(Opportunity opp : Trigger.new){
            if(mapOfTasks.containsKey(opp.Id)){

                Task task = new Task();
                task.Id = mapOfTasks.get(opp.Id);
                task.WhatId = opp.Id;
                task.Description = 'New StageName is : '+opp.StageName;
                lstOfTasksToUpdate.add(task);
            }else{
                Task t = new Task();
                t.WhatId = opp.Id;
                t.Description = mapOfOpps.get(opp.Id);
                lstOfTasks.add(t);
            }
        }

        if(!lstOfTasksToUpdate.isEmpty()){
            update lstOfTasksToUpdate;
        }

        if(!lstOfTasks.isEmpty()){
            insert lstOfTasks;
        }
    }
}