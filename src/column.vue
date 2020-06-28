<template>
    <div unique-add1e7fe class="good-column" :style="{...$attrs, ...justifyContentStyle, ...alignItemsStyle, ...flexWrapStyle, ...shadowStyle }" v-on="this.$listeners">
        <slot></slot>
    </div>
</template>
<script>
import {component} from './common'

export default {
    props: {
        ...component.props,
        'align-h': {
            type: String,
            validator: (value) => ['left', 'right', 'center', 'stretch', 'baseline', 'inherit', 'normal'].includes(value)
        },
        'align-v': {
            type: String,
            validator: (value) => ['top', 'bottom', 'center',  'space-around', 'space-between', 'space-evenly', 'stretch', 'baseline', 'inherit', 'normal'].includes(value)
        },
    },
    computed: {
        ...component.computed,
        justifyContentStyle() {
            let arrangement = this.$props.alignV || this.$attrs["justify-content"]
            let value = arrangement
            if (arrangement == 'top') {
                value = 'flex-start'
            } else if (arrangement == 'bottom') {
                value = 'flex-end'
            }
            return (value != null) && { 'justify-content': value }
        },
        alignItemsStyle() {
            let alignment = this.$props.alignH || this.$attrs["align-items"]
            let value = alignment
            let additionalValues = {}
            if (alignment == 'left') {
                value = 'flex-start'
                additionalValues = { 'text-align': 'left' }
            } else if (alignment == 'right') {
                value = 'flex-end'
                additionalValues = { 'text-align': 'right' }
            }
            return (value != null) && { 'align-items': value, ...additionalValues}
        },
    }
}
</script>
<style>
.good-column[unique-add1e7fe] {
    flex-direction: column;
}
[unique-add1e7fe] {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    flex-wrap: nowrap; /* to disable bootstraps global CSS */
    margin: 0; /* to disable bootstraps global CSS */
}
</style>
