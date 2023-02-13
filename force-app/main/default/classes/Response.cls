global class Response {
    webservice String responseCode{get; set;}
    webservice String errorText{get; set;}
    webservice Boolean error{get; set;}
    global Response(){
    }
    global Response(String code,String text){
        this.responseCode = code;
        this.errorText = text;
    }
    global Response(String code,String text,Boolean error){
        this.responseCode = code;
        this.errorText = text;
        this.error = error;
    }
}