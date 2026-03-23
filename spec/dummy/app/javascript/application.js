import { createApp } from 'vue'
import MatestackUiVueJs from '../../../../dist/matestack-ui-vuejs.esm.js'

const appInstance = createApp({})

document.addEventListener('DOMContentLoaded', () => {
  MatestackUiVueJs.mount(appInstance)
})
