/*--------------------------------------------------------------------------------------------------------------------------
   Author: Dona Kfoury
   Company: EI-Technologies
   Description: When the relationship between 2 objects is a lookup relationship. We use this Class
             to do a roll up summary on the chosen fields of the child object and update the rollup fields of the parent record
   Test Class: AP14_OppRollUpSummaryUtility_TEST
   --------------------------------------------------------------------------------------------------------------------------*/
public class AP14_OppRollUpSummaryUtility {
/*--------------------------------------------------------------------------------------------------------------------------
   Author: Dona Kfoury
   Company: EI-Technologies
   Description: the following class will be used to house the field names and desired operations
   Test Class: AP14_OppRollUpSummaryUtility_TEST
   --------------------------------------------------------------------------------------------------------------------------*/
    public class fieldDefinition {
        public String operation {get; set;}
        public String childField {get; set;}
        public String parentField {get; set;}
        public fieldDefinition (String o, String c, String p) {
            operation = o;
            childField = c;
            parentField = p;
        }
    }
/*--------------------------------------------------------------------------------------------------------------------------
   Author: Dona Kfoury
   Company: EI-Technologies
   Description: This function takes the list of field and the list of child records and updates the rollup fields of the parent records
   Inputs: List of "Fiche_de_synthese__c" and a boolean
   Returns: -
   ----------------------------------------------------------------------------------------------------------------------------*/
    public static void rollUpTrigger(list<fieldDefinition> fieldDefinitions, list<sObject> records, String childObject, String childParentLookupField, String parentObject, String queryFilter){
        //Limit the size of list by using Sets which do not contain duplicate
        //elements prevents hitting governor limits
        set<Id> parentIds = new set<Id>();

        for(sObject s : records) {
            parentIds.add((Id)s.get(childParentLookupField));
        }
        //populate query text strings to be used in child aggregrator and
        //parent value assignment
        String fieldsToAggregate = '';
        String parentFields = '';
        List<String> fields = new List<String>();
        for(fieldDefinition d : fieldDefinitions) {
            fieldsToAggregate = d.operation + '(' + d.childField + ') ' +  ', ';
            fields.add(fieldsToAggregate);
            parentFields += d.parentField + ', ';
        }
        //Using dynamic SOQL with aggergate results to populate parentValueMap
        list<string> StatusOpened = label.OpportunityOpenedStatus.split(';');
        //Added By Jimmy for ApexSOQLInjection
        String firstField = fields[0];
        String aggregateQueryOpenOpp = 'Select ' + firstField +
        childParentLookupField + ' from ' + childObject + ' where ' +
        childParentLookupField + ' IN :parentIds and Statut__c in :StatusOpened group by ' + childParentLookupField;
        //Map will contain one parent record Id per one aggregate object
        map<Id, AggregateResult> parentValueMapOpenOpp = new map<Id, AggregateResult>();
        map<Id, AggregateResult> parentValueMapClosedOpp = new map<Id, AggregateResult>();

        String aggregateQueryOpenOppEscaped = String.escapeSingleQuotes(aggregateQueryOpenOpp);
        for(AggregateResult q : Database.query(aggregateQueryOpenOppEscaped )) {
            parentValueMapOpenOpp.put((Id)q.get(childParentLookupField), q);
        }
        list<string> StatusClosed = label.OpportunityClosedStatus.split(';');
        //Added By Jimmy for ApexSOQLInjection
        String secondField = fields[1];
        String aggregateQueryClosedOpp = 'Select ' + secondField +
        childParentLookupField + ' from ' + childObject + ' where ' +
        childParentLookupField + ' IN :parentIds and Statut__c in :StatusClosed and Statut__c !=null group by ' + childParentLookupField;
        //(Statut__c=\'Gagné\' or Statut__c=\'Perdu\')

        String aggregateQueryClosedOppEscaped = String.escapeSingleQuotes(aggregateQueryClosedOpp);
        for(AggregateResult q : Database.query(aggregateQueryClosedOppEscaped)) {
            parentValueMapClosedOpp.put((Id)q.get(childParentLookupField), q);
        }
        //list of parent object records to update
        list<sObject> parentsToUpdate = new list<sObject>();
        String parentQuery = 'select ' + parentFields + ' Id ' + ' from ' + parentObject + ' where Id IN :parentIds';
        //for each affected parent object, retrieve aggregate results and
        //for each field definition add aggregate value to parent field

        //Added By Jimmy for ApexSOQLInjection
        String parentQueryEscaped = String.escapeSingleQuotes(parentQuery);
        for(sObject s : Database.query(parentQueryEscaped)) {
            Integer row = 0; //row counter reset for every parent record
            for(fieldDefinition d : fieldDefinitions) {
                //String field = 'expr' + row.format();
                //Row 0 will be for the first aggregate result (open opps)
                //Row 1 will be for the second aggregate result (closed opps)
                AggregateResult r = (row == 0?parentValueMapOpenOpp.get(s.Id) : parentValueMapClosedOpp.get(s.Id));
                //r will be null if no records exist
                //(e.g. last record deleted)
                if(r != null) {
                    Decimal value = ((Decimal)r.get('expr0') == null) ? 0 : (Decimal)r.get('expr0');
                    s.put(d.parentField, value);

                } else {
                    s.put(d.parentField, 0);
                }
                row += 1; //plus 1 for every field definition after first
            }
            parentsToUpdate.add(s);
        }
        //if parent records exist, perform update of all parent records
        //with a single DML statement
        if(parentsToUpdate.Size() > 0) {
            update parentsToUpdate;
        }
    }
}