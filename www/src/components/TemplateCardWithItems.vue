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
                <div class="flex-1 flex lg:opacity-[var(--stick-visibility)] order-1 lg:order-none items-center">
                    <div class="space-y-3">
                        <div :class="`inline-flex ${params.subTitle.class}`"
                            :style="subTitleStyle(delta)">{{ params.subTitle.text }}</div>
                        <h2 :class="params.title.class"
                            :style="titleStyle(delta)">{{ params.title.text }}</h2>
                        <p :class="params.content.class"
                            :style="contentStyle(delta)">{{ params.content.text }}</p>
                    </div>
                </div>
                <div class="flex-1 flex flex-col lg:scale-[var(--stick-scale)] lg:opacity-[var(--stick-visibility)] md:order-last md:mt-20">
                    <div class="grid h-full">
                        <div v-for="item in items" 
                            class="flex flex-row space-y-4 space-y-reverse lg:space-y-0 space-x-6 object-scale-down drop-shadow-md m-auto my-4 min-w-full"
                            :style="item.animation(delta)">
                            <img class="self-center object-scale-down max-w-16" :src="item.src" :alt="item.alt" />
                            <div class="self-center block">
                                <h5 class="font-neutra-condensed text-primary mb-2 text-xl font-medium leading-tight">{{ item.name }}</h5>
                                <h5 class="font-neutra-medium text-black-900 mb-2 text-xl font-medium leading-tight">{{ item.title }}</h5>
                                <p class="font-neutra text-base"><a :href="`mailto:${item.email}`">{{ item.email }}</a></p>
                                <p v-if="item.text"
                                    class="mb-4 text-base">{{ item.text }}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>    
</template>