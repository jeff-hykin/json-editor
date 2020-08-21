<template>
    <div json-list-fh3935>
        <!-- List everything -->
        <template v-for="(each, index) in this.value">
            <!-- TODO: use the index to allow tabbing through -->
            <jsonValue v-bind:key="uniqueKeysBecauseVueIsDumb[index]" @changeValue="elementValueChange(index, $event)" @delete="deleteElement(index, $event)" :initValue="each" />
        </template>
        <button
            add-button-fh3935
            @click="addElement"
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
        jsonValue: () => import('./jsonValue.vue')
    },
    data: ()=>({
        value: [],
        uniqueKeysBecauseVueIsDumb: [],
        previousValueAsString: "[]",
        randomIndexes: [],
    }),
    mounted() {
        this.value = this.$attrs.initValue || []
        this.attemptToInformParent()
    },
    methods: {
        attemptToInformParent() {
            let newValue = this.value
            let newValueAsString = JSON.stringify(newValue)
            // if there is a legitimate change
            if (this.previousValueAsString != newValueAsString) {
                this.previousValueAsString = newValueAsString
                // update the indexes when something actually changes
                this.value = [...this.value]
                // ensure that every index has a unique key
                for (let eachIndex in this.value) {
                    if (!this.uniqueKeysBecauseVueIsDumb[eachIndex]) {
                        this.uniqueKeysBecauseVueIsDumb[eachIndex] = Math.random()
                    }
                }
                // and there is a listener
                if (this.$listeners.changeValue instanceof Function) {
                    // then send them the newValue
                    this.$listeners.changeValue(newValue)
                }
            }
        },
        addElement() {
            // append an item
            this.value.push(null)
            this.uniqueKeysBecauseVueIsDumb.push(Math.random())
            this.attemptToInformParent()
            // TODO: focus on the name of the newly created element
        },
        elementValueChange(key, newElementValue) {
            this.value[key] = newElementValue
            this.attemptToInformParent()
        },
        deleteElement(key) {
            delete this.value[key]
            delete this.uniqueKeysBecauseVueIsDumb[key]
            this.value                      = this.value.filter(each=>each!==undefined)
            this.uniqueKeysBecauseVueIsDumb = this.uniqueKeysBecauseVueIsDumb.filter(each=>each!==undefined)
            this.attemptToInformParent()
        },
    }
}
</script>
<style lang="scss">
[json-root-fni18943] [json-list-fh3935] {
    flex-direction: column;
    justify-content: center;
    align-items: center;
    margin: 0.1rem 0.3rem;
    
    --add-color: #81c784; 
    & > button {
        margin: 0;
        background: transparent;
        box-shadow: none;
        padding: 0.85rem;
        border-radius: 3rem;
        height: 0.96em;
        box-sizing: content-box;
        display: flex;
        align-items: center;
        justify-content: center;
        vertical-align: middle;
        font-size: 2em;
        padding-top: 0;
        border-width: medium;
        transform: scale(0.7);
        color: var(--add-color);
        border-color: var(--add-color);
    }
}
</style>
