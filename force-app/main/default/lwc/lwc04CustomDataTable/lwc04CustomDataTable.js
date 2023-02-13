import LightningDatatable from 'lightning/datatable';
import normalPicklist from './picklistTemplate.html'

const generateObjValPair = (_dataArray) => {
    return _dataArray.map(element => Object.assign({ value: element, label: element }))
}
export { generateObjValPair }

export default class Lwc04CustomDataTable extends LightningDatatable {

    static customTypes = {
        normalpicklist: {
            template: normalPicklist,
            typeAttributes: [
                'picklistOptions',
                'value',
                'label',
                'fieldApiName',
                'context'
            ]
        }
    };
}