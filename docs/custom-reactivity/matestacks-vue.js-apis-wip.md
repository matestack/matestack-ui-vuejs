# Matestack's Vue.js APIs \[WIP]

## Event Hub

Matestack offers an event hub, which can be used to communicate between components.

### Emitting events

`app/matestack/components/some_component.js`

```javascript
import MatestackUiVueJs from "matestack-ui-vuejs";

const someComponent = {
  mixins: [MatestackUiVueJs.componentMixin],
  template: MatestackUiVueJs.componentHelpers.inlineTemplate,
  data() {
    return {}
  },
  mounted(){
    MatestackUiVueJs.eventHub.$emit("some-event", { some: "optional data" })
  }
}
export default someComponent
```

Use `MatestackUiVueJs.eventHub.$emit(EVENT_NAME, OPTIONAL PAYLOAD)`

### Receiving events

`app/matestack/components/some_component.js`

```javascript
import MatestackUiVueJs from "matestack-ui-vuejs";

const someComponent =  {
  mixins: [MatestackUiVueJs.componentMixin],
  template: MatestackUiVueJs.componentHelpers.inlineTemplate,
  data() {
    return {}
  },
  methods: {
    reactToEvent(payload){
      console.log(payload)
    }
  },
  mounted(){
    MatestackUiVueJs.eventHub.$on("some-event", this.reactToEvent)
  },
  beforeUnmount(){
    MatestackUiVueJs.eventHub.$off("some-event", this.reactToEvent)
  }
}
export default someComponent
```

Make sure to cancel the event listener within the `beforeUnmount` hook!

## General Vue.js API

As we're pretty much implementing pure Vue.js components, you can refer to the [Vue.js guides](https://vuejs.org/v3/guide/) in order to learn more about Vue.js component usage.

**Please note the following differences from the original Vue.js API:**

#### component $refs

* use `this.getRefs()` instead of `this.$refs`

#### component $el

* use `this.getElement()` instead of `this.$el`
