newComponent = require 'good-component'

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
    
wrapperStyle =
    display: 'flex'
    flexDirection: 'row'
    alignItems: 'flex-start'
    background: 'whitesmoke'
    borderRadius: '2rem'
    width: 'fit-content'
    padding: '0 .5rem'
selectStyle = 
    margin: "1rem"
areaStyle = 
    padding: "1rem"


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
    
    watch:
        type: ()->
            console.log 'this.type =',this.type
            # When the type changes, the area needs to change
            switch this.type
                when "Null"       then this.value = null; this.area.children = [<span>Null</span>]
                when "Number"     then this.value = 0   ; this.area.children = [<input type="number" value={0} oninput={(e)=>this.value = e.target.value} />]
                when "Text"       then this.value = ""  ; this.area.children = [<input value={this.value} oninput={(e)=>this.value = e.target.value -0} />]
                when "List"       then this.value = []  ; this.area.children = [<div>Under construction</div>]
                when "Named List" then this.value = {}  ; this.area.children = [<div>Under construction</div>]
        
        value: ()->
            console.log 'this.value =',this.value
            # tell everyone the value changed
            this.$emit("value", this.value)
        
        
    dom: () ->
        window.thingy = this
        <div style={wrapperStyle} >
            {this.dropdown = 
                <select style={selectStyle} name="Type" onchange={()=>this.type = this.dropdown.value}>
                    <option>Null</option>
                    <option>Number</option>
                    <option selected="selected">Text</option>
                    <option>List</option>
                    <option>Named List</option>
                </select>
            }
            {this.area = 
                <div style={areaStyle}>
                    <input value={this.value} oninput={(e)=>this.value = e.target.value} />
                </div>
            }
        </div>
)

document.body = <body>
    <Slot />
</body>