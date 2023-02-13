public with sharing class AP115_Consigne_MultiMocks implements HttpCalloutMock{
    Map<String, HttpCalloutMock> requests;

    public AP115_Consigne_MultiMocks(Map<String, HttpCalloutMock> requests) {
        this.requests = requests;
    }

    public HTTPResponse respond(HTTPRequest req) {
        HttpCalloutMock mock = requests.get(req.getEndpoint());
        if (mock != null) {
            return mock.respond(req);
        } else {
            CalloutException e = (CalloutException)CalloutException.class.newInstance();
            e.setMessage('There is a MultiMocks exception.');
            throw e;
            //throw new MyCustomException('HTTP callout not supported for test methods');
        }
    }

    public void addRequestMock(String url, HttpCalloutMock mock) {
        requests.put(url, mock);
    }
}