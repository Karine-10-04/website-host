<script setup>
    import { animate } from '@/utils/animations.js'
 
    const { delta, index, params } = defineProps(['delta', 'index', 'params'])

    const title1Style = animate(params.title1.animation) 
    const title2Style = animate(params.title2.animation) 
</script>
<template>
    <div>
        <div class="relative flex flex-col justify-center justify-items-center items-center h-screen space-y-0">
            <h1 :style="title1Style(delta)"
                :class="params.title1.class">{{ params.title1.text }}</h1> 
            <h1 :style="title2Style(delta)"
                :class="params.title2.class">{{ params.title2.text }}</h1> 
        </div>
    </div>
</template>