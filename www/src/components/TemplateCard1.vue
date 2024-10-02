<script setup>
    import { animate } from '@/utils/animations.js'
 
    const { delta, index, params } = defineProps(['delta', 'index', 'params'])

    const titleStyle = animate(params.title.animation)
    const subTitleStyle = animate(params.subTitle.animation)
    const contentStyle = animate(params.content.animation)
    const images = (params.images || []).map(image => ({
        ...image, animation: animate(image.animation)
    }))
</script>
<template>
    <div class="min-h-screen flex flex-col">
        <div class="w-full min-h-screen max-w-6xl mx-auto px-4 md:px-6 py-24">

            <div class="flex flex-col lg:h-full lg:flex-row space-y-4 space-y-reverse lg:space-y-0 lg:space-x-20">
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
                <div class="flex-1 flex items-center lg:scale-[var(--stick-scale)] lg:opacity-[var(--stick-visibility)] place-content-center md:order-last md:mt-20">
                    <img v-for="image in images" 
                    :class="image.class" :style="`height: 33vh; ${image.animation(delta)}`" :src="image.src" :alt="image.alt" />
                </div>
            </div>
        </div>
    </div>    
</template>