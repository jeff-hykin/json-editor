let globalData
export let setupGlobalData = (Vue, data) => {
    globalData = data
    // connect the data to every child component
    Vue.mixin({
        data: ()=>({
            $global: globalData
        })
    })
}


export let windowListenersMixin = {
    data: ()=>({
        windowListeners$: {}
    }),
    mounted() {
        // add all the listeners
        for (let each in this.windowListeners$) {
            // bind all of them to the component
            this.windowListeners$[each] = this.windowListeners$[each].bind(this)
            window.addEventListener(each, this.windowListeners$[each])
        }
    },
    beforeDestroy() {
        // remove all the listeners
        for (let each in this.windowListeners$) {
            window.addEventListener(each, this.windowListeners$[each])
        }
    }
}