trigger UpdateParentByChild on Contact (after update) {

    if(Trigger.isAfter && Trigger.isUpdate){
        UpdateParentByChildClass.updateParent(Trigger.New, Trigger.OldMap);
    }
}