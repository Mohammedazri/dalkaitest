global with sharing  class chartjsGonogoChart extends chartjsRadarChartData implements iChartjsDataProvider {
global static string getChartjsData(String recordId){
    	FicheGoNoGo__c f;
    	chartjsRadarChartData chartjsData = new chartjsRadarChartData();
    	chartjsData.labels = new list<string>{'Intérêt','Client','Commerce','Exploitation'};
      	chartjsData.datasets = new list<chartjsDataset>();
    	chartjsDataset ds = new chartjsDataset();
    
    	ds.label = '';
        ds.fillColor = 'rgba(0,120,0,0.2)';
    	ds.strokeColor = 'rgba(0,120,0,1)';
        ds.pointColor = 'rgba(220,220,220,1)';
        ds.pointStrokeColor = '#fff';
        ds.pointHighlightFill = '#fff';
        ds.pointHighlightStroke = 'rgba(220,220,220,1)';
        
        Integer score_strat = 0 ; 
        Integer score_client = 0 ;
    	Integer score_com = 0 ;
        Integer score_exploit = 0 ; 
    
    	
    	if (recordId!=null) 
        {
			f = [SELECT Id,interet_strategique_et_financier__c,score_client__c,score_commerce__c,score_exploitation__c FROM FicheGoNoGo__c WHERE Id = : recordId];
            //ds.data = new list<Integer>{f.interet_strategique_et_financier__c.intValue(), f.score_client__c.intValue(), f.score_commerce__c.intValue(), f.score_exploitation__c.intValue()};
            if (f.interet_strategique_et_financier__c!=null)  {score_strat = f.interet_strategique_et_financier__c.intValue();}
            if (f.score_client__c!=null) {score_client = f.score_client__c.intValue();} 
            if (f.score_commerce__c!=null) {score_com = f.score_commerce__c.intValue();}
            if (f.score_exploitation__c!=null) {score_exploit = f.score_exploitation__c.intValue(); }
        }

    	ds.data = new list<integer>{score_strat, score_client, score_com, score_exploit};
    	
    	chartjsData.datasets.add(ds);

    	return JSON.serialize(chartjsData);
    
       /* chartjsLineChartData chartjsData = new chartjsLineChartData();
        chartjsData.labels = new list<string>{recordId,'Feb','Mar','Apr','May','Jun','Jul'};
        chartjsData.datasets = new list<chartjsDataset>();
        chartjsDataset dataset;
        
        dataset = new chartjsDataset();
        dataset.label = 'My First dataset';
        dataset.fillColor = 'rgba(220,220,220,0.2)';
        dataset.strokeColor = 'rgba(220,220,220,1)';
        dataset.pointColor = 'rgba(220,220,220,1)';
        dataset.pointStrokeColor = '#fff';
        dataset.pointHighlightFill = '#fff';
        dataset.pointHighlightStroke = 'rgba(220,220,220,1)';
        dataset.data = new list<integer>{65, 59, 80, 81, 56, 55, 40};
        chartjsData.datasets.add(dataset);
        
        dataset = new chartjsDataset();
        dataset.label = 'My Second dataset';
        dataset.fillColor = 'rgba(151,187,205,0.2)';
        dataset.strokeColor = 'rgba(151,187,205,1)';
        dataset.pointColor = 'rgba(151,187,205,1)';
        dataset.pointStrokeColor = '#fff';
        dataset.pointHighlightFill = '#fff';
        dataset.pointHighlightStroke = 'rgba(151,187,205,1)';
        dataset.data = new list<integer>{28, 48, 40, 19, 86, 27, 90};
        chartjsData.datasets.add(dataset);
        
        return JSON.serialize(chartjsData);*/
    }
}