<template>
    <div unique-a23421e7a class="good-container" :style="{ ...shadowStyle, ...$attrs }" v-on="this.$listeners">
        <slot></slot>
    </div>
</template>

<script>
import { component } from "./common"
export default {
    props: {
        ...component.props,
    },
    computed: {
        ...component.computed,
    },
}
</script>

<style>
.good-container[unique-a23421e7a] {
    flex-direction: column;
}

[unique-a23421e7a] {
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
    align-items: flex-start;
    flex-wrap: nowrap; /* to disable bootstraps global CSS */
    margin: 0; /* to disable bootstraps global CSS */
}
</style>
