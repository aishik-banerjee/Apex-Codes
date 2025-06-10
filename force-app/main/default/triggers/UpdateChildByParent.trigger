trigger UpdateChildByParent on Account (after update) {

    if(Trigger.isAfter && Trigger.isUpdate){
        UpdateChildByParentClass.updateChild(Trigger.New, Trigger.OldMap);
    }

}