<template>
    <div invisible-wrapper-285hg2u44 tabindex=1 @keydown="checkTypeSelector" @keypress="tryingToType" @mouseover="onHover" :isActive="isActive || isActivating">
        <!-- Select type -->
        <div type-picker-wrapper-fni18943 :isActive="isActive || isActivating" :isKeyed="$attrs.isKeyed">
            <div type-picker-fni18943>
                <button @click="nextType" >←</button>
                    <span>{{displayType()}}</span>
                <button @click="prevType" >→</button>
            </div>
        </div>
        
        <!-- Display Value -->
        <div value-bubble-285hg2u44 :type="type" :isKeyed="$attrs.isKeyed">
            <!-- for keys -->
            <slot />
            
            <!-- TODO: allow a restrictions argument -->
            <!-- Edit Value -->
            <div json-value-container-fni18943 :type="type">
                <template v-if="type == 'Null'">
                    <div style="font-weight: bold" >N/A</div>
                </template>
                <template v-if="type == 'Number'">
                    <input
                        ref="numberInput"
                        @input="onNumberInput($event)"
                        @keydown="incrementListener($event)"
                        @focus="$event.target.select()"
                        :value="numberValue"
                        tabindex=1
                        >
                </template>
                <template v-if="type == 'String'">
                    <input
                        ref="stringInput"
                        type="text"
                        @input="onStringInput($event)"
                        :value="stringValue"
                        placeholder="enter text"
                        tabindex=1
                        >
                </template>
                <template v-if="type == 'List'">
                    <jsonList :initValue="listValue" @changeValue="updateListValue" />
                </template>
                <template v-if="type == 'Object'">
                    <jsonObject :initValue="objectValue" @changeValue="updateObjectValue" />
                </template>
            </div>
        </div>
        
        <!-- Delete Button -->
        <!-- TODO: let focus on element show the button -->
        <button
            delete-button-285hg2u44
            v-if="!$attrs.isRoot"
            @click="onDelete"
            >
            X
        </button>
    </div>
</template>

<script>

