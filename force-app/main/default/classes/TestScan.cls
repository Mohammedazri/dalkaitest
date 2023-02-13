public class TestScan {
    
    public static void testCallout() {
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://10.180.7.67:8081/test');
        request.setMethod('GET');
        
        
        system.debug('*** request ='+request);
        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
        
    }
    
}