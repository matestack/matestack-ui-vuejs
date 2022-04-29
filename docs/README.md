---
description: >-
  Matestack Ui VueJs - Boost your productivity & easily create reactive web UIs
  in pure Ruby. Easily extend with pure JavaScript if required. No Opal
  involved.
---

# Welcome

{% hint style="info" %}
Version 3 was released on in February 2022. Click here for more [details](migrate-to-3.0.md)

**Most important changes:**

* Split `matestack-ui-core` into `matestack-ui-core` and `matestack-ui-vuejs`
* Rails 7 support
* Vue 3 support in `matestack-ui-vuejs`

****

You're reading the docs for 3.0 --> If you want to see the docs for Version 2.1, click [here](https://docs.matestack.io/matestack-ui-core/v/2.1/)
{% endhint %}

## About

`matestack-ui-vuejs` ships all you need to build **reactive** UIs in **pure Ruby** orchestrating prebuilt Vue.js components with a simple Ruby DSL.&#x20;

The prebuilt reactive components built **on top of Vue.js** are covering typical features of a reactive web UI, such as async form submission, dynamic page transitions or async partial UI updates. **No Opal involved**

If required, it can be easily extended with pure JavaScript.

### Why matestack-ui-vuejs?

`matestack-ui-vuejs` was created because modern web app development became more and more complex due to the rise of JavaScript frontend frameworks and the SPA frontend/REST API/JSON backend architecture. This sophisticated approach might be suitable for big teams and applications but is way to complex for most of small to medium sized teams and application scopes.

In contrast, `matestack-ui-vuejs` helps Rails developers creating modern, reactive web apps while focusing on **simplicity**, **developer happiness** and **productivity**:

* [x] Use Ruby’s amazing language features while creating your UI
* [x] Skip using templating engine syntax and write pure Ruby instead
* [x] Reduce the amount of required JavaScript in order to build reactive web UIs
* [x] Create a single application, managing the full stack from database to a reactive UI in pure Ruby
* [x] **Drastically reduce the complexity of building reactive web applications**

### What makes matestack-ui-vuejs different?

[Hotwire](https://hotwire.dev) and [Stimulus Reflex](https://docs.stimulusreflex.com) are awesome gems. They reduce the amount of required JavaScript when implementing reactive web UIs. They allow us to use more Rails and less JavaScript. **Great!**

Matestack, developed since 2018, goes even one step further: **Use more Ruby and less of everything else** (JavaScript, ERB/HAML/SLIM, CSS).

{% hint style="info" %}
**Why?** Because Ruby is just beautiful! More Ruby = More developer happiness = Higher productivity
{% endhint %}

Additionally, most of `matestack-ui-vuejs` does not require Action Cable or Redis, but can optionally use the power of these tools.

## Compatibility

`matestack-ui-vuejs` requires `matestack-ui-core`

`matestack-ui-vuejs` is tested against:

* Rails 7.0.1 + Ruby 3.0.0 + Vue.js 3.2.26
* Rails 6.1.1 + Ruby 3.0.0 + Vue.js 3.2.26
* Rails 6.1.1 + Ruby 2.7.2 + Vue.js 3.2.26 &#x20;
* Rails 6.0.3.4 + Ruby 2.6.6 + Vue.js 3.2.26
* Rails 5.2.4.4 + Ruby 2.6.6 + Vue.js 3.2.26

Rails versions below 5.2 are not officially supported.

Vue.js 2.x is supported when using the Compat build of Vue.js

## Getting Started

Start right away and install `matestack-ui-vuejs` on top of your Rails app, or read something about the features below.

{% content-ref url="getting-started/installation-update/" %}
[installation-update](getting-started/installation-update/)
{% endcontent-ref %}

{% content-ref url="getting-started/hello-world.md" %}
[hello-world.md](getting-started/hello-world.md)
{% endcontent-ref %}
