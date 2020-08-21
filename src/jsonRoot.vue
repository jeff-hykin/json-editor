<template>
    <!-- just a wrapper aroung the first value -->
    <div json-root-fni18943 override-fni18943 @mouseleave="onMouseLeave">
        <jsonValue :initValue="$attrs.initValue" @changeValue="changeHandler" isRoot=true />
    </div>
</template>

<script>

// a really jank workaround because the bundler isn't working correctly
// ideally jsonValue and clearAllOldActiveTabs would just be imported
// BUT they're a recursive import which breaks the bundler
let exportObj = {
    name: "jsonRoot",
}
export let setup = (jsonValue, clearAllOldActiveTabs) => {
    let dynamicInternals = {
        components: {
            jsonValue,
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
    for (let each in dynamicInternals) {
        exportObj[each] = dynamicInternals[each]
    }
    return exportObj
}


export default exportObj
</script>

<style lang="scss">
// by default disable things caused by bootstrap
[json-root-fni18943] {
    --old-shadow: 0 4px 5px 0 rgba(0,0,0,0.14), 0 1px 10px 0 rgba(0,0,0,0.12), 0 2px 4px -1px rgba(0,0,0,0.3);
    --shadow: 3.5px 7.5px 18px -13px rgba(71, 71, 71, 0.82);
    --tub-shadow: inset 3.5px 7.5px 18px -13px rgba(71, 71, 71, 0.82);
}
[json-root-fni18943][override-fni18943] {
    margin: 1rem;
    margin-top: 2rem;
}
[add-button-fh3935] {
    --add-color: #81c784; 
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
</style>