<script setup>
    import { animate } from '@/utils/animations.js'
    import { computed } from 'vue';

    const { delta, index, params } = defineProps(['delta', 'index', 'params'])

    const title1Style = animate(params.title1.animation) 
    const title2Style = animate(params.title2.animation) 
    const title3Style = animate(params.title3.animation) 

    const background = computed(() => {
        const { background: { url } = {} } = params
        return `url("/assets/${url}") no-repeat center center fixed`
    })
</script>
<template>
    <div>
        <div id="wrapper"
            class="relative flex flex-col justify-center justify-items-center items-center h-screen space-y-0"
            :style="{ background }"
            >
            <h1 :style="title1Style(delta)"
                :class="params.title1.class" v-html="params.title1.text" /> 
                <h1 :style="title2Style(delta)"
                :class="params.title2.class" v-html="params.title2.text" /> 
                <h1 :style="title3Style(delta)"
                :class="params.title3.class" v-html="params.title3.text" /> 
        </div>
    </div>
</template>
<style scoped>
    #wrapper {
        background-size: cover !important; 
    }
</style>