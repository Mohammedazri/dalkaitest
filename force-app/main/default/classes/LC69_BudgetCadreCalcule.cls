/** 
* @author Jacques Akiki
* @date 07/07/2020 
* @Controller of lightning Component LC69
* @Test Class LC69_BudgetCadreCalcule_test 10%
*/
public without sharing class LC69_BudgetCadreCalcule {
    /** 
* @author Jacques Akiki
* @date 07/07/2020
* @Function that sums the latest budgets on contrats fils anr reports them on contrat Cadre.
* @param Id contId: id of the contract we are looking to sum bugets of contrat fils 
* @return instance of class WrapperBudget  
*/
    @AuraEnabled
    public static WrapperBudget getCurrentObject(Id contId)
    {
        WrapperBudget WB = new WrapperBudget();
        string currentYear = string.valueOf(System.Today().year());
        List<contrat__c> listCont = [SELECT id,EstContratCadre__c, Name FROM Contrat__c WHERE id=:contId];
        if (listCont!=NULL && listCont[0]!=NULL)
        {
            if(!listCont[0].EstContratCadre__c)
            {
                WB.ErrorMessage = Label.LC69_MessageErreur;// error to not show for contrats Fils 
                return WB;
            }
            else
            {
                /*select list of budget related to contats fils of contrat Cadre*/
                List<Budget__c> listBudget =[SELECT id, NomContrat__c,NomContrat__r.name,  AnneeBudget__c, CABudgetP1__c,  CABudgetP2__c,  CABudgetP3__c,  CABudgetP4__c,  
                                             CABudgetP6__c, MBBudgetP1__c,  MBBudgetP2__c,  MBBudgetP3__c,  MBBudgetP4__c,  MBBudgetP6__c,
                                             TotalCABudgetP1P2P3P4__c, TotalMBBudgetP1P2P3P4__c,BudgetNMainOeuvreDontNbHeureP2__c, 
                                             BudgetNMainOeuvreDontNbHeureP3__c, BudgetNMainOeuvreDontNbHeureP6__c, BudgetNMainOeuvreNombreHeureTotal__c
                                             FROM Budget__c
                                             WHERE NomContrat__r.contratcadre__c=:contId AND AnneeBudget__c=:currentYear];
                
                
                /*make sum of all budgets related to the contrat Cadre*/
                if(listBudget!=NULL && listBudget.size()>0)
                {
                    for (Budget__c bud:listBudget)
                    {
                        WB.CABP1=(WB.CABP1==NULL?0:WB.CABP1)+(bud.CABudgetP1__c==NULL?0:bud.CABudgetP1__c);
                        WB.CABP2=(WB.CABP2==NULL?0:WB.CABP2)+(bud.CABudgetP2__c==NULL?0:bud.CABudgetP2__c);
                        WB.CABP3=(WB.CABP3==NULL?0:WB.CABP3)+(bud.CABudgetP3__c==NULL?0:bud.CABudgetP3__c);
                        WB.CABP4=(WB.CABP4==NULL?0:WB.CABP4)+(bud.CABudgetP4__c==NULL?0:bud.CABudgetP4__c);
                        WB.CABP6=(WB.CABP6==NULL?0:WB.CABP6)+(bud.CABudgetP6__c==NULL?0:bud.CABudgetP6__c);
                        WB.MBBP1=(WB.MBBP1==NULL?0:WB.MBBP1)+(bud.MBBudgetP1__c==NULL?0:bud.MBBudgetP1__c);
                        WB.MBBP2=(WB.MBBP2==NULL?0:WB.MBBP2)+(bud.MBBudgetP2__c==NULL?0:bud.MBBudgetP2__c);
                        WB.MBBP3=(WB.MBBP3==NULL?0:WB.MBBP3)+(bud.MBBudgetP3__c==NULL?0:bud.MBBudgetP3__c);
                        WB.MBBP4=(WB.MBBP4==NULL?0:WB.MBBP4)+(bud.MBBudgetP4__c==NULL?0:bud.MBBudgetP4__c);
                        WB.MBBP6=(WB.MBBP6==NULL?0:WB.MBBP6)+(bud.MBBudgetP6__c==NULL?0:bud.MBBudgetP6__c);
                        WB.BNMNP2=(WB.BNMNP2==NULL?0:WB.BNMNP2)+(bud.BudgetNMainOeuvreDontNbHeureP2__c==NULL?0:bud.BudgetNMainOeuvreDontNbHeureP2__c);
                        WB.BNMNP3=(WB.BNMNP3==NULL?0:WB.BNMNP3)+(bud.BudgetNMainOeuvreDontNbHeureP3__c==NULL?0:bud.BudgetNMainOeuvreDontNbHeureP3__c);
                        WB.BNMNP6=(WB.BNMNP6==NULL?0:WB.BNMNP6)+(bud.BudgetNMainOeuvreDontNbHeureP6__c==NULL?0:bud.BudgetNMainOeuvreDontNbHeureP6__c);
                        WB.BNMNPtot=(WB.BNMNPtot==NULL?0:WB.BNMNPtot)+(bud.BudgetNMainOeuvreNombreHeureTotal__c==NULL?0:bud.BudgetNMainOeuvreNombreHeureTotal__c);
                        WB.totCAP1234=(WB.totCAP1234==NULL?0:WB.totCAP1234)+(bud.TotalCABudgetP1P2P3P4__c==NULL?0:bud.TotalCABudgetP1P2P3P4__c);
                        WB.totMBP1234=(WB.totMBP1234==NULL?0:WB.totMBP1234)+(bud.TotalMBBudgetP1P2P3P4__c==NULL?0:bud.TotalMBBudgetP1P2P3P4__c);
                    }
                    WB.Annee = currentYear;
                    WB.NomBudget =  Label.LC69_NomBudget+ ' '+ currentYear+ ' '+listCont[0].name;
                    WB.ErrorMessage = null;
                }
                else
                {
                    WB.ErrorMessage = Label.LC69_MessageErreur3;
                }
            }
            return WB;
        }
        else
        {
            WB.ErrorMessage = Label.LC69_MessageErreur2; 
            return WB;
        }
    }
}