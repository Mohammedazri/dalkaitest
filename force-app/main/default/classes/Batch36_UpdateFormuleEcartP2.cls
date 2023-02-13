/**
* @author: Jacques Akiki -EI Technologies
* @date: 05/03/2019
* @description: Formula EcartP2MargeBrute__c with more than 5000 caracters, TechFormuleEcart__c replaced condition and is filled using ths batch . 
* @Test Class: Batch36_UpdateFormuleEcartP2_test 
* @Coverage: 86%
*/
global class Batch36_UpdateFormuleEcartP2 implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        
        String query ='SELECT SaisieRefP1Investissements__c,SaisieRefP1VentesServices__c,SaisieRefP1AchatsEnergieGaz__c,SaisieRefP1AchatsEnergieFuel__c,'+
            'SaisieRefP1AchatsEnergieCharbon__c,SaisieRefP1AchatsEnergieBiomasse__c,SaisieRefP1AchatsEnergieElectricite__c,SaisieRefP1AchatsAutresEnergies__c,'+
            'SaisieRefP1Amortissements__c,SaisieRefP1AutresChargesEtProduits__c,SaisieRefP2Investissements__c,SaisieRefP2VentesServices__c,'+
            'SaisieRefP2Fournituresetpetitsmat__c,SaisieRefP2Electricite__c,SaisieRefP2EauProduitsTrait__c,SaisieRefP2STControlesReglem__c,'+
            'SaisieRefP2STEntretienCompteurs__c,SaisieRefP2STGECogeneration__c,SaisieRefP2STTraitementEau__c,SaisieRefP2STMultiservices__c,'+
            'SaisieRefP2STAutresPrestations__c,SaisieRefP2SousTraitanceInterne__c,SaisieRefP2LocationsEntretien__c,SaisieRefP2Telesurveillance__c,'+
            'SaisieRefP2EtudesDemarrage__c,SaisieRefP2Amortissements__c,SaisieRefP2AutresChargesEtProduits__c,SaisieRefP3VentesServices__c,'+
            'SaisieRefP3AchatsExternes__c,SaisieRefP3Autreschargesetproduits__c,SaisieRefP4Investissements__c,SaisieRefP4VentesServices__c,'+
            'SaisieRefP4Amortissements__c,SaisieRefP4Autreschargesetproduits__c,SaisieRefP6VentesServices__c,SaisieRefP6AchatsExternes__c,'+
            'SaisieRefP6Autreschargesetproduits__c,SaisieRefMainOeuvreDontNbHeureP2__c,SaisieRefMainOeuvreDontNbHeureP3__c,'+
            'SaisieRefMainOeuvreDontNbHeureP6__c,SaisieRefMainOeuvreValorisationTHO__c,SaisieRefMainOeuvreEffectifDedie__c,'+
            'SaisieRefMOValorisationCoutDirect__c , id, TechFormuleEcart__c from fiche_de_synthese__c where TechFormuleEcart__c = false';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<fiche_de_synthese__c> Listfds)
    {
        List<Fiche_de_synthese__c> listfdsUpdate = new List<Fiche_de_synthese__c>();
        for (Fiche_de_synthese__c fds:Listfds)
        {
            Boolean State = fds.SaisieRefP1Investissements__c <> NULL ||fds.SaisieRefP1VentesServices__c <> NULL ||
                fds.SaisieRefP1AchatsEnergieGaz__c <> NULL ||fds.SaisieRefP1AchatsEnergieFuel__c <> NULL ||
                fds.SaisieRefP1AchatsEnergieCharbon__c <> NULL ||fds.SaisieRefP1AchatsEnergieBiomasse__c <> NULL ||
                fds.SaisieRefP1AchatsEnergieElectricite__c <> NULL ||fds.SaisieRefP1AchatsAutresEnergies__c <> NULL ||
                fds.SaisieRefP1Amortissements__c <> NULL ||fds.SaisieRefP1AutresChargesEtProduits__c <> NULL ||
                fds.SaisieRefP2Investissements__c <> NULL ||fds.SaisieRefP2VentesServices__c <> NULL ||
                fds.SaisieRefP2Fournituresetpetitsmat__c <> NULL ||fds.SaisieRefP2Electricite__c <> NULL ||
                fds.SaisieRefP2EauProduitsTrait__c <> NULL ||fds.SaisieRefP2STControlesReglem__c <> NULL ||
                fds.SaisieRefP2STEntretienCompteurs__c <> NULL ||fds.SaisieRefP2STGECogeneration__c <> NULL ||
                fds.SaisieRefP2STTraitementEau__c <> NULL ||fds.SaisieRefP2STMultiservices__c <> NULL ||
                fds.SaisieRefP2STAutresPrestations__c <> NULL ||fds.SaisieRefP2SousTraitanceInterne__c <> NULL ||
                fds.SaisieRefP2LocationsEntretien__c <> NULL ||fds.SaisieRefP2Telesurveillance__c <> NULL ||
                fds.SaisieRefP2EtudesDemarrage__c <> NULL ||fds.SaisieRefP2Amortissements__c <> NULL ||
                fds.SaisieRefP2AutresChargesEtProduits__c <> NULL ||fds.SaisieRefP3VentesServices__c <> NULL ||
                fds.SaisieRefP3AchatsExternes__c <> NULL ||fds.SaisieRefP3Autreschargesetproduits__c <> NULL ||
                fds.SaisieRefP4Investissements__c <> NULL ||fds.SaisieRefP4VentesServices__c <> NULL ||
                fds.SaisieRefP4Amortissements__c <> NULL ||fds.SaisieRefP4Autreschargesetproduits__c <> NULL ||
                fds.SaisieRefP6VentesServices__c <> NULL ||fds.SaisieRefP6AchatsExternes__c <> NULL ||
                fds.SaisieRefP6Autreschargesetproduits__c <> NULL ||fds.SaisieRefMainOeuvreDontNbHeureP2__c <> NULL ||
                fds.SaisieRefMainOeuvreDontNbHeureP3__c <> NULL ||fds.SaisieRefMainOeuvreDontNbHeureP6__c <> NULL ||
                fds.SaisieRefMainOeuvreValorisationTHO__c <> NULL ||fds.SaisieRefMainOeuvreEffectifDedie__c <> NULL ||
                fds.SaisieRefMOValorisationCoutDirect__c <> NULL ;
            
            if (fds.TechFormuleEcart__c <> State)
            {
                fds.TechFormuleEcart__c = State;
                listfdsUpdate.add(fds);
            }
            
        }
        if (listfdsUpdate<>Null && listfdsUpdate.size()>0)
        {
            try
            {
                Update listfdsUpdate;
            }
            catch(exception e)
            {
                System.debug('Error while Update ---->'+ e.getMessage());
            }
        }
    }
    
    global void finish(Database.BatchableContext BC) 
    {
    }
    
}