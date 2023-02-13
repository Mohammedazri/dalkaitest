/**
* @author Alain Ghoussoub
* @date 30/9/2019
* @description Test class de WS12_Parametrage
*/
@isTest
public class WS12_Parametrage_TEST {
    @isTest
    public static void insertUpdateValuesTest(){
        WS12_Parametrage.JeuDeValeur jdv = new WS12_Parametrage.JeuDeValeur();
        jdv.nomJeuDeValeur = 'test';
        jdv.libelle = 'test';
        jdv.valeurs = new List<WS12_Parametrage.Valeurs>();
        WS12_Parametrage.Valeurs val = new WS12_Parametrage.Valeurs();
        val.activite = true;
        val.code = '123';
        val.dateDebut = System.today();
        val.dateFin = System.today() + 1;
        val.jvParent = 'test';
        val.numeroOrdre = 1;
        val.valeurParDefault = false;
        val.valeurParent = new List<WS12_Parametrage.ValeurParent>();
        WS12_Parametrage.ValeurParent vp = new WS12_Parametrage.ValeurParent();
        vp.codeParent = '123';
        val.valeurParent.add(vp);
        jdv.valeurs.add(val);
        
        WS12_Parametrage.Valeurs val1 = new WS12_Parametrage.Valeurs();
        jdv.valeurs.add(val1);
        
        WS12_Parametrage.JeuDeValeur jdv1 = new WS12_Parametrage.JeuDeValeur();
        jdv1.valeurs = new List<WS12_Parametrage.Valeurs>();
        jdv1.valeurs.add(val1);
        
        WS12_Parametrage.JeuDeValeur jdv2 = new WS12_Parametrage.JeuDeValeur();
        jdv2.nomJeuDeValeur = 'test';
        jdv2.libelle = 'test';
        jdv2.valeurs = new List<WS12_Parametrage.Valeurs>();
        val.activite = false;
        val.code = '123';
        val.dateDebut = System.today();
        val.dateFin = System.today() + 1;
        val.jvParent = 'test';
        val.numeroOrdre = 1;
        val.valeurParDefault = true;
        val.valeurParent = new List<WS12_Parametrage.ValeurParent>();
        val.valeurParent.add(vp);
        jdv2.valeurs.add(val);
        
        WS12_Parametrage.JeuDeValeur jdv3 = new WS12_Parametrage.JeuDeValeur();
        
        WS12_Parametrage.insertUpdateValues(jdv);
        WS12_Parametrage.insertUpdateValues(jdv1);
        WS12_Parametrage.insertUpdateValues(jdv2);
        WS12_Parametrage.insertUpdateValues(jdv3);
    }
}