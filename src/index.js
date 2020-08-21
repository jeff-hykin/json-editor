import jsonValue from "./jsonValue.vue"
import {clearAllOldActiveTabs} from "./jsonValue.vue"
import jsonList from "./jsonList.vue"
import jsonObject from "./jsonObject.vue"
import jsonKeyValue from "./jsonKeyValue.vue"
import { setup } from "./jsonRoot.vue"
let jsonRoot = setup(jsonValue, clearAllOldActiveTabs)

export default {
    install(Vue, options) {
        // Let's register our component globally
        // https://vuejs.org/v2/guide/components-registration.html
        Vue.component("JsonEditor", jsonRoot)
    },
}
