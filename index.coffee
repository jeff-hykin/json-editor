newComponent = require 'good-component'
Jss = require 'aphrodite-jss'

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


# 
# TODO
# 
    # Delete functionality
        # create the delete button and styles
        # create the delete event
        # create the listener for the event
        # handle the re-indexing of elements in a list
    # Named slots
        # Change how the event handling of value works, add a location to the change
        # Create the name input box
        # Add the tracking of the sub value
    # improve text boxes
        # increase font size
        # convert them to text-areas
        # make them auto-expand
    
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
        marginBottom: '0.8rem'
    area:
        display: 'flex'
        flexDirection: 'column'
        alignItems: 'center'
    option:
        transition: 'all 250ms ease-in-out'
        padding: '0.15rem 1rem'
        width: '100%'
        '&:hover':
            backgroundColor: 'white'
    options:
        transition: 'all 250ms ease-in-out'
        backgroundColor: 'lightgray'
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
        padding: '0.5em .9em 0.75em'
        borderRadius: '100vh'
        height: 'fit-content'
        outline: 'none'
    null:
        minHeight: dotHeight
        display: 'flex'
        alignItems: 'center'
    text:
        outline: 'none'
        borderRadius: '1.5rem'
        padding: '0.2rem 0.4rem'
        border: '2px gray solid'
    dotDotDot:
        marginTop: '-0.2rem'
        marginBottom: '0.2rem'
    namedSlot:
        display: 'flex'
        flexDirection: 'column'

classes = {}
for each of sheet
    classes[each] = Jss.css(sheet[each])


Slot = newComponent
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
        newSlot: (position) ->
            theNewSlot = new Slot
            # tell the slot where it is
            theNewSlot.location = [...this.location, position]
            # when the slot changes, update the value of the parent
            theNewSlot.$on "value", (data) =>
                position = theNewSlot.location[theNewSlot.location.length-1]
                this.value[position] = data
            return theNewSlot
        
        newNamedSlot: () ->
            # TODO: finish this method
            
            # position = ""
            # value = undefined
            
            # # slot 
            # theNewSlot = new Slot
            # # tell the slot where it is
            # theNewSlot.location = [...this.location, position]
            # # 
            # updateValue = () ->
            #     position.length && this.value[position] = theNewSlot.value
            # # when the slot changes, update the value of the parent
            # theNewSlot.$on "value", (data) =>
            #     position = theNewSlot.location[theNewSlot.location.length-1]
            #     this.value[position] = data
            
            # <div class={classes.namedSlot}>
            #     <input oninput={(e) => 
            #         position = e.target.value;
            #         position.length && this.value[position] =  
            #         }
            #         />
            #     <Slot />
            # </div>
    watch:
        type: ()->
            console.log 'this.type =',this.type
            # When the type changes, the area needs to change
            switch this.type
                when "Null"
                    this.value = null
                    this.area.children = [
                        <span class={classes.null} >Null</span>
                    ]
                when "Number" 
                    this.value = 0
                    this.area.children = [
                        <input class={classes.text} type="number" value={0} oninput={(e)=>this.value = e.target.value} />
                    ]
                when "Text"
                    this.value = ""
                    this.area.children = [
                        <input class={classes.text} value={this.value} oninput={(e)=>this.value = e.target.value -0} />
                    ]
                when "List" 
                    this.value = []
                    this.area.children = [
                        this.listArea =  <div/>,
                        <button class={classes.button} onclick={ (e)=> this.listArea.add(this.newSlot(this.listArea.children.length)) }>
                            +
                        </button>
                    ]
                when "Named List" 
                    this.value = {}
                    this.area.children = [
                        this.listArea =  <div/>,
                        <button class={classes.button} onclick={ (e)=> this.listArea.add(this.newSlot(this.listArea.children.length)) }>
                            +
                        </button>
                    ]
        
        value: ()->
            console.log 'this.value =',this.value
            # tell everyone the value changed
            this.$emit("value", this.value)
        
        
    dom: () ->
        window.thingy || window.thingy = this
        <div class={classes.wrapper}>
            {### main area ###}
            {this.area = 
                <div class={classes.area}>
                    <input class={classes.text} value={this.value} oninput={(e)=>this.value = e.target.value} />
                </div>
            }
            {### buttons ###}
            <div style={ position :'relative', width: '2.2rem'} >
                {### type picker ###}
                <div class={classes.options}>
                    <span class={classes.dotDotDot} >...</span>
                    <div>
                        <option class={classes.option} onclick={(e)=>this.type = e.target.innerHTML}>Null</option>
                        <option class={classes.option} onclick={(e)=>this.type = e.target.innerHTML}>Number</option>
                        <option class={classes.option} onclick={(e)=>this.type = e.target.innerHTML}>Text</option>
                        <option class={classes.option} onclick={(e)=>this.type = e.target.innerHTML}>List</option>
                        <option class={classes.option} onclick={(e)=>this.type = e.target.innerHTML}>Named List</option>
                    </div>
                </div>
                {### delete button ###}
            </div>
        </div>



document.addEventListener "DOMContentLoaded", ()-> 
    document.body = <body>
        <Slot />
    </body>