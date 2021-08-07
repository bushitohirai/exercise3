@isTest
private class ExternalBeersTest {
    
    @testSetup
    static void setup() {
        //Create a Beer
		Beer__c aBeer = new Beer__c();
		aBeer.Id__c = '1';
		aBeer.Name__c = 'Name Mock01';
		aBeer.Tagline__c = 'Tag Mock01';
		aBeer.Description__c = 'Description Mock01';        
        Test.startTest();
        insert aBeer;
    }
    
    @isTest static  void testgetExternalBeersCall() {
		//OK
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetBeerResource');
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        mock.setStatusCode(200);  
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        Integer result = ExternalBeers.getExternalBeersCall();
        Test.stopTest();
        System.assertNotEquals(null,result, 'The callout returned a null response.');
        System.assertEquals(200,result, 'The status code is not 200.');

    }   
    
    @isTest static  void testgetExternalBeersCallFailure400() {
		//bad request
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetBeerResource');
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        mock.setStatusCode(400);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        Integer result = ExternalBeers.getExternalBeersCall();
        Test.stopTest();
        System.assertNotEquals(null,result, 'The callout returned a null response.');
        System.assertEquals(200,result, 'The status code is not 200.');

    }  

    @isTest static  void testgetExternalBeersCallFailure404() {
		//object not found
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetBeerResource');
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        mock.setStatusCode(404);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        Integer result = ExternalBeers.getExternalBeersCall();
        Test.stopTest();
        System.assertNotEquals(null,result, 'The callout returned a null response.');
        System.assertEquals(200,result, 'The status code is not 200.');

    }  

    @isTest static  void testgetExternalBeersCallFailure503() {
		//service unavailable
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetBeerResource');
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        mock.setStatusCode(503);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        Integer result = ExternalBeers.getExternalBeersCall();
        Test.stopTest();
        System.assertNotEquals(null,result, 'The callout returned a null response.');
        System.assertEquals(200,result, 'The status code is not 200.');

    }  

    @isTest static  void testgetExternalBeersCallFailure596() {
		//service not found
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetBeerResource');
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        mock.setStatusCode(596);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        Integer result = ExternalBeers.getExternalBeersCall();
        Test.stopTest();
        System.assertNotEquals(null,result, 'The callout returned a null response.');
        System.assertEquals(200,result, 'The status code is not 200.');

    }  
    
}