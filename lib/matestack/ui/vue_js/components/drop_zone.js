import axios from "axios";

import matestackEventHub from '../event_hub'
import componentMixin from './mixin'
import componentHelpers from './helpers'

const componentDef = {
  mixins: [componentMixin],
  template: componentHelpers.inlineTemplate,
  data() {
    return {
      highlighted: false,
      hovered: false,
    };
  },
  methods: {
    highlight: function(eventData){
      if(eventData["drag_key"] == this.props["drag_key"]){
        this.highlighted = true
      }
    },
    disableHighlight: function(eventData){
      if(eventData["drag_key"] == this.props["drag_key"]){
        this.highlighted = false
      }
    },
    getHighlightClass: function(){
      return this.props["highlight_class"]
    },
    getHoveredClass: function(){
      return this.props["hover_class"]
    },
    onDrop: function(event) {
      let draggableData = JSON.parse(event.dataTransfer.getData('text/plain'))

      if(draggableData["drag_key"] == this.props["drag_key"]){
        this.perform(draggableData)
      }

      this.hovered = false
      this.highlighted = false

      if (event.preventDefault) {
        event.preventDefault()
      }
      return false
    },
    onDragEnter: function(event) {
      if (event.preventDefault) {
        event.preventDefault()
      }

      this.hovered = true
      return false
    },
    onDragLeave: function(event) {
      this.hovered = false
    },
    onDragOver: function(event) {
      if (event.preventDefault) {
        event.preventDefault()
      }
      this.hovered = true
      return false
    },
    perform: function(draggableData){
      let self = this
      let data = this.props["data"]
      data["draggable_id"] = draggableData["draggable_id"]

      matestackEventHub.$emit(self.props["drag_key"]+"_drop_perform_in_progress", { draggableId: data["draggable_id"] });
      axios({
          method: this.props["method"],
          url: this.props["path"],
          data: data,
          headers: {
            'X-CSRF-Token': document.getElementsByName("csrf-token")[0].getAttribute('content')
          }
        }
      )
      .then(function(response){
        if (self.props["success"] != undefined && self.props["success"]["emit"] != undefined) {
          matestackEventHub.$emit(self.props["success"]["emit"], response.data);
        }
        matestackEventHub.$emit(self.props["drag_key"]+"_drop_perform_done", { draggableId: data["draggable_id"] });
      })
      .catch(function(error){
        if (self.props["failure"] != undefined && self.props["failure"]["emit"] != undefined) {
          matestackEventHub.$emit(self.props["failure"]["emit"], error.response.data);
        }
        matestackEventHub.$emit(self.props["drag_key"]+"_drop_perform_done", { draggableId: data["draggable_id"] });
      })
    }
  },
  mounted(){
    if(this.props["highlight_on"]){
      matestackEventHub.$on(this.props["highlight_on"], this.highlight)
    }
    if(this.props["disable_highlight_on"]){
      matestackEventHub.$on(this.props["disable_highlight_on"], this.disableHighlight)
    }
  },
  beforeUnmount(){
    if(this.props["highlight_on"]){
      matestackEventHub.$off(this.props["highlight_on"], this.highlight)
    }
    if(this.props["disable_highlight_on"]){
      matestackEventHub.$off(this.props["disable_highlight_on"], this.disableHighlight)
    }
  }
}

export default componentDef
