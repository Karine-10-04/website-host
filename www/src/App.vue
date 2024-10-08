<script setup>
import axios from 'axios';
import { createDebouncer } from 'promised-debounce';
import { Base64 } from 'js-base64';
import Parallaxy from '@lucien144/vue3-parallaxy';
import { defineAsyncComponent, computed, ref, shallowRef, onMounted, provide, watch } from 'vue';


import TemplateTitle from '@/components/TemplateTitle.vue';
import TemplateCard1 from '@/components/TemplateCard1.vue';
import TemplateCard2 from '@/components/TemplateCard2.vue';
import ParallaxExample1 from '@/components/ParallaxExample1.vue';
const templates = {
  TemplateTitle,
  TemplateCard1,
  TemplateCard2,
  ParallaxExample1,
}

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
    nav: 'Intro1',
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
    component: 'TemplateTitle',
    nav: 'Intro2',
    bind: {
      class: 'bg-white',
    },
    params: {
      title1: {
        text: 'Madame',
        animation: 'up-50, fadein-100',
        class: 'font-neutra-condensed text-primary text-4xl font-medium uppercase'
      },
      title2: {
        text: 'Karine',
        animation: 'down-50, fadein-100',
        class: 'font-neutra-condensed text-primary text-4xl font-medium uppercase'
      },      
    }
  },
  {
    component: 'TemplateTitle',
    nav: 'Intro3',
    bind: {
      class: 'bg-primary',
    },
    params: {
      title1: {
        text: 'Madame',
        animation: 'up-50, right-50, fadein-100',
        class: 'font-neutra-thin text-white text-4xl font-medium uppercase'
      },
      title2: {
        text: 'Karine',
        animation: 'down-50, left-50, fadein-100',
        class: 'font-neutra-thin text-white text-4xl font-medium uppercase'
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
      subTitle: { 
        text: 'Sub Title', 
        class: 'font-neutra-thin text-primary font-bold uppercase', 
        animation: 'up, fadein' },
      title: { 
        text: 'Title', 
        class: 'font-neutra-condensed text-4xl text-slate-900 font-extrabold uppercase', 
        animation: 'left, fadein' 
      },
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
        class: 'font-neutra-thin text-white font-bold uppercase', 
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
  },
  {
    component: 'TemplateCard2',
    nav: 'Three',
    bind: {
      class: 'bg-white',
    },
    params: {
      subTitle: { 
        text: 'Demo', 
        class: 'font-neutra-thin font-bold uppercase', 
        animation: 'up-100, fadein' },
      title: { 
        text: 'A page with bullet points', 
        class: 'font-neutra-condensed text-4xl text-primary font-extrabold uppercase', 
        animation: 'up-50, fadein' },
      content: { 
        text: `More Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.`, 
        class: 'text-lg', 
        animation: 'up-25, fadein' },
      items: [
        {
          title: 'Item #1',
          text: 'ore Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
          src: `https://picsum.photos/1000?4`,
          alt: 'stock photo',
          animation: 'right-100, fadein' 
        },
        {
          title: 'Item #2',
          text: 'ore Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
          src: `https://picsum.photos/1000?5`,
          alt: 'stock photo',
          animation: 'left-100, fadein' 
        },
        {
          title: 'Item #3',
          text: 'ore Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
          src: `https://picsum.photos/1000?6`,
          alt: 'stock photo',
          animation: 'right-100, fadein' 
        },
      ],
    }
  },
  {
    component: 'TemplateCard2',
    nav: 'Four',
    bind: {
      class: 'bg-primary text-white',
    },
    params: {
      subTitle: { 
        text: 'Demo', 
        class: 'font-neutra-thin font-bold uppercase', 
        animation: 'up-100, fadein' },
      title: { 
        text: 'A page with bullet points', 
        class: 'font-neutra-condensed text-4xl text-primary font-extrabold uppercase', 
        animation: 'up-50, fadein' },
      content: { 
        text: `More Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.`, 
        class: 'text-lg', 
        animation: 'up-25, fadein' },
      items: [
        {
          title: 'Item #1',
          text: 'ore Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
          src: `https://picsum.photos/1000?4`,
          alt: 'stock photo',
          animation: 'right-100, fadein' 
        },
        {
          title: 'Item #2',
          text: 'ore Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
          src: `https://picsum.photos/1000?5`,
          alt: 'stock photo',
          animation: 'left-100, fadein' 
        },
        {
          title: 'Item #3',
          text: 'ore Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
          src: `https://picsum.photos/1000?6`,
          alt: 'stock photo',
          animation: 'right-100, fadein' 
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
