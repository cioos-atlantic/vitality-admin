<template>
<div class="d-flex flex-column">
    <div class="d-flex justify-content-between">
        <h1 class="text-left">Public Visibility Settings </h1>
        <div class="d-flex">
            <div v-show="showSaved" class="text-success align-self-center mr-2">Saved!</div>
            <b-btn @click="updatePublicFields('public', publicallyVisible)" variant="primary">Save</b-btn>
        </div>
    </div>
    <div class="d-flex justify-content-between">
        <h4 class="text-left">{{dataset.name}}</h4>
        <p>{{elements.length}} fields</p>
    </div>
    
    
    <b-form-checkbox-group stacked
        class="text-left"
        :options="elementOptions"
        v-model="publicallyVisible"
        @change="showSaved = false">

    </b-form-checkbox-group>
        
</div>
</template>
<script>

export default {
    name: "DatasetPane",
    props: ['dataset'],
    data(){
        return{
            elements: [],
            publicallyVisible: [],
            showSaved: false
        }
    },
    computed:{
        elementOptions: function() {
            let result = []
            this.elements.forEach(e=>{
                result.push({
                    text: e.name,
                    value: e.id,
                    disabled: e.required
                })
            })
            result.sort((a,b)=>a.text.toUpperCase() < b.text.toUpperCase()? -1 : 1)
            return result
        }
    },
    mounted(){
        this.populateElements()
        this.getVisibleElements()
    },
    watch:{
        id: function(){
            this.showSaved = false
            this.populateElements()
            this.getVisibleElements()
        }
    },
    methods:{
        populateElements(){
            let instance = this
            instance.elements = []
            this.$neo4j.run("MATCH (d:dataset {id:$id})-[:has]->(e:element) return e", {
                id: instance.dataset.id
            }).then(
                    result => {
                    result.records.forEach(record=>{
                        instance.elements.push({
                            id: record.get('e').properties.id,
                            name: record.get('e').properties.name,
                            required: record.get('e').properties.required !== undefined?true:false
                        })
                    })
                }
            )
        },
        getVisibleElements(){
            let instance = this
            instance.publicallyVisible = []
            this.$neo4j.run("MATCH (d:dataset {id:$id})-[:has]->(e:element)<-[:can_see]-(u:user {id:'public'}) return e",{
                id: instance.dataset.id
            }).then(
                result =>{
                    result.records.forEach(record=>{
                        instance.publicallyVisible.push(record.get('e').properties.id)
                    })
                    console.log("updated visible elements for " + instance.id)
                }
            )
        },
        updatePublicFields(userId, fieldIds){
            let instance = this
            // Clear old visiblity settings for this user
            this.$neo4j.run("MATCH (u:user {id:$user})-[r:can_see]->(e:element)<-[:has]-(d:dataset {id:$datasetId}) DELETE r",{
                user:userId,
                datasetId: instance.id
            }).then(()=>{
                
                instance.$neo4j.run("MATCH (e:element)<-[:has]-(d:dataset) WHERE e.id IN $fields AND d.id = $datasetId CREATE (u:user {id:$user})-[:can_see]->(e)",
                {
                    datasetId: instance.id,
                    user:userId,
                    fields: fieldIds
                }).then(()=>{
                    instance.getVisibleElements()
                    instance.showSaved = true
                })

            })
        }
    }
}
</script>