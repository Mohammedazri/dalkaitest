public class AP118_ConnecteurDACRC_Mock_TEST implements HttpCalloutMock{

    protected Integer code;
    protected String status;
    protected String bodyAsString;
    protected Map<String, String> responseHeaders;
    protected String strException;

    public AP118_ConnecteurDACRC_Mock_TEST(Integer code, String status, String body,
    Map<String, String> responseHeaders, String exceptionMessage) {

        this.code = code;
        this.status = status;
        this.bodyAsString = body;
        this.responseHeaders = responseHeaders;
        this.strException = exceptionMessage;
    }

    public HTTPResponse respond(HTTPRequest req) {
    
        HttpResponse resp = new HttpResponse();
        resp.setStatusCode(code);
        resp.setStatus(status);
        //request.setMethod('POST');
        System.assertEquals('POST', req.getMethod());
        if (this.strException != null)
        {
            CalloutException e = (CalloutException)CalloutException.class.newInstance();
            e.setMessage(strException);
            throw e;
        }
        else
        {
            HttpResponse res = new HttpResponse();
            resp.setHeader('Content-Type', 'application/json');
            resp.setStatus(this.status);
            resp.setStatusCode(this.code);
            resp.setBody(this.bodyAsString);
        }
        if (responseHeaders != null) {
            for (String key : responseHeaders.keySet()) {
                resp.setHeader(key, responseHeaders.get(key));
            }
        }
        return resp;
    }
}