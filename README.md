Currently Under Construction

# What is this?

This is a vue component that edits/views a JSON object. A fantastic tool for hackathons.
![Screen Shot 2020-08-21 at 7 02 01 PM](https://user-images.githubusercontent.com/17692058/90943949-c75b0800-e3e1-11ea-9ab5-8dbdd6a9607e.png)

You can use the arrow keys to switch between the types (Null, Number, String, List, Object).

# How install use?

`npm install -s edit-json-vue`


Inside your .vue file:
```vue
let JsonEditor = require("edit-json-vue/src/jsonRoot.vue").default
export default {
    components: { JsonEditor },
}
```
