<template>
<b-row>
    <b-col cols=3>
        <h1>Datasets</h1>
        <b-list-group>
            <dataset-group v-for="org in organizations"
                :key="org.id"
                :selected="selected"
                :group="org"
                @selected="selectDataset"
            ></dataset-group>
        </b-list-group>

    </b-col>
    <b-col>
        <!-- Dataset View -->
        <dataset-pane v-if="selected !== undefined" :dataset="selected"></dataset-pane>
    </b-col>
</b-row>
</template>

<script>
import DatasetGroup from './DatasetGroup.vue'
import DatasetPane from './DatasetPane.vue'

export default  {
    name: 'DatasetBrowser',
    components: {DatasetPane, DatasetGroup},
    data(){
        return {
        datasets: [],
        organizations: [],
        selected: undefined
        }
    },
    mounted(){
        console.log("Creating neo4j driver")
        let instance = this
        this.$neo4j.connect('bolt', '192.168.2.18', 7687, 'neo4j', 'password').then(()=>{
            instance.getDatasets()
        })

    },
    methods:{
        getDatasets(){
            let instance = this
            this.$neo4j.run("MATCH (o:organization)-[:owns]->(d:dataset) return d,o").then(
                    result => {

                    result.records.forEach(record=>{
                        instance.datasets.push({
                            id:record.get('d').properties.id,
                            name:record.get('d').properties.name,
                            orgName: record.get('o').properties.name,
                            orgId: record.get('o').properties.id
                            })
                    })

                    instance.organizations = this.computeOrgs()
                    
                }
            )
        },
        selectDataset(dataset){
            this.selected = dataset
        },
        computeOrgs(){
            let resultMap = new Map()
            console.log('computing organizations')
            this.datasets.forEach(dataset=>{
                console.log(dataset.orgId)
                if (resultMap.has(dataset.orgId)){
                    console.log('has!')
                    let org = resultMap.get(dataset.orgId)
                    org.datasets.push(dataset)
                    resultMap.set(dataset.orgId, org)
                }else{
                    console.log('has not')
                    resultMap.set(dataset.orgId, {
                        name:dataset.orgName,
                        id: dataset.orgId,
                        datasets: [dataset]
                    })
                }
            })

            let result = []
            resultMap.forEach((value)=>{
                result.push(value)
            })

            return result
        }
    }
}
</script>
