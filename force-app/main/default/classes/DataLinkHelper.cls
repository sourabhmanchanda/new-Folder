public class DataLinkHelper {  
    public static void DataLinkHelper(List<Data_Link__c> dataLinkList){
        system.debug('dataLinkList ' + dataLinkList);
        Set<Id> accIdSet = new Set<Id>();        
        for( Data_Link__c dl : dataLinkList){
            if(dl.Account__c != null){
                accIdSet.add(dl.Account__c);
            }
        }   
        system.debug('accIdSet ' + accIdSet);
        map<ID,account> mapIdVSAccount = new map<ID,account>([SELECT id, DL_Client__c,DL_No_of_Installs__c FROM Account WHERE ID IN : accIdSet]);
        system.debug('mapIdVSAccount ' + mapIdVSAccount);
        List<Data_Link__c> newDatalinkList = [SELECT Id, Account__c, Production_Installed__c, Production_Uninstalled__c, Sandbox_Uninstalled__c FROM Data_Link__c Where Account__c IN : accIdSet];
        system.debug('newDatalinkList ' + newDatalinkList);
        for( Data_Link__c dl : newDatalinkList){
            if(mapIdVSAccount.containsKey(dl.Account__c)){
                if(dl.Production_Installed__c != null && dl.Production_Uninstalled__c == null && dl.Account__c != null){
                    mapIdVSAccount.get(dl.Account__c).DL_Client__c ='Production';
        			system.debug('mapIdVSAccount.get(dl.Account__c).DL_No_of_Installs__c ' + mapIdVSAccount.get(dl.Account__c).DL_No_of_Installs__c);
                    mapIdVSAccount.get(dl.Account__c).DL_No_of_Installs__c = mapIdVSAccount.get(dl.Account__c).DL_No_of_Installs__c + 1;
        			system.debug('mapIdVSAccount.get(dl.Account__c).DL_No_of_Installs__c ' + mapIdVSAccount.get(dl.Account__c).DL_No_of_Installs__c);
                }
                else if(dl.Production_Installed__c == null && dl.Production_Uninstalled__c == null && dl.Account__c != null){
                    mapIdVSAccount.get(dl.Account__c).DL_Client__c ='Sandbox';
                }
                else if(dl.Production_Uninstalled__c != null || dl.Sandbox_Uninstalled__c != null){
                    mapIdVSAccount.get(dl.Account__c).DL_Client__c ='Former';
                }
                else {
                    mapIdVSAccount.get(dl.Account__c).DL_Client__c ='blank';
                }
            }
        }
        update mapIdVSAccount.values();
    }
    
    public static void updateAccountRecords(List<Data_Link__c> dataLinkList){
        Set<Id> accIdSet = new Set<Id>();        
        for( Data_Link__c dl : dataLinkList){
            if(dl.Account__c != null){
                accIdSet.add(dl.Account__c);
            }
        }
        map<ID,account> mapIdVSAccount = new map<ID,account>([SELECT id, DL_Client__c,DL_No_of_Installs__c FROM Account WHERE ID IN : accIdSet]);
        
        List<Data_Link__c> newDatalinkList = [SELECT Id, Account__c, Production_Installed__c, Production_Uninstalled__c FROM Data_Link__c Where Account__c IN : accIdSet];
        
        for( Data_Link__c dl : newDatalinkList){
            if(mapIdVSAccount.containsKey(dl.Account__c)){
                if(dl.Production_Installed__c != null && dl.Production_Uninstalled__c == null ){
                    mapIdVSAccount.get(dl.Account__c).DL_Client__c ='Production';
                    mapIdVSAccount.get(dl.Account__c).DL_No_of_Installs__c = mapIdVSAccount.get(dl.Account__c).DL_No_of_Installs__c + 1;
                }
                else if(dl.Production_Installed__c == null && dl.Production_Uninstalled__c == null ){
                    mapIdVSAccount.get(dl.Account__c).DL_Client__c ='Sandbox';
                }
                else if(dl.Production_Uninstalled__c != null || dl.Sandbox_Uninstalled__c != null){
                    mapIdVSAccount.get(dl.Account__c).DL_Client__c ='Former';
                }
                else {
                    mapIdVSAccount.get(dl.Account__c).DL_Client__c ='blank';
                }
            }
        }
        update mapIdVSAccount.values();
    }
    
    public static void updateAccountRecordsOnDLDeletion(List<Data_Link__c> dataLinkList){
        Set<Id> accIdSet = new Set<Id>();     
        for( Data_Link__c dl : dataLinkList){
            if(dl.Account__c != null){
                accIdSet.add(dl.Account__c);
            }
        }
        system.debug('accIdSet ' + accIdSet);
        map<ID,account> mapIdVSAccount = new map<ID,account>([SELECT id, DL_Client__c,DL_No_of_Installs__c FROM Account WHERE ID IN : accIdSet]);
        List<Account> accountList = [SELECT ID from Account Where Id IN : accIdSet];
        
        List<Data_Link__c> newDatalinkList = [SELECT Id, Account__c, Production_Installed__c, Production_Uninstalled__c FROM Data_Link__c Where Account__c IN : accIdSet];
        system.debug('newDatalinkList ' + newDatalinkList);
        for( Data_Link__c dl : newDatalinkList){
            if(mapIdVSAccount.containsKey(dl.Account__c)){
                if(dl.Production_Installed__c != null && dl.Production_Uninstalled__c == null ){
                    system.debug('number of installs ' + mapIdVSAccount.get(dl.Account__c).DL_No_of_Installs__c);
                    mapIdVSAccount.get(dl.Account__c).DL_No_of_Installs__c = mapIdVSAccount.get(dl.Account__c).DL_No_of_Installs__c - 1;
                }
            }
        }
        update mapIdVSAccount.values();
    }
}