let globalActiveHandlers = {}
let allActiveTabs = []
export let clearAllOldActiveTabs = ()=>{
    allActiveTabs.forEach(each=>each())
}
export default {
    name: "jsonValue",
    components: {
        jsonObject: () => import('./jsonObject.vue'),
        jsonList: () => import('./jsonList.vue'),
    },
    data: ()=>({
        currentTypeIndex: 0,
        value: null,
        previousValueAsString: "null", // keep a cache for checking
        // why have separate values?
        // so that if the type is accidentally toggled
        // it can be toggled back and the old value will be preserved
        // FIXME: currently this behavior isn't working because of the virtual dom deleting things
        numberValue: 0,
        stringValue: "",
        listValue: [],
        objectValue: {},
        // other
        type: "Null",
        isActive: false,
        isActivating: false,
        activeHandlers: {},
        typeOptions: [
            "Null",
            "Number",
            "String",
            "List",
            "Object",
        ],
        
    }),
    mounted() {
        let initValue = this.$attrs.initValue
        if (typeof initValue == "number" || initValue instanceof Number) {
            this.currentTypeIndex = this.typeOptions.indexOf("Number")
            this.numberValue = initValue || 0 // gets rid of NaN
        } else if (typeof initValue == "string" || initValue instanceof String) {
            this.currentTypeIndex = this.typeOptions.indexOf("String")
            this.stringValue = initValue 
        } else if (initValue instanceof Array) {
            this.currentTypeIndex = this.typeOptions.indexOf("List")
            this.listValue = initValue
        } else if (initValue instanceof Object) {
            this.currentTypeIndex = this.typeOptions.indexOf("Object")
            this.objectValue = initValue
        } else {
            this.currentTypeIndex = this.typeOptions.indexOf("Null")
        }
        
        if (this.$attrs.isRoot) {
            // if list was chosen
            if (this.currentTypeIndex == this.typeOptions.indexOf("List")) {
                // switch it to the new index for root
                this.currentTypeIndex = 1
            // in all other cases default to using an object
            } else {
                this.currentTypeIndex = 0
            }
            // root can only be an object or List
            this.typeOptions = [ "Object", "List" ]
        }
        
        // this will update this.type and this.value
        this.attemptToInformParent()
        
        // this is a painful work around to make sure 
        // that only one type-switcher tab is open/active at one time
        this.activeHandlers = {
            checkTypeSelector: (eventObj)=> {
                // prevent the outside-most parent from always activating first
                eventObj.stopPropagation()
                // only listen if the user isn't editing text in an input box
                if (!(eventObj.target.tagName == "INPUT" && eventObj.target.value.length > 0)) {
                    // switch the type with arrow keys
                    if (eventObj.key == "ArrowRight") {
                        this.nextType()
                    } else if (eventObj.key == "ArrowLeft") {
                        this.prevType()
                    }
                }
            },
            tryingToType: (eventObj)=> {
                // prevent the outside-most parent from always activating first
                eventObj.stopPropagation()
                if (!(eventObj.target.tagName == "INPUT")) {
                    // TODO: select the key-input box
                    // select one of the normal types
                    if (!this.isKeyed) {
                        if (this.type == "String") {
                            this.$refs.stringInput.focus()
                        } else if (this.type == "Number") {
                            this.$refs.numberInput.focus()
                        }
                    }
                }
            }
        }
        
    },
    methods: {
        displayType() {
            switch (this.type) {
                case "Object":
                    return "Named List"
                case "Null":
                    return "N/A"
                case "String":
                    return "Text"
                default:
                    return this.type
            }
        },
        onHover(eventObj) {
            // prevent the outside-most parent from always activating first
            eventObj.stopPropagation()
            // remove the tab status from all the other jsonValues
            this.isActivating = true
            clearAllOldActiveTabs()
            this.isActive = true
            this.isActivating = false
            // have all the listeners get forwarded to the active one
            globalActiveHandlers = this.activeHandlers
            // attach a callback for deactivation
            allActiveTabs.push(()=>{this.isActive = false})
        },
        checkTypeSelector(eventObj) {
            // just forward it to whichever one is active
            globalActiveHandlers.checkTypeSelector(eventObj)
        },
        tryingToType(eventObj) {
            // just forward it to whichever one is active
            globalActiveHandlers.tryingToType(eventObj)
        },
        // call parents to deal with delete
        onDelete() {
            if (this.$listeners.delete instanceof Function) {
                this.$listeners.delete()
            }
        },
        // 
        // state management: update
        // 
        updateType() {
            if (this.currentTypeIndex == this.typeOptions.length) {
                this.currentTypeIndex = 0
            } else if (this.currentTypeIndex == -1) {
                this.currentTypeIndex = this.typeOptions.length - 1
            }
            // in just a moment tell the parent the value just changed
            this.type =  this.typeOptions[this.currentTypeIndex]
        },
        updateValue() {
            this.updateType()
            switch (this.type) {
                case "Null"    : this.value = null               ; break;
                case "Number"  : this.value = this.numberValue-0 ; break;                
                case "String"  : this.value = this.stringValue   ; break;            
                case "List"    : this.value = this.listValue     ; break;            
                case "Object"  : this.value = this.objectValue   ; break;            
            }
        },
        attemptToInformParent() {
            this.updateValue()
            let newValue = this.value
            let newValueStringified = JSON.stringify(newValue)
            // if there is a legitimate change
            if (this.previousValueAsString != newValueStringified) {
                // update the previous value
                this.previousValueAsString = newValueStringified
                // tell parents something has legit changed
                if (this.$listeners.changeValue instanceof Function) {
                    // then send them the newValue
                    this.$listeners.changeValue(newValue)
                } else {
                    console.error("ERR: jsonVALUE was called but didn't have a @changeValue listener attached\nthis is a bug with the jsonLib")
                }
            }
        },
        // 
        // state management: report updates
        // 
        nextType() {
            this.currentTypeIndex++
            this.attemptToInformParent()
        },
        prevType() {
            this.currentTypeIndex--
            this.attemptToInformParent()
        },
        onNumberInput(eventObj) {
            let value = eventObj.target.value
            // enforce the input to always be a number
            value = value.replace(/[^\d-]*(-?(\d+\.\d*|\d*\.\d+|\d+)).*/,"$1")
            if (value-0 == value) {
                this.numberValue = eventObj.target.value = value
            } else {
                this.numberValue = eventObj.target.value = 0
            }
            this.attemptToInformParent()
        },
        incrementListener(eventObj) {
            if (eventObj.key == "ArrowUp") {
                this.numberValue = ++eventObj.target.value
            } else if (eventObj.key == "ArrowDown") {
                this.numberValue = --eventObj.target.value
            }
            this.attemptToInformParent()
        },
        onStringInput(eventObj) {
            this.stringValue = eventObj.target.value
            this.attemptToInformParent()
        },
        updateObjectValue(newValue) {
            this.objectValue = newValue
            this.attemptToInformParent()
        },
        updateListValue(newValue) {
            this.listValue = newValue
            this.attemptToInformParent()
        },
    },
}
</script>

