import matestackEventHub from '../event_hub'
import componentMixin from './mixin'
import componentHelpers from './helpers'

const componentDef = {
  mixins: [componentMixin],
  template: componentHelpers.inlineTemplate,
  data: function(){
    return { }
  },
  methods: {
    perform: function(){
      if(this.props["public_context"]){
        matestackEventHub.$emit(this.props["emit"], { public_context: this.props["public_context"] })
      }else{
        matestackEventHub.$emit(this.props["emit"], this.props["data"])
      }
    }
  }
}

export default componentDef
