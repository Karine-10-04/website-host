<script setup>
import axios from 'axios';
import { createDebouncer } from 'promised-debounce';
import { Base64 } from 'js-base64';
import Parallaxy from '@lucien144/vue3-parallaxy';
import { defineAsyncComponent, computed, ref, shallowRef, onMounted, provide, watch } from 'vue';


import TemplateTitle from '@/components/TemplateTitle.vue';
import TemplateCard1 from '@/components/TemplateCard1.vue';
import ParallaxExample1 from '@/components/ParallaxExample1.vue';
const templates = {
  TemplateTitle,
  TemplateCard1,
  ParallaxExample1,
}

const REPO = import.meta.env.VITE_REPO;
const REPO_BRANCH = import.meta.env.VITE_REPO_BRANCH;
const REPO_FILE = import.meta.env.VITE_REPO_FILE;

const hash = ref(null)
const debouncer = createDebouncer()
const frame = ref ({ scrollY: 0, innerHeight: 0 })
const measure = () => {
  const scrollY = window.scrollY
  const innerHeight = window.innerHeight
  frame.value = { scrollY, innerHeight }
  const page = Math.round(scrollY / innerHeight - .5)
  debouncer({
    handler: () => {
      const { [page]: { nav } = {} } = sections.value
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

const logo = defineAsyncComponent(() => import(`@/assets/logo.svg`))

const sections = shallowRef([
{
    component: 'TemplateTitle',
    nav: '^',
    bind: {
      class: 'bg-primary',
    },
    params: {
      title1: {
        text: 'Madame',
        animation: 'right-50, fadein-100',
        class: 'font-neutra text-white text-4xl font-medium uppercase'
      },
      title2: {
        text: 'Karine',
        animation: 'left-50, fadein-100',
        class: 'font-neutra text-white text-4xl font-medium uppercase'
      },      
    }
  },
  {
    component: 'TemplateCard1',
    nav: 'One',
    bind: {
      class: 'bg-white',
    },
    params: {
      subTitle: { text: 'Sub Title', class: 'font-neutra text-primary font-semibold uppercase', animation: 'up, fadein' },
      title: { text: 'Title', class: 'font-neutra-condensed text-4xl text-slate-900 font-extrabold uppercase', animation: 'left, fadein' },
      content: { text: `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.` , animation: 'down' },
      images: [
        {
          src: `https://picsum.photos/1000?1`,
          alt: 'stock photo',
          animation: 'right, fadein',
          class: 'object-scale-down max-h-full drop-shadow-md rounded-md m-auto'
        }
      ],
    }
  },
  {
    component: 'TemplateCard1',
    nav: 'Two',
    bind: {
      class: 'bg-primary',
    },
    params: {
      subTitle: { 
        text: 'Another Sub Title', 
        class: 'font-neutra text-white font-semibold uppercase', 
        animation: 'up-100, fadein' },
      title: { 
        text: 'Another Title', 
        class: 'font-neutra-condensed text-4xl text-slate-900 font-extrabold uppercase', 
        animation: 'up-50, fadein' },
      content: { 
        text: `More Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.`, 
        class: 'text-white text-lg', 
        animation: 'up-25, fadein' },
      images: [
        {
          src: `https://picsum.photos/1000?2`,
          alt: 'stock photo',
          class: 'object-scale-down drop-shadow-md rounded-md m-auto',
          animation: 'right, fadein' 
        },
        {
          src: `https://picsum.photos/1000?3`,
          alt: 'stock photo',
          class: 'object-scale-down drop-shadow-md rounded-md m-auto',
          animation: 'left, fadein' 
        },
      ],
    }
  }
])

const links = computed(() => {
  return sections.value.reduce((a, section) => {
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

onMounted(() => {
  /* DISABLE
  axios
    .get(`https://api.github.com/repos/${REPO}/git/trees/${REPO_BRANCH}?recursive=1`)
    .then((response) => {
      const { data: { tree = [] }= {} } = response
      tree
        .filter(({ path }) => path == REPO_FILE)
        .map(({ url }) => { 
          axios 
            .get(url)
            .then(({ data: { content = '', encoding = 'base64' } = {} }) => {
              if (encoding !== 'base64'){
                throw new Error(`unhandled encoding: ${encoding}`)
              }
              if (!Base64.isValid(content)) {
                throw new Error(`invalid ${encoding} content: ${content}`)
              }
              const decoded = Base64.decode(content)
              const parsed = JSON.parse(decoded)

              console.log({ parsed })
            })
         })  
    })
  */
})
</script>
<template>
  <div class="w-full h-screen mx-auto">
    <div class="mx-auto max-w-none min-h-[var(--stick-items)]" 
      :style="`min-height: ${sections.length+1}00vh;`"
    >
      <div class="absolute inset-0 min-h-screen space-y-0 z-0">
        <div class="w-full h-[50vh]"/>
        <a v-for="{ nav }, index) in sections"
          :name="(nav) ? nav.toLowerCase() : `section-${index}`"
          class="flex w-full h-screen"
          style="scroll-snap-align: start;" 
        />
      </div>
      <div class="sticky top-0 h-screen space-y-0 z-2 md:pt-16 pt-28">
        <component v-for="({ component, bind, params }, index) in sections"
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
        <div class="text-white md:order-1">
          <component :is="logo" :class="'h-10 w-10'" viewBox="0 0 208.88933 210.22267"/>
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
</template>
<style>
html {
  scroll-snap-type: y mandatory;
}
</style>


