<template>
<b-row>
    <b-col cols=3>
        <h1>Datasets</h1>
        <b-list-group>
            <b-list-group-item
             v-for="dataset in datasets"
             :key="dataset.id" @click="selectDataset(dataset.id)" :active="selected === dataset.id">
                {{dataset.name}}
            </b-list-group-item>
        </b-list-group>
    </b-col>
    <b-col>
        <!-- Dataset View -->
        <dataset-pane v-if="selected !== undefined" :id="selected"></dataset-pane>
    </b-col>
</b-row>
</template>

<script>
import DatasetPane from './DatasetPane.vue'

export default  {
    name: 'DatasetBrowser',
    components: {DatasetPane},
    data(){
        return {
        datasets: [],
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
            this.$neo4j.run("MATCH (d:dataset) return d").then(
                    result => {
                    result.records.forEach(record=>{
                        instance.datasets.push({
                            id:record.get('d').properties.id,
                            name:record.get('d').properties.name})
                    })
                }
            )
        },
        selectDataset(id){
            this.selected = id
        }
    }
}
</script>
