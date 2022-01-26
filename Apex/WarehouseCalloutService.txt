public with sharing class WarehouseCalloutService implements Queueable {
    public static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    public static final String REQ_METHOD = 'GET';

    public void execute(QueueableContext ctx) {
        invocaRequisicao();
    }

    @future(callout=true)
    public static void invocaRequisicao() {
        HttpResponse response = configRequisicao();
        if (response.getStatusCode() == 200) {
            tratarResponse(response);
        }
    }

    // Configurando a Requisição
    public static HttpResponse configRequisicao() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod(REQ_METHOD);
        response = http.send(request);
        return response;
    }
    
    public static void tratarResponse(HttpResponse response) {
        List<Object> objectsResponse = (List<Object>)JSON.deserializeUntyped(response.getBody());
        List<Product2> produtos = new List<Product2>();
        for (Object objResp : objectsResponse) {
            Map<String, Object> mapObjResp = (Map<String, Object>)objResp;
            Product2 produto = new Product2();
            produto.ProductCode          = (String)mapObjResp.get('_id');
            produto.Replacement_Part__c  = (Boolean)mapObjResp.get('replacement');
            produto.Current_Inventory__c = (Integer)mapObjResp.get('quantity');
            produto.Name                 = (String)mapObjResp.get('name');
            produto.Maintenance_Cycle__c = (Integer)mapObjResp.get('maintenanceperiod');
            produto.Lifespan_Months__c   = (Integer)mapObjResp.get('lifespan');
            produto.Cost__c              = (Decimal)mapObjResp.get('cost');
            produto.Warehouse_SKU__c     = (String)mapObjResp.get('sku');
            produtos.add(produto);
        }
        upsert produtos Warehouse_SKU__c;
        //System.debug('Total Prods Inseridos Classe Execução = ' + produtos.size());
    }
}