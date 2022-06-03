import matestackEventHub from '../event_hub'
import componentMixin from './mixin'
import componentHelpers from './helpers'

const componentDef = {
  mixins: [componentMixin],
  template: componentHelpers.inlineTemplate,
  data() {
    return {
      originalDisplayValue: "",
      dropPerformInProgress: false
    };
  },
  methods: {
    onDragStart: function(event){
      let self = this
      if(this.props["emit_on_drag_start"]){
        matestackEventHub.$emit(this.props["emit_on_drag_start"], {
          draggable_id: this.props["draggable_id"],
          drag_key: this.props["drag_key"],
          draggable_element: this.getElement()
        })
      }
      event.dataTransfer.effectAllowed = 'move';

      let draggableData = {
        draggable_id: this.props["draggable_id"],
        drag_key: this.props["drag_key"],
      }

      event.dataTransfer.setData('text/plain', JSON.stringify(draggableData));

      this.originalDisplayValue = this.getElement().style.display

      setTimeout(() => {
        // if not wrapped in timeout, the dragged element would be hidden as well
        // we only want the source element to hidden
        // credits: https://www.javascripttutorial.net/web-apis/javascript-drag-and-drop/
        self.getElement().style.display = "none"
      }, 0);
    },
    onDragEnd: function(event){
      let self = this
      if(this.props["emit_on_drag_end"]){
        matestackEventHub.$emit(this.props["emit_on_drag_end"], {
          draggable_id: this.props["draggable_id"],
          drag_key: this.props["drag_key"],
          draggable_element: this.getElement()
        })
      }
      this.getElement().style.display = this.originalDisplayValue
      if(this.dropPerformInProgress){
        this.getElement().style.opacity = 0.1
        this.getElement().draggable = false
        this.getElement().disabled = true
      }else{
        this.getElement().style.opacity = 1
      }
    },
    setDropPerformInProgress: function(event){
      if(event.draggableId == this.props["draggable_id"]){
        this.dropPerformInProgress = true
      }
    },
    unsetDropPerformInProgress: function(event){
      if(event.draggableId == this.props["draggable_id"]){
        this.dropPerformInProgress = false
      }
    }
  },
  mounted(){
    matestackEventHub.$on(this.props["drag_key"]+"_drop_perform_in_progress", this.setDropPerformInProgress)
    matestackEventHub.$on(this.props["drag_key"]+"_drop_perform_done", this.unsetDropPerformInProgress)
  },
  beforeUnmount(){
    matestackEventHub.$off(this.props["drag_key"]+"_drop_perform_in_progress", this.setDropPerformInProgress)
    matestackEventHub.$off(this.props["drag_key"]+"_drop_perform_done", this.unsetDropPerformInProgress)
  }
}

export default componentDef
