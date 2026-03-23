import { createApp } from 'vue'
import MatestackUiVueJs from '../../../../dist/matestack-ui-vuejs.esm.js'

//for specs only
window.MatestackUiVueJs = MatestackUiVueJs
import registerCustomComponents from './js/components'
//for specs only

const appInstance = createApp({})

registerCustomComponents(appInstance)

document.addEventListener('DOMContentLoaded', () => {
  MatestackUiVueJs.mount(appInstance)
})
