public class AP02_ContentDocumentLink 
{
    public static void LinkEvent(list<ContentDocumentLink> listContentDocumentLink)
    {
        set<id> setId = new set<id>();
        set<id> setEvntId = new set <id>();
        for (ContentDocumentLink cdl : listContentDocumentLink)
        {
            setId.add(cdl.id);
        }
        List<ContentDocumentLink> listCon = [SELECT id,ContentDocumentId ,LinkedEntity.Type,LinkedEntityId 
                                             FROM ContentDocumentLink 
                                             WHERE id in:setId];
        for (ContentDocumentLink cdl:listCon)
        {
            if (cdl.LinkedEntityId.getSObjectType().getDescribe().getName() =='Event')
            {
                setEvntId.add(cdl.LinkedEntityId);
            }
        }
        if (setEvntId!=null && setEvntId.size()>0)
        {
            List <Event> ListEvntUpdte = new List <Event>();
            List <Event> listEv = [SELECT id, Rdvralise__c 
                                   FROM Event 
                                   WHERE id in:setEvntId];
            if (listEv!=null && listEv.size()>0)
            {
                for (Event ev : listEv)
                {
                    ev.Rdvralise__c = true;
                    ListEvntUpdte.add(ev);
                }
                try
                {
                    Update ListEvntUpdte;
                }
                Catch (exception e)
                {
                    system.debug('Erreor occured while updating events: ' + e);
                }
            }
        }
    }
}