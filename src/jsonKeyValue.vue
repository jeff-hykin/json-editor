<template>
    <jsonValue :initValue="value" @changeValue="changeValue" @delete="deleteSelf" isKeyed=true >
        <!-- TODO: use the index to allow tabbing through -->
        <!-- TODO: validate key doesn't overlap other key -->
        <input
            type="text"
            :value="key"
            tabindex="1"
            @input="onInput($event)"
            @focus="$event.target.select()"
            >
    </jsonValue>
</template>

<script>
export default {
    name: "jsonKeyValue",
    components: {
        jsonValue: () => import('./jsonValue.vue')
    },
    data: ()=>({
        key: "",
        value: null,
        previousValueAsString: "null",
        previousKeyAsString: '""',
    }),
    mounted() {
        // TODO: make this a prop instead 
        this.key = this.$attrs.initKey
        this.value = this.$attrs.initValue
        this.attemptToInformParent()
    },
    computed: {
        // TODO: make this actually do something
        isValid() {
            if (typeof this.key == 'string') {
                if (this.key.length > 0) {
                    return true
                }
            }
        }
    },
    methods: {
        attemptToInformParent() {
            let newKey = this.key
            let newValue = this.value
            let newKeyAsString = JSON.stringify(newKey)
            let newValueAsString = JSON.stringify(newValue)
            let keyChanged = this.previousKeyAsString != newKeyAsString
            let valueChanged = this.previousValueAsString != newValueAsString
            // if there is a legitimate change
            if (keyChanged || valueChanged) {
                let oldKey = JSON.parse(this.previousKeyAsString)
                this.previousKeyAsString = newKeyAsString
                this.previousValueAsString = newValueAsString
                // and there is a listener
                if (this.$listeners.changeValue instanceof Function) {
                    // send the object the new value
                    this.$listeners.changeValue(oldKey, newKey, newValue)
                } else {
                    console.error("ERR: jsonKEY was called but didn't have a @changeValue listener attached\nthis is a bug with the jsonLib")
                }
            }
        },
        onInput($event) {
            this.key = $event.target.value
            this.attemptToInformParent()
        },
        changeValue(newValue) {
            // change the local value
            this.value = newValue
            // tell the parent object to update
            this.attemptToInformParent()
        },
        deleteSelf() {
            // give a warning before deleting an object/list
            if (!(this.value instanceof Object) || confirm("Are you sure you want to delete this?")) {
                if (this.$listeners.delete instanceof Function) {
                    this.$listeners.delete(this.key)
                } else {
                    console.error("ERR: jsonKEY was called but didn't have a @delete listener attached\nthis is a bug with the jsonLib")
                }
            }
        },
    }
}
</script>

<style lang="scss">
</style>