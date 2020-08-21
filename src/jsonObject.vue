<template>
    <div json-object-fh3935 object-fh3935>
        <!-- TODO: stop using the this.valueKeys (optimize it out) -->
        <template v-for="(each, index) in this.masterValue">
            <jsonKeyValue :initKey="each.key" :initValue="each.value" v-bind:key="index"  @changeValue="updateKeyValue" @delete="deleteKey" />
        </template>
        <button
            add-button-fh3935
            @click="addKeyValue"
            tabindex=1
            >
            +
        </button>
    </div>
</template>
<script>


export default {
    name: "jsonObject",
    components: {
        jsonKeyValue: () => import('./jsonKeyValue.vue'),
    },
    props: {
    },
    data: ()=>({
        masterValue: [],
        value: {},
        previousValueAsString: "{}",
    }),
    mounted() {
        // init the masterValue
        for (const key in this.$attrs.initValue) {
            this.masterValue.push({key, value: this.$attrs.initValue[key]})
        }
        this.attemptToInformParent()
    },
    methods: {
        updateValue() {
            let object = {}
            for (const each of this.masterValue) {
                object[each.key] = each.value
            }
            this.value = object
        },
        attemptToInformParent() {
            this.updateValue()
            let newValue = this.value
            let newValueAsString = JSON.stringify(newValue)
            // if there is a legitimate change
            if (this.previousValueAsString != newValueAsString) {
                this.previousValueAsString = newValueAsString
                // and there is a listener
                if (this.$listeners.changeValue instanceof Function) {
                    // then send them the newValue
                    this.$listeners.changeValue(newValue)
                }
            }
        },
        addKeyValue() {
            if (this.masterValue.length == 0) {
                this.masterValue.push({ key: "untitled-1", value: null }) 
            } else {
                let lastElement = this.masterValue[this.masterValue.length-1]
                let number = lastElement.key.replace(/.+?(\d+)/,"$1")
                let name = lastElement.key.replace(/(.+?)\d+/, "$1")
                // FIXME: this needs to be done in a while loop to avoid duplicate auto-generated key names
                if (number-0==number-0) {
                    ++number
                    name += number
                } else {
                    name += "-1"
                }
                this.masterValue.push({key: name, value: null }) 
            }
            this.attemptToInformParent()
            // TODO: focus on the name of the newly created element
        },
        updateKeyValue(oldKey, key, value) {
            for (const eachIndex in this.masterValue) {
                let eachPair = this.masterValue[eachIndex]
                // TODO: raise an error when two pairs have the same key
                if (eachPair.key == oldKey) {
                    this.masterValue[eachIndex] = { key: key, value: value }
                }
            }
            this.attemptToInformParent()
        },
        deleteKey(key) {
            for (const eachIndex in this.masterValue) {
                let eachPair = this.masterValue[eachIndex]
                if (eachPair.key == key) {
                    delete this.masterValue[eachIndex]
                }
            }
            this.masterValue = this.masterValue.filter(each=>each!==undefined)
            // invalidate all the value so it'll actually refresh
            this.attemptToInformParent()
        },
    }
}
</script>
<style lang="scss">
[json-root-fni18943] [json-object-fh3935] {
    flex-direction: column;
    justify-content: center;
    align-items: center;
    margin: 0.1rem 0.3rem;
}
</style>
