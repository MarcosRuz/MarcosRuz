public class WarehouseCalloutServiceMock implements HttpCalloutMock {
    // implement http mock callout
    Integer statusCode;
    public static String bodyMockCallout;

    public WarehouseCalloutServiceMock(Integer statusCode) {
        this.statusCode = statusCode;
    }

    public HttpResponse respond (HttpRequest request) {
        HttpResponse response = new HttpResponse();
        bodyMockCallout = 
        '['                                             +
            '{'                                         +
                '"_id":"55d66226726b611100aaf741",'     +
                '"replacement":false,'                  +
                '"quantity":5,'                         +
                '"name":"Generator 1000 kW",'           +
                '"family":"Warehouse",'                 +
                '"maintenanceperiod":365,'              +
                '"lifespan":120,'                       +
                '"cost":5000,'                          +
                '"sku":"100003"'                        +
            '},'                                        +
            '{'                                         +
                '"_id":"55d66226726b611100aaf742",'     +
                '"replacement":true,'                   +
                '"quantity":183,'                       +
                '"name":"Cooling Fan",'                 +
                '"family":"Warehouse",'                 +
                '"maintenanceperiod":0,'                +
                '"lifespan":0,'                         +
                '"cost":300,'                           +
                '"sku":"100004"'                        +
            '},'                                        +
            '{'                                         +
                '"_id":"55d66226726b611100aaf743",'     +
                '"replacement":true,'                   +
                '"quantity":143,'                       +
                '"name":"Fuse 20A",'                    +
                '"family":"Warehouse",'                 +
                '"maintenanceperiod":0,'                +
                '"lifespan":0,'                         +
                '"cost":22,'                            +
                '"sku":"100005"'                        +
            '},'                                        +
            '{'                                         +
                '"_id":"55d66226726b611100aaf744",'     +
                '"replacement":false,'                  +
                '"quantity":5,'                         +
                '"name":"Generator 2000 kw",'           +
                '"family":"Warehouse",'                 +
                '"maintenanceperiod":365,'              +
                '"lifespan":120,'                       +
                '"cost":6000,'                          +
                '"sku":"100006"'                        +
            '},'                                        +
            '{'                                         +
                '"_id":"55d66226726b611100aaf745",'     +
                '"replacement":true,'                   +
                '"quantity":142,'                       +
                '"name":"Fuse 25A",'                    +
                '"family":"Warehouse",'                 +
                '"maintenanceperiod":0,'                +
                '"lifespan":0,'                         +
                '"cost":28,'                            +
                '"sku":"100007"'                        +
            '}'                                         +
        ']';
        // Configurando e Retornando Response
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(statusCode);
        response.setBody(bodyMockCallout);
        return response;
    }
}