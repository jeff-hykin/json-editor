import Column from "./column.vue"
import Row from "./row.vue"
import Container from "./container.vue"
import { setupGlobalData } from "./utils"

export default {
    setupGlobalData,
    windowListenersMixin,
    install(Vue, options) {
        // Let's register our component globally
        // https://vuejs.org/v2/guide/components-registration.html
        Vue.component("column", Column)
        Vue.component("row", Row)
        Vue.component("container", Container)
    },
}
