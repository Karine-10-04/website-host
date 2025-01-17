<script setup>
import axios from 'axios';
import { createDebouncer } from 'promised-debounce';
import { Base64 } from 'js-base64';
import { defineAsyncComponent, computed, ref, shallowRef, onMounted, provide, watch } from 'vue';
import config from '@/public/config.yaml'
import TemplateTitle from '@/components/TemplateTitle.vue';
import TemplateCardWithImages from '@/components/TemplateCardWithImages.vue';
import TemplateCardWithClients from '@/components/TemplateCardWithClients.vue';
import TemplateCardWithItems from '@/components/TemplateCardWithItems.vue';

const templates = {
  TemplateTitle,
  TemplateCardWithImages,
  TemplateCardWithClients,
  TemplateCardWithItems,
}
const page = ref(0)
const hash = ref(null)
const debouncer = createDebouncer()
const frame = ref ({ scrollY: 0, innerHeight: 0 })
const measure = () => {
  const scrollY = window.scrollY
  const innerHeight = window.innerHeight
  frame.value = { scrollY, innerHeight }
  page.value = Math.round(scrollY / innerHeight - .5)
  debouncer({
    handler: () => {
      const { [page.value]: { nav } = {} } = config.sections
      if (nav) {
        hash.value = nav.toLowerCase()
      }
    },
    time: 50
  })
}

onMounted(() => {
  window.addEventListener('hashchange', () => {
    hash.value = window.location.hash.substr(1)
  }, false)
  window.addEventListener('scroll', measure, false)
  window.addEventListener('resize', measure, false)
  measure()
})

provide('frame', frame)

const logoStyle = computed(() => {
  return (page.value < 1)
    ? `opacity: 0`
    : `opacity: 1`
})

const links = computed(() => {
  const { sections = [] } = config
  return sections.reduce((a, section) => {
    return (section.nav)
      ? [ ...a, section.nav ]
      : a
  }, [])
})

const show = computed(() =>{
  const { scrollY = 0, innerHeight = 0 } = frame.value
  return Math.max(0, Math.floor(scrollY/(innerHeight + 1)))
})

const delta = computed(() => {
  const { scrollY = 0, innerHeight = 0 } = frame.value
  return ((scrollY - (show.value * innerHeight)) / innerHeight * 2) - 1
})
</script>
<template>
  <div class="w-full h-screen mx-auto">
    <div class="mx-auto max-w-none min-h-[var(--stick-items)]"
      :style="`min-height: ${config.sections.length+1}00vh;`"
    >
      <div class="absolute inset-0 min-h-screen space-y-0 z-0">
        <div class="w-full h-[50vh]"/>
        <a v-for="{ nav }, index) in config.sections"
          :name="(nav) ? nav.toLowerCase() : `section-${index}`"
          class="flex w-full h-screen"
          style="scroll-snap-align: start;"
        />
      </div>
      <div class="sticky top-0 h-screen space-y-0 z-2 md:pt-16 pt-28">
        <component v-for="({ component, bind, params }, index) in config.sections"
          :class="`absolute inset-0 z-[var(--z-index)] overflow-hidden`"
          :delta="(show < index) ? -1 : (show > index) ? 1 : delta"
          :style="`--z-index: ${(show == index) ? 2 : 1};`"

          :is="templates[component]"
          v-bind="{ index, ...bind }"
          :params="params"
        />
      </div>
    </div>
  </div>
  <header class="fixed top-0 w-full">
    <nav class="bg-primary shadow shadow-gray-300 w-100 px-8 md:px-auto">
      <div class="mx-auto md:px-4 container flex items-center justify-between flex-wrap md:flex-nowrap">
        <div class="text-white md:order-1 p-1">
          <img :src="config.logo" class="h-10 w-auto" :page="page" :style="`transition: opacity 0.2s 0s ease; ${logoStyle}`" />
        </div>
        <div class="text-white order-3 w-full md:w-auto md:order-2">
          <ul class="flex font-semibold justify-between">
            <li v-for="link of links"
              class="md:px-4 md:py-2 hover:text-grey-500"
              :class="(hash == link.toLowerCase()) ? 'text-secondary' : ''"
              ><a :href="`#${link.toLowerCase()}`">{{ (link) }}</a></li>
          </ul>
        </div>
      </div>
    </nav>
  </header>
  <footer class="fixed bottom-0 w-full">
    <nav class="bg-primary w-100 px-8 md:px-auto">

      <div class="mx-auto md:px-4 container flex flex-wrap md:flex-nowrap grid justify-items-end">
        <div class="text-white text-sm order-3 w-full md:w-auto">
          <ul class="flex justify-between">
            <li class="md:px-4 md:py-2 hover:text-grey-500">Téléphone|{{ config.phone }}</li>
            <li class="md:px-4 md:py-2 hover:text-grey-500"><a :href="`mailto:${config.email}`">{{ config.email }}</a></li>
          </ul>
        </div>
      </div>

    </nav>
  </footer>
</template>
<style>
html {
  scroll-snap-type: y mandatory;
}
</style>
