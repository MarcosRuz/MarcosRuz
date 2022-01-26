public with sharing class MaintenanceRequestHelper {
    public static void updateWorkOrders(List<Case> casesAfterUpdate) {
        // TODO: Complete the method to update workorders
        Map<String, Integer> mapMinCycle = obterMinCycle(casesAfterUpdate);
        List<Case> novasManutencoes = new List<Case>();
        List<Equipment_Maintenance_Item__c> novosEqptMaintItem = new List<Equipment_Maintenance_Item__c>();
        for (Case c : casesAfterUpdate) {
            if ( c.Status == 'Closed' ) {
                if ( c.Type == 'Repair' || c.Type == 'Routine Maintenance' ) {
                    Case nm = new Case();
                    nm.Status           = 'New';
                    nm.Origin           = 'web';
                    nm.Type             = 'Routine Maintenance';
                    nm.Subject          = 'Depois do Update';
                    nm.Reason           = c.Reason;
                    nm.Vehicle__c       = c.Vehicle__c;
                    nm.Product__c       = c.Product__c;
                    nm.ProductId        = c.ProductId;
                    nm.ParentId         = c.Id;
                    nm.Date_Reported__c = Date.today();
                    nm.Date_Due__c = Date.today() + mapMinCycle.get(c.Id);
                    nm.Original_Case__c = c.Id;
                    novasManutencoes.add(nm);
                }
            }
        }
        insert novasManutencoes;
        
        List<Equipment_Maintenance_Item__c> listEmisOfOldCase = obterEmisOfOldCase(casesAfterUpdate);
        //System.debug('Total listEmisOfOldCase = ' + listEmisOfOldCase.size());

        for (Case newCase : novasManutencoes) {
            for (Equipment_Maintenance_Item__c emiList : listEmisOfOldCase) {
                Equipment_Maintenance_Item__c emi = new Equipment_Maintenance_Item__c();
                emi.Maintenance_Request__c = newCase.Id;
                if (emiList.Maintenance_Request__c == newCase.ParentId) {
                    emi.Equipment__c = emiList.Equipment__c;
                    emi.Momento_Gravacao__c = 'Apos Teste';
                    novosEqptMaintItem.add(emi);
                }
            }
        }
        insert novosEqptMaintItem;

        //for(Equipment_Maintenance_Item__c emi : novosEqptMaintItem) {
        //    System.debug('EqpMaintItem => Maintenace_Request = ' + emi.Maintenance_Request__c);
        //    System.debug('EqpMaintItem => Equipment = ' + emi.Equipment__c);
        //    System.debug('Momento Gravacao : ' + emi.Momento_Gravacao__c);
        //}
    }

    public static  Map<String, Integer> obterMinCycle ( List<Case> casesAfterUpdate ) {
        Map<String, Integer> mapMinCycle = new Map<String,Integer>();
        Map<Id, Case> mapKeyCase = new Map<Id, Case> (casesAfterUpdate);
  
        List<AggregateResult> listAgregMr = [  SELECT    Maintenance_Request__r.Id idMR,
                                                         MIN(Equipment__r.Maintenance_Cycle__c) cycle
                                                FROM     Equipment_Maintenance_Item__c 
                                                WHERE    Maintenance_Request__r.Id in :mapKeyCase.keySet() 
                                                GROUP BY Maintenance_Request__r.Id 
                                             ];
        for ( AggregateResult aMr : listAgregMr ) {
            if ( aMr.get('cycle') != null ) {
                mapMinCycle.put( (String)aMr.get('idMR'), Integer.valueOf(aMr.get('cycle')) );
            }
        }
        return mapMinCycle;
    }

    public static List<Equipment_Maintenance_Item__c>  obterEmisOfOldCase(List<Case> casesAfterUpdate) {
        Map<Id, Case> mapKeyCase = new Map<Id, Case>(casesAfterUpdate);

        List<Equipment_Maintenance_Item__c> listEmisOfOldCase = [ SELECT Maintenance_Request__c,
                                                                         Equipment__c
                                                                  FROM   Equipment_Maintenance_Item__c
                                                                  WHERE  Maintenance_Request__c IN :mapKeyCase.keySet() ];
        return listEmisOfOldCase;
    }
}