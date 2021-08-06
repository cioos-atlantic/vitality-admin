<template>
    <b-list-group-item variant="secondary">
        <div class="d-flex justify-content-between">
            <h5>{{group.name}}</h5>
            <v-icon name="chevron-down" v-b-toggle="group.id"></v-icon>
        </div>
        
        <b-collapse :id="group.id">
            <b-list-group>
                <b-list-group-item v-for="dataset in group.datasets"
                    :key="dataset.id"
                    @click="select(dataset)"
                    :active="selected !== undefined?selected.id === dataset.id:false"
                >
                    {{dataset.name}}
                </b-list-group-item>
            </b-list-group>
        </b-collapse>

    </b-list-group-item>
</template>

<script>

import 'vue-awesome/icons/chevron-down'
import Icon from 'vue-awesome/components/Icon'

export default {
    name: "DatasetGroup",
    components:{
        'v-icon':Icon
    },
    props: ['group', 'selected'],
    methods:{
        select(dataset){
            this.$emit('selected', dataset)
        }
    }
}
</script>