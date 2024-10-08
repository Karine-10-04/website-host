<script setup>
    import { animate } from '@/utils/animations.js'
 
    const { delta, index, params } = defineProps(['delta', 'index', 'params'])

    const titleStyle = animate(params.title.animation)
    const subTitleStyle = animate(params.subTitle.animation)
    const contentStyle = animate(params.content.animation)
    const items = (params.items || []).map(item => ({
        ...item, animation: animate(item.animation)
    }))
</script>
<template>
    <div class="min-h-screen flex flex-col">
        <div class="w-full min-h-screen max-w-6xl mx-auto px-4 md:px-6 py-24">
            <div class="flex flex-col lg:h-full lg:flex-row justify-between space-y-4 space-y-reverse lg:space-y-0 lg:space-x-20">
                <div class="flex-1 flex lg:opacity-[var(--stick-visibility)] transition-opacity duration-300 order-1 lg:order-none items-center">
                    <div class="space-y-3">
                        <div :class="`inline-flex ${params.subTitle.class}`"
                            :style="subTitleStyle(delta)">{{ params.subTitle.text }}</div>
                        <h2 :class="params.title.class"
                            :style="titleStyle(delta)">{{ params.title.text }}</h2>
                        <p :class="params.content.class"
                            :style="contentStyle(delta)">{{ params.content.text }}</p>
                    </div>
                </div>
                <div class="flex-1 flex flex-col lg:scale-[var(--stick-scale)] lg:opacity-[var(--stick-visibility)] place-content-center md:order-last md:mt-20">
                    <div v-for="item in items" 
                        class="flex flex-row space-y-4 space-y-reverse lg:space-y-0 space-x-10 object-scale-down drop-shadow-md rounded-md m-auto my-4"
                        :style="item.animation(delta)">
                        
                        <img class="min-w-32 min-h-32 w-32 h-32 rounded-full shadow-lg" :src="item.src" :alt="item.alt" />
                        <div class="block">
                            <h5 class="font-neutra-condensed text-primary mb-2 text-xl font-medium leading-tight">{{ item.title }}</h5>
                            <p class="mb-4 text-base">{{ item.text }}</p>
                            <!--
                            <button
                            type="button"
                            class="inline-block rounded bg-primary px-6 pb-2 pt-2.5 text-xs font-medium uppercase leading-normal text-white shadow-primary-3 transition duration-150 ease-in-out hover:bg-primary-accent-300 hover:shadow-primary-2 focus:bg-primary-accent-300 focus:shadow-primary-2 focus:outline-none focus:ring-0 active:bg-primary-600 active:shadow-primary-2 dark:shadow-black/30 dark:hover:shadow-dark-strong dark:focus:shadow-dark-strong dark:active:shadow-dark-strong"
                            data-twe-ripple-init
                            data-twe-ripple-color="light">
                            Button
                            </button>
                            -->
                      </div>
                    </div>

                </div>
            </div>
        </div>
    </div>    
</template>