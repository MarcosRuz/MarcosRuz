global with sharing class WarehouseSyncSchedule implements Schedulable {
    // implement scheduled code here
    public static final String JOB_NAME = 'WarehouseSyncScheduleJob';
    public static final String TIME_SCHEDULE = '00 00 01 * * ?';

    global void execute (SchedulableContext ctx) {
        System.enqueueJob(new WarehouseCalloutService() );    
    }
}