import componentMixin from "../mixin";
import componentHelpers from "../helpers";

const componentDef = {
  mixins: [componentMixin],
  template: componentHelpers.inlineTemplate,
  data: function () {
    return {};
  },
  inject: [
    'parentNestedFormRuntimeTemplates',
    'parentNestedFormRuntimeTemplateDomElements',
    'parentNestedForms'
  ],
  methods: {
    addItem: function(key){
      var templateString = JSON.parse(this.getTemplateElement().querySelector('#prototype-template-for-'+key).dataset[":template"])
      var regex = /&quot;component_uid&quot;:&quot;(.+?)&quot;/g
      var staticComponentUidMatches = templateString.matchAll(regex)
      var staticComponentUids = []
      for (const match of staticComponentUidMatches) {
        staticComponentUids.push(match[1])
      }
      staticComponentUids.forEach(function(uid){
        var newUid = Math.floor(Math.random() * 1000000000);
        templateString = templateString.replaceAll(uid, newUid);
      })
      var tmpDomElem = document.createElement('div')
      tmpDomElem.innerHTML = templateString
    
      if (this.parentNestedFormRuntimeTemplateDomElements[key] == null){
        var dom_elem = document.createElement('div')
        dom_elem.innerHTML = templateString
        var existingItemsCount;
        if (this.parentNestedForms[key] == undefined){
          existingItemsCount = 0
        }else{
          existingItemsCount = this.parentNestedForms[key].length
        }
        dom_elem.querySelector('.matestack-form-fields-for').id = key+"_child_"+existingItemsCount
        this.parentNestedFormRuntimeTemplateDomElements[key] = dom_elem
        this.parentNestedFormRuntimeTemplates[key] = this.parentNestedFormRuntimeTemplateDomElements[key].outerHTML
      }else{
        var dom_elem = document.createElement('div')
        dom_elem.innerHTML = templateString
        var existingItemsCount = this.parentNestedForms[key].length
        dom_elem.querySelector('.matestack-form-fields-for').id = key+"_child_"+existingItemsCount
        this.parentNestedFormRuntimeTemplateDomElements[key].insertAdjacentHTML(
          'beforeend',
          dom_elem.innerHTML
        )
        this.parentNestedFormRuntimeTemplates[key] = this.parentNestedFormRuntimeTemplateDomElements[key].outerHTML
      }
    }
  }
};

export default componentDef;
