@IsTest
private class WarehouseCalloutServiceTest {
    @IsTest
    static void testStatusCode200() {
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock(200));
            WarehouseCalloutService.invocaRequisicao();
        Test.stopTest();
        Integer totProdutos = [ SELECT COUNT() FROM Product2 ];
        System.assert(totProdutos > 0);
    }
    @IsTest
    static void testStatusCode204() {
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock(204));
            WarehouseCalloutService.invocaRequisicao();
        Test.stopTest();
        Integer totProdutos = [ SELECT COUNT() FROM Product2 ];
        System.assertEquals(totProdutos, 0);
    }
}