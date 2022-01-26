@isTest
public with sharing class MaintenanceRequestHelperTest {
    // implement scheduled code here
    static final Integer OCCURS_NEG01 = 5;
    static final Integer OCCURS_NEG02 = 5;
    static final Integer OCCURS_NEG03 = 5;
    static final Integer OCCURS_POS01 = 50;
    static final Integer OCCURS_POS02 = 50;

    static String IdProdBase;
    static Vehicle__c veiculo      = new Vehicle__c();
    static List<Case> casos        = new List<Case>();
    static List<Product2> produtos = new List<Product2>();
    static List<Equipment_Maintenance_Item__c> emis = new List <Equipment_Maintenance_Item__c>();
    
    //@testSetup
    public static void gerarDadosTeste () {
        // Gerando um Registro em Vehicle__c
        veiculo.Name = 'Antes do Update';
        insert veiculo;

        for (Integer i = 0; i < 3; i++) {
            Product2 produto = new Product2();
            produto.Maintenance_Cycle__c = 10 + i;
            produto.Replacement_Part__c  = true;
            produto.Name = 'Produto Para Teste ' + i;
            produtos.add(produto);
        }
        insert produtos;

         IdProdBase = [ SELECT Id FROM PRODUCT2 ][0].Id;

        // Gerando Casos Teste Negativo 01 - Reason Mechanical
        for (Integer i = 0; i < OCCURS_NEG01; i++) {
            Case caso =  new Case();
            caso.Vehicle__c = veiculo.Id;
            caso.Status     = 'New';
            caso.Type       = 'Mechanical';
            caso.Subject    = 'Antes do Update';
            caso.Reason     = 'Installation';
            caso.ProductId   = IdProdBase;
            casos.add(caso);
        }
        // Gerando Casos Teste Negativo 02 - Reason Performance
        for (Integer i = 0; i < OCCURS_NEG02; i++) {
            Case caso =  new Case();
            caso.Vehicle__c = veiculo.Id;
            caso.Status     = 'New';
            caso.Type       = 'Mechanical';
            caso.Subject    = 'Antes do Update';
            caso.Reason     = 'Performance';
            caso.ProductId  = IdProdBase;
            casos.add(caso);
        }
        // Gerando Casos Teste Negativo 03 - Reason Breakdown
        for (Integer i = 0; i < OCCURS_NEG03; i++) {
            Case caso =  new Case();
            caso.Vehicle__c = veiculo.Id;
            caso.Status     = 'New';
            caso.Type       = 'Mechanical';
            caso.Subject    = 'Antes do Update';
            caso.Reason     = 'Breakdown';
            caso.ProductId  = IdProdBase;
            casos.add(caso);
        }
        // Gerando Casos Teste Positivo 01 - Reason Feedback
        for (Integer i = 0; i < OCCURS_POS01; i++) {
            Case caso =  new Case();
            caso.Vehicle__c = veiculo.Id;
            caso.Status     = 'New';
            caso.Type       = 'Mechanical';
            caso.Subject    = 'Antes do Update';
            caso.Reason     = 'Feedback';
            caso.ProductId  = IdProdBase;
            casos.add(caso);
        }
        // Gerando Casos Teste Positivo 02 - Reason Other
        for (Integer i = 0; i < OCCURS_POS02; i++) {
            Case caso =  new Case();
            caso.Vehicle__c = veiculo.Id;
            caso.Status     = 'New';
            caso.Type       = 'Mechanical';
            caso.Subject    = 'Antes do Update';
            caso.Reason     = 'Other';
            caso.ProductId  = IdProdBase;
            casos.add(caso);
        }
        insert casos;

        // Gerando Registros em Equipment_Maintenance_Item__c
        for (Case caso : casos) {
            for( Product2 produto : produtos) {
                Equipment_Maintenance_Item__c emi = new Equipment_Maintenance_Item__c();
                emi.Equipment__c = produto.Id;
                emi.Maintenance_Request__c = caso.Id;
                emi.Momento_Gravacao__c = 'Antes Teste';
                emis.add(emi);
            }
        }
        insert emis;
    }
    
    // Caso Teste Negativo 01
    @isTest
    static void testNegativo01() {
        gerarDadosTeste();        
        List<Case> casosUpdate = new List<Case>();
        for(Case caso : casos) {
            if (caso.Reason == 'Installation') {
                casosUpdate.add(caso);
            }
        }
        Test.startTest();
            for (Case cupdt : casosUpdate) {
                    cupdt.Type = 'Repair';
            }
            update casosUpdate;
        Test.stopTest();
        Integer totCasosNovosTrigger = [ SELECT COUNT() 
                                         FROM   Case 
                                         WHERE  Reason  = 'Installation'
                                         AND    Subject = 'Depois do Update' ];
        System.AssertEquals(0, totCasosNovosTrigger);
    }

    // Caso Teste Negativo 02
    @isTest
    static void testNegativo02() {
        gerarDadosTeste();        
        List<Case> casosUpdate = new List<Case>();
        for(Case caso : casos) {
            if (caso.Reason == 'Performance') {
                casosUpdate.add(caso);
            }
        }
        Test.startTest();
            for (Case cupdt : casosUpdate) {
                    cupdt.Type = 'Routine Maintenance';
            }
            update casosUpdate;
        Test.stopTest();
        Integer totCasosNovosTrigger = [ SELECT COUNT() 
                                         FROM   Case 
                                         WHERE  Reason  = 'Performance'
                                         AND    Subject = 'Depois do Update' ];
        System.AssertEquals(0, totCasosNovosTrigger);
    }
    
    // Caso Teste Negativo 03
    @isTest
    static void testNegativo03() {
        gerarDadosTeste();        
        List<Case> casosUpdate = new List<Case>();
        for(Case caso : casos) {
            if (caso.Reason == 'Breakdown') {
                casosUpdate.add(caso);
            }
        }
        Test.startTest();
            for (Case cupdt : casosUpdate) {
                    cupdt.Status = 'Closed';
            }
            update casosUpdate;
        Test.stopTest();
        Integer totCasosNovosTrigger = [ SELECT COUNT() 
                                         FROM   Case 
                                         WHERE  Reason  = 'Breakdown'
                                         AND    Subject = 'Depois do Update' ];
        System.AssertEquals(0, totCasosNovosTrigger);
    }
    
    // Caso Teste Positivo 01
    @isTest
    static void testPositivo01() {
        gerarDadosTeste();
        List<Case> casosUpdate = new List<Case>();
        for (Case caso : casos) {
            if (caso.Reason == 'Feedback') {
                // Caso Para Update
                casosUpdate.add(caso);
            }
        }

        Integer totEmiAntes = [ SELECT COUNT()
                                FROM   Equipment_Maintenance_Item__c
                                WHERE  Momento_Gravacao__c = 'Antes Teste' ];

        //System.debug('Total Ocorrencias Antes = ' + totEmiAntes);

        Test.startTest();
            for(Case cupdt : casosUpdate) {
                cupdt.Status = 'Closed';
                cupdt.Type = 'Repair';
            }
            update casosUpdate;
        Test.stopTest();
        Integer totCasosNovosTrigger = [ SELECT COUNT() 
                                         FROM   Case 
                                         WHERE  Subject = 'Depois do Update'
                                         AND    Reason  = 'Feedback' ];
        System.assertEquals(OCCURS_POS01, totCasosNovosTrigger);

        Integer totEmiApos = [ SELECT COUNT() 
                               FROM   Equipment_Maintenance_Item__c
                               WHERE  Momento_Gravacao__c = 'Apos Teste' ];

        //System.debug('Total Ocorrencias Apos = ' + totEmiApos);

        System.assertEquals( 3 * OCCURS_POS01, totEmiApos );
    }

    // Caso Teste Positivo 02
    @isTest
    static void testPositivo02() {
        gerarDadosTeste();        
        List<Case> casosUpdate = new List<Case>();
            for (Case caso : casos) {
                if (caso.Reason == 'Other') {
                    casosUpdate.add(caso);
                }
            }
        Test.startTest();
            for(Case cupdt : casosUpdate) {
                cupdt.Status = 'Closed';
                cupdt.Type = 'Routine Maintenance';
            }
            update casosUpdate;
        Test.stopTest();
        Integer totCasosNovosTrigger = [ SELECT COUNT() 
                                         FROM   Case 
                                         WHERE  Subject = 'Depois do Update'
                                         AND    Reason  = 'Other' ];
        System.assertEquals(OCCURS_POS02, totCasosNovosTrigger);

        Integer totNewEqpMaintItem = [ SELECT COUNT() 
                                       FROM   Equipment_Maintenance_Item__c
                                       WHERE  Momento_Gravacao__c = 'Apos Teste' ];
        System.assertEquals( 3 * OCCURS_POS02, totNewEqpMaintItem );
    }

    // Caso Teste Case Due Date
    @isTest
    static void testDueDate() {
        gerarDadosTeste();        
        List<Case> casosUpdate = new List<Case>();
            for (Case caso : casos) {
                if (caso.Reason == 'Other') {
                    casosUpdate.add(caso);
                }
            }
        Test.startTest();
            for(Case cupdt : casosUpdate) {
                cupdt.Status = 'Closed';
                cupdt.Type = 'Routine Maintenance';
            }
            update casosUpdate;
        Test.stopTest();
        List<Case> listIds = [ SELECT Id
                               FROM   Case 
                               WHERE  Subject = 'Depois do Update'
                               AND    Reason  = 'Other' ];

        Map<Id, Case> mapIds = new Map<Id, Case>(listIds);
  
        Integer totDueDates = [ SELECT COUNT()
                                FROM   Equipment_Maintenance_Item__c
                                WHERE  Maintenance_Request__c IN :mapIds.keySet()
                                AND    Maintenance_Request__r.Date_Due__c <>  
                                       NEXT_N_DAYS:10 ];
        System.assertEquals(totDueDates, 0);
    } 
}