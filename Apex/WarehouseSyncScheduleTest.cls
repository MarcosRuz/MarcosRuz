@isTest
public with sharing class WarehouseSyncScheduleTest {
    // implement scheduled code here
    @isTest
    static void testWarehouseSyncSchedule() {
        String className = 'WarehouseCalloutService';
        Integer totAsyncJob;

        totAsyncJob = [ SELECT COUNT() 
                        FROM   AsyncApexJob 
                        WHERE  ApexClass.Name = :className
                        AND    Status = 'Queued' ];

        System.assertEquals(totAsyncJob, 0);
        System.debug('Ocorrencias Classe WarehouseCalloutService em AyncApexJob Antes do Test = ' + totAsyncJob);

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock(200)); 
            String cronJobId = System.schedule( WarehouseSyncSchedule.JOB_NAME,
                                                WarehouseSyncSchedule.TIME_SCHEDULE,
                                                new WarehouseSyncSchedule() );
        Test.stopTest();

        totAsyncJob = [ SELECT COUNT() 
                        FROM   AsyncApexJob 
                        WHERE  ApexClass.Name = :className
                        AND    Status = 'Queued' ];

        System.assertEquals(totAsyncJob, 1);

        /* ***
        CronTrigger cron = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE Id = :cronJobId];
        System.debug('Ocorrencias Classe WarehouseCalloutService em AyncApexJob Após do Test');
        for ( AsyncApexJob aaj : listAaj ) {
            System.debug('AsyncApexJob Id            = ' + aaj.Id );
            System.debug('AsyncApexJob Class Name    = ' + aaj.ApexClass.Name );
        }
        System.debug('    ');
        System.debug('CronTrigger Id         = ' + cron.Id);
        System.debug('CronTrigger Job Name   = ' + cron.CronJobDetail.Name); 
        * ***/     
    }
}