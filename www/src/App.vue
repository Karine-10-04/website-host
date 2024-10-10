<script setup>
import axios from 'axios';
import { createDebouncer } from 'promised-debounce';
import { Base64 } from 'js-base64';
import Parallaxy from '@lucien144/vue3-parallaxy';
import { defineAsyncComponent, computed, ref, shallowRef, onMounted, provide, watch } from 'vue';

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
      const { [page.value]: { nav } = {} } = sections.value
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

const config = shallowRef({
  logo: '/assets/logo.png',
  email: 'archives@madamekarine.com',
  phone: '438-380-5858',
  sections: [
    {
      component: 'TemplateTitle',
      bind: {
        class: 'bg-white',
      },
      params: {
        background: {
          url: 'images/AP-D0340-043-COFFIN-WILBERT.jpeg'
        },
        title1: {
          text: 'Archives',
          animation: 'up-50-easeInBack, fadein',
          class: 'font-neutra text-primary text-4xl font-medium uppercase'
        },
        title2: {
          text: 'Madame',
          animation: 'down-100-easeInBack, fadein-100',
          class: 'font-neutra text-primary text-4xl font-medium uppercase'
        },
        title3: {
          text: 'Karine',
          animation: 'down-50-easeInBack, fadein-100',
          class: 'font-neutra text-primary text-4xl font-medium uppercase'
        },      
      }
    },
    {
      component: 'TemplateCardWithImages',
      nav: 'Qui',
      bind: {
        class: 'bg-white',
      },
      params: {
        subTitle: { 
          text: '', 
          class: 'font-neutra-thin text-black font-bold uppercase', 
          animation: 'up-100, fadein' },
        title: { 
          text: 'Qui sommes-nous?', 
          class: 'font-neutra-condensed text-4xl text-primary font-extrabold uppercase', 
          animation: 'up-50, fadein' },
        content: { 
          text: `L’entreprise Madame Karine a été fondée en 2009 par Karine Perron recherchiste audiovisuelle et membre de l’Association des archivistes audiovisuels du Canada. Dix ans plus tard, Madame Karine acquière la collection Allo Police dans le but de conserver ce merveilleux patrimoine québécois riche de 50 ans d’histoire criminelle.  En 2023, elle s’est officiellement agrandit pour dévernir Archives Madame Karine inc., une équipe de recherche spécialisée en audiovisuelle.<br/><br/>Dynamiques curieuses et consciencieuses, notre efficacité hors pair saura vous convaincre de nous confier vos projets pour votre plus grande tranquillité d’esprit.`, 
          class: 'text-black-900 text-lg', 
          animation: 'up-25, fadein' },
        images: [
          {
            src: `/assets/images/AP-D0340-043-COFFIN-WILBERT.jpeg`,
            alt: 'AP-D0340-04',
            animation: 'up, fadein' 
          },
          {
            src: `/assets/images/AP-D0307-027-EBOULEMENTS-1974.jpeg`,
            alt: 'AP-D0307-027',
            animation: 'down, fadein' 
          },
        ],
      }
    },
    {
      component: 'TemplateCardWithImages',
      nav: 'Services',
      bind: {
        class: 'bg-primary',
      },
      params: {
        subTitle: { 
          text: '', 
          class: 'font-neutra-thin text-white font-bold uppercase', 
          animation: 'up-100, fadein' },
        title: { 
          text: 'Nos services', 
          class: 'font-neutra-condensed text-4xl text-black-900 font-extrabold uppercase', 
          animation: 'up-50, fadein' },
        content: { 
          text: `Nous proposons un service clé en main aux producteurs télévisuels, musées, éditeurs et aux producteurs multimédias. Dès la première ébauche de votre projet, nous pouvons vous guider pour élaborer un budget et sa faisabilité légale. Nous offrons la recherche, la négociation et la libération des droits de diffusion et grâce à un méthodologie rigoureuse nous suivons le processus du début à la fin en collaboration étroite avec vos équipes.`, 
          class: 'text-white text-lg', 
          animation: 'up-25, fadein' },
        images: [
          {
            src: `/assets/images/AP-D00709-03-METRO-MTL.jpeg`,
            alt: 'AP-D0340-04',
            animation: 'up, fadein' 
          },
          {
            src: `/assets/images/AP-D00709-05-METRO-MTL.jpeg`,
            alt: 'AP-D0307-027',
            animation: 'down, fadein' 
          },
        ],
      }
    },
    {
      component: 'TemplateCardWithImages',
      nav: 'Collection',
      bind: {
        class: 'bg-white',
      },
      params: {
        subTitle: { 
          text: '', 
          class: 'font-neutra-thin text-black font-bold uppercase', 
          animation: 'up-100, fadein' },
        title: { 
          text: 'Notre Collection', 
          class: 'font-neutra-condensed text-4xl text-primary font-extrabold uppercase', 
          animation: 'up-50, fadein' },
        content: { 
          text: `Nous proposons un service clé en main aux producteurs télévisuels, musées, éditeurs et aux producteurs multimédias. Dès la première ébauche de votre projet, nous pouvons vous guider pour élaborer un budget et sa faisabilité légale. Nous offrons la recherche, la négociation et la libération des droits de diffusion et grâce à un méthodologie rigoureuse nous suivons le processus du début à la fin en collaboration étroite avec vos équipes.`, 
          class: 'text-black text-lg', 
          animation: 'up-25, fadein' },
        images: [
          {
            src: `/assets/images/JOURNAL ALLO POLICE.jpeg`,
            alt: 'AP-D0340-04',
            animation: 'up, fadein' 
          },
          {
            src: `/assets/images/AP-D00708-04-MONTREAL-OF-SET.jpeg`,
            alt: 'AP-D0307-027',
            animation: 'down, fadein' 
          },
        ],
      }
    },
    {
      component: 'TemplateCardWithClients',
      nav: 'Nos clients',
      params: {
        background: {
          src: `/assets/images/AP-D00666-25-DELUGE-THETFORD.jpeg`,
          animation: 'down-15, fadein'
        },
        subTitle: { 
          text: '', 
          class: 'font-neutra-thin text-white font-bold uppercase', 
          animation: 'up-100, fadein' },
        title: { 
          text: 'Nos clients', 
          class: 'font-neutra-condensed text-4xl text-primary font-extrabold uppercase', 
          animation: 'up-50, fadein' },
        content: { 
          text: ``, 
          class: 'text-white text-lg', 
          animation: 'up-25, fadein' },
        clients: [
          'Les Productions Pixcom',
          'KOTV',
          'TORQ Le Groupe',
          'Saturne 5',
          'Trio Orange',
          'Groupe Fair-Play',
          'Babel Films',
          'Zone 3',
          'Couzin Films',
          'Office National du Film du Canada',
          'Radio-Canada',
          'Les productions Déferlantes',
          'Picbois productions',
          'Blimp Télé',
          'Les productions Avanti-Toast Inc.',
          'Urbania',
          'Sphère Média Inc.',
          'Terre Innue Productions',
          'Télévision Illimitée',
          'A Média inc.',
          'Iprod inc',
          'Bazzo Bazzo',
          'Comedia Ha !',
          'Savoir Média',
          'Les Films Du Désert Blanc',
          'Roméo et Fils',
          'TC Média Livres',
          'Les Éditions de l’Homme',
          'Dokoma',
          'Musée Pointe-à-Callière',
          'Musée Maritime du Québec',
        ],
        images: [
          {
            src: `/assets/images/JOURNAL ALLO POLICE.jpeg`,
            alt: 'AP-D0340-04',
            animation: 'up, fadein' 
          },
          {
            src: `/assets/images/AP-D00708-04-MONTREAL-OF-SET.jpeg`,
            alt: 'AP-D0307-027',
            animation: 'down, fadein' 
          },
        ],
      }
    },
    {
      component: 'TemplateCardWithItems',
      nav: 'Équipe',
      bind: {
        class: 'bg-white',
      },
      params: {
        subTitle: { 
          text: '', 
          class: 'font-neutra-thin font-bold uppercase', 
          animation: 'up-100, fadein' },
        title: { 
          text: 'Notre équipe', 
          class: 'font-neutra-condensed text-4xl text-primary font-extrabold uppercase', 
          animation: 'up-50, fadein' },
        content: { 
          text: ``, 
          class: 'text-lg', 
          animation: 'up-25, fadein' },
        items: [
          {
            name: 'Karine Perron',
            title: 'Présidente / Recherchiste audiovisuelle sénior',
            email: 'kperron@madamekarine.com',
            src: `/assets/team/Karine Perron.png`,
            animation: 'up-33, fadein' 
          },
          {
            name: 'Zoé Rabatel',
            title: 'Recherchiste audiovisuelle',
            email: 'zrabatel@madamekarine.com',
            src: `/assets/team/Zoe Rabatel.JPEG`,
            animation: 'up-76, fadein' 
          },
          {
            name: 'Léa Formigli',
            title: 'Recherchiste audiovisuelle',
            email: 'lformigli@madamekarine.com',
            src: `/assets/team/Lea Formigli.jpg`,
            animation: 'up-100, fadein' 
          },
          {
            name: 'Emy Langlois-Brien',
            title: 'Recherchiste audiovisuelle junior /Responsable de la collection Allo Police',
            email: 'elangloisbrien@madamekarine.com',
            src: `/assets/team/Emy Langlois-Brien.jpg`,
            animation: 'up-100, fadein' 
          },
        ],
      }
    }
  ]
})

const links = computed(() => {
  const { sections = [] } = config.value
  return config.value.sections.reduce((a, section) => {
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
            <li class="md:px-4 md:py-2 hover:text-grey-500">Téléphone : {{ config.phone }}</li>
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
