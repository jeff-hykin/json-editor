<template>
    <!-- just a wrapper aroung the first value -->
    <div json-root-fni18943 override-fni18943 @mouseleave="onMouseLeave">
        <jsonValue :initValue="$attrs.initValue" @changeValue="changeHandler" isRoot=true />
    </div>
</template>

<script>
import jsonValue from "./jsonValue"
import {clearAllOldActiveTabs} from "./jsonValue"

export default {
    name: "jsonRoot",
    components: {
        jsonValue
    },
    mounted() {
    },
    methods: {
        changeHandler(...args) {
            if (this.$listeners.changeValue instanceof Function) {
                this.$listeners.changeValue(...args)
            }
        },
        onMouseLeave(eventObj) {
            clearAllOldActiveTabs()
        }
    }
}
</script>

<style lang="scss">
// by default disable things caused by bootstrap
[json-root-fni18943] {
    --old-shadow: 0 4px 5px 0 rgba(0,0,0,0.14), 0 1px 10px 0 rgba(0,0,0,0.12), 0 2px 4px -1px rgba(0,0,0,0.3);
    --shadow: 3.5px 7.5px 18px -13px rgba(71, 71, 71, 0.82);
    --tub-shadow: inset 3.5px 7.5px 18px -13px rgba(71, 71, 71, 0.82);
}
[add-button-fh3935], [json-root-fni18943] [json-list-fh3935] > button[add-button-fh3935] {
    --add-color: #81c784; 
    margin: 0;
    background: transparent;
    box-shadow: none;
    padding: calc(1.2em * 0.22);
    padding-top: 0;
    padding-bottom: calc(1.15em * 0.15);
    border-radius: 3rem;
    height: 0.96em;
    box-sizing: content-box;
    display: flex;
    align-items: center;
    justify-content: center;
    vertical-align: middle;
    font-size: 2em;
    border-width: medium;
    transform: scale(0.7);
    color: var(--add-color);
    border-color: var(--add-color);
}
</style>