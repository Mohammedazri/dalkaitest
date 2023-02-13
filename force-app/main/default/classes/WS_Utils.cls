/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: this class creates and sends an http GET request and handle the response and the log.
It's used by the classes WS04_Explore_Mouvements, WS03_Explore_Promotion and WS02_Explore_MarchePublic
Test Class: AP03_CallExplore_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
public class WS_Utils {
    
    private static final Map<String, String> REST_HEADER = new Map<String, String>{'Content-Type' => 'text/csv'};
        
        //  enum class used in the following function
        public enum CallType{
            Explore_Mouvements,
                Explore_MarchePublic,
                Explore_Promotion
                }
    
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: this function does an HTTP callout using the function executeHttpRequest and returns the response and log as an instance of WS_Utils_Wrapper
Inputs: CallType theCallType, string APIURL, string envelope
Returns: WS_Utils_Wrapper
----------------------------------------------------------------------------------------------------------------------------*/ 
    public static WS_Utils_Wrapper callExplore(CallType theCallType, string APIURL, string envelope){
        string strType = null;
        if(theCallType == CallType.Explore_Mouvements){
            strType ='Explore_Mouvements';
        }
        else if(theCallType == CallType.Explore_MarchePublic){
            strType ='Explore_MarchePublic';
        } 
        else if(theCallType == CallType.Explore_Promotion){
            strType ='Explore_Promotion';
        }
        
        WebserviceLog__c log = new WebserviceLog__c(Endpoint__c = APIURL, 
                                                    Request__c = envelope, 
                                                    Type__c = strType);
        
        WS_Utils_Wrapper WrapperRes= new WS_Utils_Wrapper();
        
        try{    
            HttpResponse res = executeHttpRequest(APIURL,'GET',envelope,120000, null, null, null, REST_HEADER);
            
            log.StatusCode__c = string.valueof(res.getStatusCode());
            if(res.getBody().length() > 30000)
                log.response__c = res.getBody().substring(0, 30000);
            else
                log.response__c = res.getBody();
            WrapperRes.Log=log;
            WrapperRes.HttpRes=res;
            //insert log;    
            return WrapperRes;
        }
        catch(Exception ex){
            log.response__c = ex.getMessage();
            log.response__c += '\r\n Line : ' + ex.getLineNumber();
            log.response__c += '\r\n Stack : ' + ex.getStackTraceString();
            WrapperRes.Log=log;
            //insert log;    
        }
        
        
        return WrapperRes;
    }
    
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description:  this function uses the input arguments and send an http request to the specified Endpoint and return the response
Inputs: String endPoint, String requestType, string envelope, Integer timeout, String userName, String password, String certificate, Map<String, String> header
Returns: HttpResponse
----------------------------------------------------------------------------------------------------------------------------*/ 
    public static HttpResponse executeHttpRequest(String endPoint, String requestType, string envelope, Integer timeout, String userName, String password, String certificate, Map<String, String> header){        
        HttpResponse res = null;
        HttpRequest req = new HttpRequest();
        
        if (String.isNotEmpty(certificate)) {
            req.setClientCertificateName(certificate);
        }
        
        req.setEndPoint(endPoint);
        req.setMethod(requestType);
        req.setTimeout(timeout);
        
        if (header != null) {
            for (String key : header.keySet()) {
                req.setHeader(key, header.get(key));
            }
        }
        
        if (requestType != 'GET') {            
            req.setBody(envelope);
        }
        
        res = new Http().send(req);         
        
        return res;
    }
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: class used in the functions above and the instances of this class contain the Log and the response of the webservice
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
    
    public class WS_Utils_Wrapper{
        
        public WebserviceLog__c Log;
        public HttpResponse HttpRes;
        // constructor with arguments
        public WS_Utils_Wrapper(WebserviceLog__c Log, HttpResponse HttpRes){
            this.Log = Log;
            this.HttpRes = HttpRes;
        }
        // constructor without arguments
        public WS_Utils_Wrapper(){
            this.Log = null;
            this.HttpRes = null;
        }
    }
    
    
}