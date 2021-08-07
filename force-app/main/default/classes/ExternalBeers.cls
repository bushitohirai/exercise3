public with sharing class ExternalBeers {

    private static final String BEER_STORAGE = 'https://api.punkapi.com/v2/beers?per_page=30&page=';
    
    //@future(callout=true)    
    public static Integer getExternalBeersCall()
    {
        Integer returnResp = -1;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
		request.setEndpoint(BEER_STORAGE + getNextBeerPage());
        request.setMethod('GET');
        HttpResponse response = http.send(request);


        if(response.getStatusCode() == 200) {
            returnResp = getBeerSuccess(response.getBody());
        }else if(response.getStatusCode() == 400)
        { //bad request
            System.debug('Error 400: Bad Request.');
            returnResp = 400;
        }else if(response.getStatusCode() == 404)
        { //object not found
            System.debug('Error 404: Object not found.');
            returnResp = 404;
        }else if(response.getStatusCode() == 503) 
        { //service unavailable
            System.debug('Error 503: Service unavailable.');
            returnResp = 503;
        }else if(response.getStatusCode() == 596)
        { //service not found
            System.debug('Error 596: Service not found.');
            returnResp = 596;
        }

        
        return returnResp;
    }
    
    private static String getNextBeerPage()
    {
        String retornoString = '-1';
        if (Schema.sObjectType.Beer__c.fields.Id__c.isAccessible())
        {
            List<AggregateResult> result = [SELECT COUNT(Id__c) COUNTVAL FROM Beer__c];
            Integer maximo = Integer.valueOf(result[0].get('COUNTVAL'));
            Integer retorno = (maximo)/30 + 1;
            retornoString = String.valueOf(retorno);
        }
        return retornoString;
    }
    
    private static Integer getBeerSuccess(String pBody)
    {
        
        String beerId = '';
        String beerName = '';
        String beerTagline = '';
        String beerDescription = '';
        List<Beer__c> toInsertBeerList = new List<Beer__c>();
        
        Map<String, Id> mapLocalBeerList = new Map<String, Id>();
        List<Beer__c> localBeerList = new List<Beer__c>();
        
        if (Schema.sObjectType.Beer__c.fields.Id__c.isAccessible())
        {
            localBeerList = [SELECT Id, Id__c FROM Beer__c];
        }
        
        for(Beer__c agr : localBeerList)
        {
            mapLocalBeerList.put((String)agr.get('Id__c') , (Id)agr.get('Id'));
        }
        
        List<OriginalBeer> originalBeerList = (List<OriginalBeer>)JSON.deserialize(pBody, List<OriginalBeer>.class);
        
        for(OriginalBeer beerSource : originalBeerList)
        {
            beerId = '';
            beerName = '';
            beerTagline = '';
            beerDescription = '';
            
            beerId = String.valueOf(beerSource.id);
            beerName = String.valueOf(beerSource.name);
            beerTagline = String.valueOf(beerSource.tagline);
            beerDescription = (String.valueOf(beerSource.description)).abbreviate(100);
            if(String.isNotEmpty(beerId) && !mapLocalBeerList.containsKey(beerId) ) 
            {//the beer is new
                Beer__c newBeer = new Beer__c();
                newBeer.Id__c = beerId;
                newBeer.Name__c = beerName;
                newBeer.Description__c = beerDescription;
                toInsertBeerList.add(newBeer);
            }
            
        }
        if(toInsertBeerList.size() > 0)
        {
            if (Schema.sObjectType.Beer__c.fields.Id__c.isCreateable())
            {
                insert toInsertBeerList;                    
            }
            
            System.debug('The new beers were synced from punkapi.com. Total: ' + String.valueOf(toInsertBeerList.size()));
        }
        
        return 200;
        
    }
    
}