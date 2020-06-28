<template>
    <div unique-add1e7fa class="good-row" :style="{...$attrs, ...justifyContentStyle, ...alignItemsStyle, ...flexWrapStyle, ...shadowStyle }" v-on="this.$listeners">
        <slot></slot>
    </div>
</template>
<script>
import {component} from './common'

export default {
    props: {
        ...component.props,
        'align-v': {
            type: String,
            validator: (value) => ['top', 'bottom', 'center', 'stretch', 'baseline', 'inherit', 'normal'].includes(value)
        },
        'align-h': {
            type: String,
            validator: (value) => ['left', 'right', 'center',  'space-around', 'space-between', 'space-evenly', 'stretch', 'baseline', 'inherit', 'normal'].includes(value)
        },
    },
    computed: {
        ...component.computed,
        justifyContentStyle() {
            let arrangement = this.$props.alignH || this.$attrs["justify-content"]
            let value = arrangement
            let additionalValues = {}
            if (arrangement == 'left') {
                value = 'flex-start'
                additionalValues = { 'text-align': 'left' }
            } else if (arrangement == 'right') {
                value = 'flex-end'
                additionalValues = { 'text-align': 'right' }
            }
            return (value != null) && { 'justify-content': value, ...additionalValues }
        },
        alignItemsStyle() {
            let alignment = this.$props.alignV || this.$attrs["align-items"]
            let value = alignment
            if (alignment == 'top') {
                value = 'flex-start'
            } else if (alignment == 'bottom') {
                value = 'flex-end'
            }
            return (value != null) && { 'align-items': value }
        },
    }
}
</script>
<style>
.good-row[unique-add1e7fa] {
    flex-direction: row;
}

[unique-add1e7fa] {
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: center;
    flex-wrap: nowrap; /* to disable bootstraps global CSS */
    margin: 0; /* to disable bootstraps global CSS */
}
</style>
