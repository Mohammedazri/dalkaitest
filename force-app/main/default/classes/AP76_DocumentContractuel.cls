/** 
* @author Jacques AKiki
* @date 17/02/2020 
* @description class prevents document contractuel from being deleted in certain cases
* @Test Class AP76_DocumentContractuel_test
*/
public class AP76_DocumentContractuel {
/** 
* @author Jacques Akiki
* @date 07/02/2020 
* @checks if the field NumeroPiece__c is empty. If not the document cannot be deleted
* @param listDocCont: list of document_contractuel__c being deleted
* @return void
*/
    public static void preventDelete (list<Document_Contractuel__c> listDocCont)
    {
        for (Document_Contractuel__c dc:listDocCont)
        {
            if (dc.NumeroPiece__c<>null)
            {
                dc.addError(Label.AP76_PreventDelete);// add error to dtop delete operation
            }
        }
    }
}