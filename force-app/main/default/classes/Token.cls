public class Token {
    
    public String access_token;
    public Integer expires_in;
    public String token_type;
    
    
    public static Token parse(String json) {
        return (Token) System.JSON.deserialize(json, Token.class);
    }
}