newComponent = require 'good-component'
Jss = require 'aphrodite-jss'

# 
# Styles
# 
sheet = Jss.StyleSheet.create
    wrapper: 
        display: 'flex'
        flexDirection: 'row'
        alignItems: 'flex-start'
        boxShadow: '0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)'
        borderRadius: '1.8rem'
        width: 'fit-content'
        padding: '0 .5rem'
        fontFamily: 'sans-serif'
        transition: 'all 500ms ease-in'
        margin: '0.3rem'
        marginBottom: '1rem'

wrapperClass = Jss.css(sheet.wrapper)

# 
# types
# 
    # every slot is one of:
        # null
        # number
        # text
        # list
        # object
    # every slot has 
        # a type picker
        # a value area
        # a remove button
    # lists have a "new item" button
    # named lists have a "new item" button
    
wrapperStyle = {}
selectStyle = 
    margin: "1rem"
areaStyle = 
    padding: "1rem"
textStyle =
    outline: 'none'
    borderRadius: '1.5rem'
    padding: '0.2rem 0.4rem'
    border: '2px gray solid'


Slot = newComponent(
    props:
        # TODO: connect each of these with their html counterparts
        props:
            wrapper: {}
            dropdown: {}
            option: {}
            area: {}
            null: {}
            number: {}
            text: {}
            list: {}
            namedList: {}
                
    data: ()->
        # where in the JSON this slot is
        location: []
        # which of the 5 types is this slot 
        type: "Text"
        # what is the value of the slot
        value: ""
    
    methods:
        newSlot: (postition) ->
            theNewSlot = new Slot
            console.log 'theNewSlot =',theNewSlot
            # tell the slot where it is
            theNewSlot.location = [...this.location, postition]
            # when the slot changes, update the value of the parent
            theNewSlot.$on "value", (data) =>
                position = theNewSlot.location[theNewSlot.location.length-1]
                this.value[position] = data
            return theNewSlot
    
    watch:
        type: ()->
            console.log 'this.type =',this.type
            # When the type changes, the area needs to change
            switch this.type
                when "Null"
                    this.value = null
                    this.area.children = [
                        <span>Null</span>
                    ]
                when "Number" 
                    this.value = 0
                    this.area.children = [
                        <input style={textStyle} type="number" value={0} oninput={(e)=>this.value = e.target.value} />
                    ]
                when "Text"
                    this.value = ""
                    this.area.children = [
                        <input style={textStyle} value={this.value} oninput={(e)=>this.value = e.target.value -0} />
                    ]
                when "List" 
                    this.value = []
                    this.area.children = [
                        <button
                            onclick={ (e)=> 
                                console.log 'this.newSlot =',this.newSlot
                                this.area.add(this.newSlot(this.area.children.length - 1))
                            }
                            >
                            +
                        </button>
                    ]
                when "Named List" 
                    this.value = {}
                    this.area.children = [
                        <div>Under construction</div>
                    ]
        
        value: ()->
            console.log 'this.value =',this.value
            # tell everyone the value changed
            this.$emit("value", this.value)
        
        
    dom: () ->
        window.thingy = this
        <div class={wrapperClass} style={wrapperStyle} >
            {this.dropdown = 
                <select style={selectStyle} name="Type" onchange={()=>this.type = this.dropdown.value}>
                    <option                    >Null</option>
                    <option                    >Number</option>
                    <option selected="selected">Text</option>
                    <option                    >List</option>
                    <option                    >Named List</option>
                </select>
            }
            {this.area = 
                <div style={areaStyle}>
                    <input style={textStyle} value={this.value} oninput={(e)=>this.value = e.target.value} />
                </div>
            }
        </div>
)


document.addEventListener "DOMContentLoaded", ()-> 
    document.body = <body>
        <Slot />
    </body>