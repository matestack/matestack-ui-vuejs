import axios from 'axios'
import matestackEventHub from '../event_hub'
import componentMixin from './mixin'
import componentHelpers from './helpers'

const componentDef = {
  mixins: [componentMixin],
  props: ['props', 'params'],
  template: componentHelpers.inlineTemplate,
  data: function(){
    return {
      isolatedTemplate: null,
      loading: false,
      loadingError: false,
      hideCurrentContent: false
    }
  },
  methods: {
    replace: function(payload){
      this.hideCurrentContent = true
      this.rerender(payload)
    },
    rerender: function(payload){
      var self = this;
      if(self.props["public_context"] == undefined && payload != undefined && payload["public_context"] != undefined){
        self.props["public_context"] = {}
      }
      if(payload != undefined && payload["public_context"] != undefined){
        self.props["public_context"] = payload["public_context"]
      }
      self.loading = true;
      self.loadingError = false;
      if(self.props["rerender_delay"] != undefined){
        setTimeout(function () {
          self.renderIsolatedContent();
        }, parseInt(this.props["rerender_delay"]));
      } else {
        self.renderIsolatedContent();
      }
    },
    renderIsolatedContent: function(){
      var self = this;
      self.loading = true;
      self.loadingError = false;
      axios({
        method: "get",
        url: location.pathname + location.search,
        headers: {
          'X-CSRF-Token': self.getXcsrfToken()
        },
        params: {
          "component_class": self.props["component_class"],
          "public_context": self.props["public_context"]
        }
      })
      .then(function(response){
        self.loading = false;
        self.loadingStart = false;
        self.loadingEnd = true;
        self.hideCurrentContent = false;
        self.isolatedTemplate = response['data'];
      })
      .catch(function(error){
        self.loadingError = true;
        matestackEventHub.$emit('isolate_rerender_error', { class: self.props["component_class"] })
      })
    },
    startDefer: function(){
      const self = this
      self.loading = true;
      setTimeout(function () {
        self.renderIsolatedContent()
      }, parseInt(this.props["defer"]));
    }
  },
  created: function () {
    const self = this
  },
  beforeUnmount: function() {
    const self = this
    if(this.props["rerender_on"] != undefined){
      var rerender_events = this.props["rerender_on"].split(",")
      rerender_events.forEach(rerender_event => matestackEventHub.$off(rerender_event.trim(), self.rerender));
    }
    if(this.props["init_on"] != undefined){
      var rerender_events = this.props["rerender_on"].split(",")
      rerender_events.forEach(rerender_event => matestackEventHub.$off(rerender_event.trim(), self.renderIsolatedContent));
    }
    if(this.props["replace_on"] != undefined){
      var replace_events = this.props["replace_on"].split(",")
      replace_events.forEach(replace_event => matestackEventHub.$off(replace_event.trim(), self.replace));
    }
  },
  mounted: function (){
    const self = this
    if(this.props["init_on"] === undefined || this.props["init_on"] === null){
      if(self.props["defer"] == true || Number.isInteger(self.props["defer"])){
        if(!isNaN(self.props["defer"])){
          self.startDefer()
        }
        else{
          self.renderIsolatedContent();
        }
      }
    }else{
      if(self.props["defer"] != undefined){
        if(!isNaN(self.props["defer"])){
          var init_on_events = this.props["init_on"].split(",")
          init_on_events.forEach(init_on_event => matestackEventHub.$on(init_on_event.trim(), self.startDefer));
        }
      }else{
        var init_on_events = this.props["init_on"].split(",")
        init_on_events.forEach(init_on_event => matestackEventHub.$on(init_on_event.trim(), self.renderIsolatedContent));
      }
    }

    if(this.props["rerender_on"] != undefined){
      var rerender_events = this.props["rerender_on"].split(",")
      rerender_events.forEach(rerender_event => matestackEventHub.$on(rerender_event.trim(), self.rerender));
    }

    if(this.props["replace_on"] != undefined){
      var replace_events = this.props["replace_on"].split(",")
      replace_events.forEach(replace_event => matestackEventHub.$on(replace_event.trim(), self.replace));
    }

  }
}

export default componentDef
