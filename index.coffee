newComponent = require 'good-component'
Jss = require 'aphrodite-jss'

# 
# Styles
# 
heightOfMenu = '9rem'
widthOfMenu = '7rem'
topPadding = '1.2rem'
dotHeight = '1.7rem'
sheet = Jss.StyleSheet.create
    wrapper: 
        display: 'flex'
        flexDirection: 'row'
        alignItems: 'flex-start'
        boxShadow: '0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)'
        borderRadius: '1.8rem'
        width: 'fit-content'
        padding: topPadding + ' 1rem'
        fontFamily: 'sans-serif'
        transition: 'all 500ms ease-in'
        margin: '0.3rem'
        marginBottom: '1rem'
    option:
        transition: 'all 250ms ease-in-out'
        padding: '0.15rem 1rem'
        width: '100%'
        '&:hover':
            backgroundColor: 'white'
    options:
        transition: 'all 250ms ease-in-out'
        backgroundColor: 'whitesmoke'
        position: 'absolute'
        right: 0
        top: 0
        display: "flex"
        flexDirection: 'column'
        borderRadius: '2rem'
        overflow: 'hidden'
        maxWidth:  dotHeight
        maxHeight: dotHeight
        padding: '0rem'
        '& span':
            padding: '0.2rem'
            textAlign: 'center'
        # '& < div':
        #     height: heightOfMenu
        #     width: widthOfMenu
        #     flexDirection:'row'
        #     alignItems : 'center'
        #     backgroundColor: 'skyblue'
        '&:hover':
            zIndex: 99999
            right: '-5rem'
            top: '-'+topPadding
            paddingBottom: '1rem'
            maxHeight: heightOfMenu
            maxWidth: widthOfMenu
    button:
        width: 'fit-content'
        display: 'flex'
        alignItems: 'center'
        justifyContent: 'center'
        padding: '0.5em .9em 0.8em'
        borderRadius: '100vh'
        height: 'fit-content'
        outline: 'none'

classes = {}
for each of sheet
    classes[each] = Jss.css(sheet[each])

wrapperClass = Jss.css(sheet.wrapper)
optionsClass = Jss.css(sheet.options)
optionsContainerClass = Jss.css(sheet.optionsContainer)
optionClass = Jss.css(sheet.option)

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
areaStyle =
    display: 'flex'
    flexDirection: 'column'
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
                        <span style={minHeight: dotHeight, display: 'flex', alignItems: 'center'} >Null</span>
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
                        <button class={classes.button} onclick={ (e)=> this.area.add(this.newSlot(this.area.children.length - 1)) }>
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
        window.thingy || window.thingy = this
        <div class={wrapperClass}>
            {### main area ###}
            {this.area = 
                <div style={areaStyle}>
                    <input style={textStyle} value={this.value} oninput={(e)=>this.value = e.target.value} />
                </div>
            }
            {### buttons ###}
            <div style={ position :'relative', width: '2.2rem'} >
                {### type picker ###}
                <div class={optionsClass}>
                    <span style={marginTop: '-0.2rem', marginBottom: '0.2rem'} >...</span>
                    <div class={optionsContainerClass}>
                        <option class={optionClass} onclick={(e)=>this.type = e.target.innerHTML}>Null</option>
                        <option class={optionClass} onclick={(e)=>this.type = e.target.innerHTML}>Number</option>
                        <option class={optionClass} onclick={(e)=>this.type = e.target.innerHTML}>Text</option>
                        <option class={optionClass} onclick={(e)=>this.type = e.target.innerHTML}>List</option>
                        <option class={optionClass} onclick={(e)=>this.type = e.target.innerHTML}>Named List</option>
                    </div>
                </div>
                {### delete button ###}
            </div>
        </div>
)


document.addEventListener "DOMContentLoaded", ()-> 
    document.body = <body>
        <Slot />
    </body>