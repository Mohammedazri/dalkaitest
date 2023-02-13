global class Header {
    webservice String transactionId;
    webservice String flowCode;
    webservice ReplyInfos replyInfos;
    webservice String serviceName;
    webservice String serviceVersion;
    webservice String event;
    global class ReplyInfos{
        webservice String applicationId;
        webservice DateTime timestamp;
    }
}