<style lang="scss">
[json-root-fni18943] {
    [invisible-wrapper-285hg2u44] {
        --light-gray: #e6e6e6; // rgb(194,193,193);
        position: relative;
        width: fit-content;
        
        
        --type-picker-height: 2.2rem;
        --type-picker-animation: all 0.15s ease-in-out 0.2s;
        & > [type-picker-wrapper-fni18943][isActive] > [type-picker-fni18943] {
            transform: translate(0, 0);
        }
        [type-picker-wrapper-fni18943] {
            position: absolute;
            top: 0;
            --offset: 1.5rem;
            left: var(--offset);
            &[isKeyed] {
                left: calc(10rem + var(--offset));
            }
            
            height: fit-content;
            width: fit-content;
            transform: translate(0, -100%);
            pointer-events: none;
            overflow: hidden;
            // move thing to bottom
            align-items: flex-end;
            display: flex;
            
            & > [type-picker-fni18943] {
                pointer-events: all; // override the disabling of pointer events from the wrapper
                box-shadow: var(--shadow);
                box-shadow: 3.5px 7.5px 18px -6px rgba(71, 71, 71, 0.82);
                position: relative;
                top: 0;
                left: 0; // get out of the way of the delete button
                transform: translate(0, 100%);
                transition: var(--type-picker-animation);
                padding: 0.4rem;
                display: flex;
                flex-direction: row;
                align-items: center;
                justify-content: space-between;
                background: gray;
                color: whitesmoke;
                --border-radius: 1rem;
                border-top-left-radius: var(--border-radius);
                border-top-right-radius: var(--border-radius);
                border-bottom-left-radius: 0;
                border-bottom-right-radius: 0;
                border-bottom: none;
                
                
                & > span {
                    min-width: 5.5rem; // width of the largest option (e.g. "Named List")
                    text-align: center;
                }
                
                & > button {
                    background-color: transparent;
                    box-shadow: none;
                    outline: none;
                    border: none;
                    margin: 0rem;
                    font-weight: 100;
                    transform: scale(0.9);
                    color: inherit;
                    padding: 0;
                }
            }
        }
        
        --min-bubble-width: 11rem; // due to the size of the type picker
        --min-bubble-height: 1.9rem; // due to min size of text boxes
        --item-spacing: 0.8rem;
        --min-input-width: 8rem;
        [value-bubble-285hg2u44] {
            display: flex;
            flex-direction: row;
            position: relative;
            box-shadow: var(--shadow);
            background: white;
            border-radius: 1rem;
            min-width: 3rem;
            margin-top: var(--item-spacing);
            min-height: var(--min-bubble-height);
            justify-content: center; /* vertical */ 
            align-items: center;
            
            
            // the key
            & > input {
                margin: 0 1rem;
                border-top: none;
                border-left: none;
                border-right: none;
                padding: 0.2rem;
                height: 1.2em;
                width: var(--min-input-width);
            }
            
            &[isKeyed] {
                background: transparent;
                box-shadow: none;
                
                // &[type="Object"] [json-value-container-fni18943][type="Object"], &[type="List"] [json-value-container-fni18943][type="List"], {
                //     padding-top: 0rem;
                // }
                
                // the key
                & > input {
                    margin: 0 1rem;
                    border-top: none;
                    border-left: none;
                    border-right: none;
                    padding: 0.2rem;
                    height: 1.2em;
                    width: var(--min-input-width);
                }
                
                // &[type="Object"], &[type="List"] {
                //     & > input {
                //         background: white;
                //         border-radius: 1rem;
                //         padding: 0.3em 0.8em;
                //         box-sizing: content-box;
                //         align-self: flex-start;
                //         margin-top: 2rem;
                //     }
                // }
            }
            
            [json-value-container-fni18943]  {
                margin-top: -1px;
                --primitive-value-width: 10rem;
                --primitive-value-padding: 1.5rem;
                
                &[type="List"], &[type="Object"] {
                    min-width: calc(calc(var(--min-input-width) + var(--primitive-value-padding)) + var(--primitive-value-padding));
                    align-items: center;
                    text-align: center;
                    
                    // fill the area
                    flex-grow: 1;
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    padding-top: calc(var(--type-picker-height) - var(--item-spacing)); // bigger than the type-selector popup
                    border: 1px solid lightgrey;
                    padding-right: 0.3rem; // fix pixel bug
                    padding-left: 0.3rem;
                    padding-bottom: 0rem;
                    border-radius: 1rem;
                    align-items: flex-start;
                }
                
                &[type="String"] {
                    justify-content: center; /* vertical */ 
                    align-items: center;
                }
                
                &[type="Number"] {
                    justify-content: center; /* vertical */ 
                    align-items: center;
                    & > input {
                        text-align: right;
                        width: var(--primitive-value-width);
                    }
                }
                
                &[type="Null"] {
                    & > div {
                        font-weight: bold;
                        width: var(--primitive-value-width);
                        box-sizing: content-box;
                        padding: 0.39em var(--primitive-value-padding);
                        border-radius: 1rem;
                        border: 1px solid darkgray;
                        background: lightgray;
                        color: white;
                    }
                }
                
                & > input {
                    min-height: var(--min-bubble-height);
                    padding: 0 var(--primitive-value-padding); // because of the delete button overlap
                    width: var(--primitive-value-width) !important;
                    flex-grow: 1;
                    margin: 0;
                    border-radius: 1rem;
                    background: white;
                    box-shadow: var(--shadow);
                    box-sizing: content-box;
                }
            }
        }
        
        // hovered
        &[isActive] {
            & > [delete-button-285hg2u44] {
                opacity: 1;
                transform: translate(-45%, -45%) scale(1);
            }
        }
        
        [delete-button-285hg2u44] {
            
            // positioning
            position: absolute;
            top: 0;
            left: 0;
            opacity: 0;
            transform: translate(-30%, -30%) scale(0.7);
            // transform: translate(0, 120%);
            // left: 2.65rem;
            background: rgb(229, 115, 115);
            color:rgb(255, 255, 255);
            
            // size
            height: fit-content;
            width: fit-content;
            
            // color
            box-shadow: var(--shadow);
            box-sizing:border-box;
            color: white;
            
            // padding+border
            padding: 0.6em 1.2em;
            --border-radius: 1rem;
            border-radius: 0.3rem;
            padding: 0.3rem 0.5rem;
            // border-top-left-radius: var(--border-radius);
            // border-top-right-radius: var(--border-radius);
            // border-bottom-left-radius: 0;
            // border-bottom-right-radius: 0;
            
            // animate it
            transition: opacity 0.1s ease-in 0.1s, transform 0.1s ease-in 0.1s;
            // all the normal button properties
            // (just making sure they're not default overridden)
            // border
            border: rgb(190, 190, 190) solid 1.32812px;
            // margin
            margin: 0;
            // outline
            outline-color:rgb(255, 255, 255);
            outline-style:none;
            outline-width:0px;
            // font/text
            font-family:sans-serif;
            font-size:16px;
            font-stretch:100%;
            font-weight:400;
            font-style:normal;
            font-variant-caps:normal;
            font-variant-east-asian:normal;
            font-variant-ligatures:normal;
            font-variant-numeric:normal;
            letter-spacing:normal;
            line-height:normal;
            text-indent:0px;
            text-rendering:auto;
            text-shadow:none;
            text-size-adjust:100%;
            text-transform:none;
            word-spacing:0px;
            writing-mode:horizontal-tb;
            // alignment/positioning
            cursor:pointer;
            align-items:flex-start;
            display:block;
            flex-wrap:nowrap;
            overflow-x: auto;
            overflow-y: auto;
        }
    }
}
</style>