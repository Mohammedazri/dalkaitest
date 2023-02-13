/** 
* @author Charbel Khoury Hanna
* @date 10/17/2022
* @description verifier si on peut supprimer la demande (case)
* @Test Class AP117_Case_Test (100%)
*/
public class AP117_Case {

    public static void checkIfCanDeleteCase (List<Case> listCases)
    {
        Id c360RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Demande C360').getRecordTypeId();

        if(listCases.size() > 0 && UserInfo.getProfileId().contains(Label.Flux_AC_Id))
        {
            for(Case cs : listCases)
            {
                if(cs.RecordTypeId != c360RecordTypeId)
                {
                    cs.addError(Label.AP117_ErrorMsg);
                }
            }
        }
    }
}