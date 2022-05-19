trigger DataLink on DATA_LINK__c (after insert, After update, after delete) {
    if(trigger.isAfter && trigger.isInsert){
        DataLinkHelper.DataLinkHelper(trigger.new);
    }
    if(trigger.isAfter && trigger.isUpdate){
        DataLinkHelper.updateAccountRecords(trigger.new);
    }
    if(trigger.isAfter && trigger.isDelete){
        DataLinkHelper.updateAccountRecordsOnDLDeletion(trigger.old);
    }
}