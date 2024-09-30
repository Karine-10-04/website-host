<script setup>
import axios from 'axios';
import { Base64 } from 'js-base64';
import Parallaxy from '@lucien144/vue3-parallaxy';
import { computed, ref, shallowRef, onMounted,provide } from 'vue';
import Test from '@/components/test.vue';
import ParallaxExample1 from '@/components/ParallaxExample1.vue';

const REPO = import.meta.env.VITE_REPO;
const REPO_BRANCH = import.meta.env.VITE_REPO_BRANCH;
const REPO_FILE = import.meta.env.VITE_REPO_FILE;

const frame = ref ({ scrollY: 0, innerHeight: 0 })
const measure = () => {
  frame.value = { scrollY: window.scrollY, innerHeight: window.innerHeight }
}
onMounted(() => {
  window.addEventListener("scroll", measure, false);  
  window.addEventListener("resize", measure, false);  
  measure()
})
provide('frame', frame)

const sections = shallowRef([
  {
    component: ParallaxExample1,
    bind: {
      class: 'bg-blue-500',
    }
  },
  {
    component: ParallaxExample1,
    bind: {
      class: 'bg-orange-500'
    }
  },
  {
    component: ParallaxExample1,
    bind: {
      class: 'bg-green-500'
    }
  },
  {
    component: ParallaxExample1,
    bind: {
      class: 'bg-red-500'
    }
  },
  {
    component: ParallaxExample1,
    bind: {
      class: 'bg-yellow-500'
    }
  },
/*
  {
    component: Test,
    bind: {
      title: 'demo3'
    }
  }
  */
])

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
  <div class="w-full mx-auto">
    <div class="mx-auto max-w-none min-h-[var(--stick-items)]" 
      :style="`min-height: ${sections.length+1}00vh;`"
    >
      <div class="absolute inset-0 min-h-screen space-y-0 z-0">
        <div class="w-full h-[50vh]"/>
        <div v-for="index in sections.length"
          class="bg-red-500 w-full h-screen"
          style="scroll-snap-align: start;" 
        />
      </div>
      <div class="sticky top-0 h-screen space-y-0 z-2">
        <component v-for="({ component, bind }, index) in sections"
          :class="`absolute inset-0 z-[var(--z-index)] overflow-hidden`"
          :delta="(show < index) ? -1 : (show > index) ? 1 : delta"
          :style="`--z-index: ${(show == index) ? 2 : 1};`"

          :is="component"
          v-bind="{ index, ...bind }"
        />
      </div>    
    </div>
  </div>      
</template>
<style>
html {
  scroll-snap-type: y mandatory;
}
</style>


