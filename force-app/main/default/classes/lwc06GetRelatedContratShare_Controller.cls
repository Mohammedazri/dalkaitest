/** 
* @author Jacques Akiki
* @date 09/09/2022 
* @Controller of lwc06
* @Test Class 
*/
public without sharing class lwc06GetRelatedContratShare_Controller {
/*
*method to get the total number of records to display in the component
*/
    @AuraEnabled(cacheable = true)
    public static Integer getTotalContratShare(String recordId){
        AggregateResult[] groupedResults = [select count(id) recordCount from Contrat__Share where parentId =:recordId and (RowCause='Manual' or RowCause='Owner')];
        if(groupedResults != null && groupedResults.size() > 0) {
            return Integer.valueOf(groupedResults[0].get('recordCount'));
        }
        return 0;
    }

    @AuraEnabled(cacheable = false)
    public static List<WrapperContratShare> getRelatedContratSharerefresh(String recordId, Integer pageSize, Integer page) {    
        Map<String, String> mapSortByField = new Map<String, String>();
        mapSortByField.put('User', 'UserOrGroup.Name');
        mapSortByField.put('Access', 'AccessLevel');
        
        String sortByField = '';
        String rowcauseM = 'Manual';
        String rowCauseO = 'Owner';
        String query = 'Select id, UserOrGroupId,UserOrGroup.Name,AccessLevel ' +
        'From Contrat__Share ' +
        'Where (RowCause=:rowcauseM or RowCause=:rowCauseO) and parentId =:recordId ';
        
        query += ' LIMIT ' + pageSize + ' OFFSET ' + ((page - 1) * pageSize);
        system.debug('-->'+query);
        String queryEscaped = String.escapeSingleQuotes(query);
        List<Contrat__share> relatedShare = Database.query( queryEscaped );
        set<id> setUserId = new set<id>();
        for (Contrat__Share cs:relatedShare){
            setUserId.add(cs.UserOrGroupId);
        }
        list<UserRecordAccess> listURA =[SELECT RecordId, HasEditAccess 
                                         FROM UserRecordAccess 
                                         WHERE UserId =:UserInfo.getUserId() AND RecordId =:recordId];

        map<id,User> mapIdUser = new map<id,User>([SELECT id,fullphotoURL FROM User where id in:setUserId]);
        List<WrapperContratShare> listwraperContrat = new list<WrapperContratShare>();
        for(Contrat__Share cs:relatedShare){
            WrapperContratShare wcs = new WrapperContratShare();
            String access ='';
            wcs.cancreate = listURA[0].HasEditAccess;
            wcs.notdeleteable = !(listURA[0].HasEditAccess);
            if(cs.AccessLevel=='All'){
                access = 'Pilote'; 
                wcs.notdeleteable = true;
            }
            else if(cs.AccessLevel=='Read'){
                access = 'Lecture';
            }
            else{
                access = 'Lecture/Écriture'; 
            }

            wcs.UserAccess = access;
            wcs.UserName = cs.UserOrGroup.Name;
            wcs.UserId ='/'+cs.UserOrGroupId;
            wcs.photoURL = mapIdUser.get(cs.UserOrGroupId).fullphotoURL;
            wcs.csId = cs.Id;
            listwraperContrat.add(wcs);
        }
        
        return listwraperContrat;
    }
    
    @AuraEnabled(cacheable = false)
    public static string deleteContratShare(String csId) {
        Contrat__Share cs = new Contrat__Share(id=csId);
        try{
            delete cs;
        }
        Catch(Exception e){
            return e.getMessage();
        }
        return 'OK';
    }
}