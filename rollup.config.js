import resolve from "@rollup/plugin-node-resolve"
import commonjs from "@rollup/plugin-commonjs"
import json from '@rollup/plugin-json';
import { terser } from "rollup-plugin-terser"

const terserOptions = {
  mangle: true,
  compress: true
}

export default [
  {
    input: "./lib/matestack/ui/vue_js/index.js",
    external: ['vue'],
    output: [
      {
        file: "./dist/matestack-ui-vuejs.esm.js",
        format: "es",
        globals: { vue: 'Vue', axios: 'axios' },
      }
    ],
    plugins: [
      resolve({ browser: true }),
      json(),
      commonjs(),
      terser(terserOptions)
    ]
  }
]
